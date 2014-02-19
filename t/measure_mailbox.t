#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use Test::More;
use Exobrain;
use Exobrain::Test;
use Exobrain::Measurement::Mailbox;

my $exobrain = Exobrain->new;

my %raw = (
    server  => 'imap.example.com',
    user    => 'urist',
    mailbox => 'INBOX',
    count   => 42,
    source  => 'TEST',
    nosend  => 1,
);

my $msg1 = Exobrain::Measurement::Mailbox->new(
    %raw,
    raw => \%raw,
);

my $msg2 = $exobrain->measure('Mailbox',
    %raw,
    raw => \%raw,
);

foreach my $msg ($msg1, $msg2) {
    isa_ok( $msg, 'Exobrain::Measurement::Mailbox');

    # No does_ok in Test::More?
    ok($msg->DOES('Exobrain::Message'), 'does Exobrain::Message');

    can_ok($msg, qw(send_msg data dump _frames));
    can_ok('Exobrain::Message', 'send_msg');

    foreach my $attr (keys %raw) {
        is ($msg->$attr, $raw{$attr}, "Attribute $attr");
    }

    is($msg->summary, "urist @ imap.example.com / INBOX has 42 messages");

    is_deeply( $msg->raw, \%raw, "Raw data preserved" );

    is($msg->namespace, 'Measurement::Mailbox');
}

done_testing;
