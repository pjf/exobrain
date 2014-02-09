#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use Exobrain;
use Test::More;

my $exobrain = Exobrain->new;

isa_ok($exobrain,'Exobrain');

# Build a sample tweet message and test

my $message = $exobrain->intent('PersonalLog',
    message => 'Hello World',
);

ok($message->DOES('Exobrain::Intent'), 'Does Exobrain::Intent');
isa_ok($message,'Exobrain::Intent::PersonalLog');

is($message->namespace, 'Intent::PersonalLog', 'namespace');
is($message->message, 'Hello World', 'message');
is($message->summary, 'Hello World', 'summary');

done_testing;
