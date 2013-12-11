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

my $message = $exobrain->intent('Idone',
    message => 'Hello World',
);

ok($message->DOES('App::Exobrain::Intent'), 'Does Exobrain::Intent');
isa_ok($message,'App::Exobrain::Intent::Idone');

is($message->namespace, 'Intent::Idone', 'namespace');
is($message->message, 'Hello World', 'message');
is($message->summary, 'Hello World', 'summary');

done_testing;
