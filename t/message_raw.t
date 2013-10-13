#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use App::Exobrain;
use App::Exobrain::Message::Raw;
use Test::More;
use JSON::Any;

my $j = JSON::Any->new;

my $exobrain = App::Exobrain->new;

my $data = { foo => 1, bar => 2 };
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

my $raw_msg = App::Exobrain::Message::Raw->new( [
    'EXOBRAIN_TEST_TESTING',
    $j->encode( { time => time() } ),
    $summary,
    $j->encode( $data ),
    $j->encode( $data ),
] );

foreach my $m ($msg, $raw_msg) {

    isa_ok($msg, 'App::Exobrain::Message::Raw');
    ok($msg->DOES('App::Exobrain::Message'), 'does App::Exobrain::Message');

    is_deeply($msg->data, $data, "data preserved");
    is_deeply($msg->raw,  $data, "raw  preserved");

    is($msg->summary,  $summary, "summay preserved");
    is($msg->namespace, $namespace, 'namespace preserved');
    is($msg->source, $source, 'source preserved');

}

done_testing;
