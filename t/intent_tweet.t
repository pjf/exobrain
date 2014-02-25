#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use Exobrain;
use Exobrain::Test;
use Test::More;
use Test::Deep;

my $exobrain = Exobrain->new;

isa_ok($exobrain,'Exobrain');

# Build a sample tweet message and test

my $message = $exobrain->intent('Tweet',
    tweet => 'Hello World',
    nosend => 1,
);

ok($message->DOES('Exobrain::Intent'), 'Does Exobrain::Intent');
isa_ok($message,'Exobrain::Intent::Tweet');

is($message->namespace, 'Intent::Tweet', 'namespace');
is($message->tweet, 'Hello World', 'tweet');

cmp_set( $message->roles, [qw(Message Intent)], "Roles" );

done_testing;
