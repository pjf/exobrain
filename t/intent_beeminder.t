#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use App::Exobrain;
use Test::Most;

my $exobrain = App::Exobrain->new;

isa_ok($exobrain,'App::Exobrain');

# Invalid ways of generating this intent

dies_ok { $exobrain->intent('Beeminder', goal => 'foo' ) } "no goal";
dies_ok { $exobrain->intent('Beeminder', value => 3    ) } "no value";

{
    # Build a sample (valid) message and test

    my $message = $exobrain->intent('Beeminder',
        goal => 'floss',
        value => 3,
        comment => "Test Comment",
    );

    ok($message->DOES('App::Exobrain::Intent'), 'Does Exobrain::Intent');
    isa_ok($message,'App::Exobrain::Intent::Beeminder');

    is($message->namespace, 'Intent::Beeminder','namespace');

    is($message->goal,'floss', 'goal');
    is($message->value,3,'value');
    is($message->comment, 'Test Comment', 'comment');

    like($message->summary, qr/Set floss to 3/, 'Basic summary');
    like($message->summary, qr/Test Comment/,   '...includes comment');
}

done_testing;
