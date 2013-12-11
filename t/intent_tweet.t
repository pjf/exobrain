#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use App::Exobrain;
use Test::More;

my $exobrain = App::Exobrain->new;

isa_ok($exobrain,'App::Exobrain');

# Build a sample tweet message and test

my $message = $exobrain->intent('Tweet',
    tweet => 'Hello World',
);

ok($message->DOES('App::Exobrain::Intent'), 'Does Exobrain::Intent');
isa_ok($message,'App::Exobrain::Intent::Tweet');

is($message->namespace, 'Intent::Tweet', 'namespace');
is($message->tweet, 'Hello World', 'tweet');

done_testing;
