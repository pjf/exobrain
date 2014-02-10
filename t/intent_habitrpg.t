#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use Exobrain;
use Exobrain::Test;
use Test::Most;

my $exobrain = Exobrain->new;

isa_ok($exobrain,'Exobrain');

# Invalid ways of generatingt his intent

dies_ok { $exobrain->intent('HabitRPG', direction => 'up'   ) } "no task";
dies_ok { $exobrain->intent('HabitRPG', task => 'test-goal' ) } "no direction";


{
    # Build a sample (valid) message and test

    my $message = $exobrain->intent('HabitRPG',
        task => 'test-goal',
        direction => 'up',
        public => 0,
    );

    ok($message->DOES('Exobrain::Intent'), 'Does Exobrain::Intent');
    isa_ok($message,'Exobrain::Intent::HabitRPG');

    is($message->namespace, 'Intent::HabitRPG','namespace');

    is($message->task,'test-goal','task');
    is($message->direction,'up','direction');

    like($message->summary,qr/Move test-goal up/,'summary');

}

{

    # Test default public flag

    my $message = $exobrain->intent('HabitRPG',
        task => 'test-goal',
        direction => 'up',
    );

    is( $message->public, 0, 'default 0 public flag');
}


done_testing;
