#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use Test::More;
use App::Exobrain;
use App::Exobrain::Measurement::Mailbox;

my $exobrain = App::Exobrain->new;

my %raw = (
    server  => 'imap.example.com',
    user    => 'urist',
    mailbox => 'INBOX',
    count   => 42,
    source  => 'TEST',
);

my $msg1 = App::Exobrain::Measurement::Mailbox->new(
    %raw,
    raw => \%raw,
);

my $msg2 = $exobrain->measure('Mailbox',
    %raw,
    raw => \%raw,
);

my $i = 1;

foreach my $msg ($msg1, $msg2) {
    diag "Examining msg$i"; $i++;

    isa_ok( $msg, 'App::Exobrain::Measurement::Mailbox');

    # No does_ok in Test::More?
    ok($msg->DOES('App::Exobrain::Message'), 'does Exobrain::Message');

    can_ok($msg, qw(send_msg data dump _frames));
    can_ok('App::Exobrain::Message', 'send_msg');

    foreach my $attr (keys %raw) {
        is ($msg->$attr, $raw{$attr}, "Attribute $attr");
    }

    is($msg->summary, "urist @ imap.example.com / INBOX has 42 messages");

    is_deeply( $msg->raw, \%raw, "Raw data preserved" );

    is($msg->namespace, 'Measurement::Mailbox');
}

done_testing;
