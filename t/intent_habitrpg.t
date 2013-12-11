#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use App::Exobrain;
use Test::Most;

my $exobrain = App::Exobrain->new;

isa_ok($exobrain,'App::Exobrain');

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

    ok($message->DOES('App::Exobrain::Intent'), 'Does Exobrain::Intent');
    isa_ok($message,'App::Exobrain::Intent::HabitRPG');

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
