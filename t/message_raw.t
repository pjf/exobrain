#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use Exobrain;
use Exobrain::Message::Raw;
use Test::More;
use JSON::Any;

my $j = JSON::Any->new;

my $exobrain = Exobrain->new;

my $data = { 
    mailbox => 'INBOX',
    count => 42,
    server => 'imap.example.com',
    user  => 'pjf',
};

my $summary = "Test msg";

my $namespace = 'TEST';
my $source    = 'TEST';

my $msg = $exobrain->message(
    namespace => $namespace,
    source    => $source,
    data      => $data,
    raw       => $data,
    summary   => $summary,
);

# Testing the 'off the wire' build by frames syntax.
# This should probably be invoked somehow other than a flat 'new'

my $raw_msg = Exobrain::Message::Raw->new( [
    'EXOBRAIN_TEST_TESTING',
    $j->encode( { time => time() } ),
    $summary,
    $j->encode( $data ),
    $j->encode( $data ),
] );

foreach my $m ($msg, $raw_msg) {

    isa_ok($msg, 'Exobrain::Message::Raw');
    ok($msg->DOES('Exobrain::Message'), 'does Exobrain::Message');

    is_deeply($msg->data, $data, "data preserved");
    is_deeply($msg->raw,  $data, "raw  preserved");

    is($msg->summary,  $summary, "summay preserved");
    is($msg->namespace, $namespace, 'namespace preserved');
    is($msg->source, $source, 'source preserved');

}

# Convert to a class.

my $mailbox = $msg->to_class('Measurement::Mailbox');

isa_ok($mailbox, 'Exobrain::Measurement::Mailbox');
is($mailbox->count, 42, 'mailbox count');


done_testing;
