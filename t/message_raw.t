#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use App::Exobrain;
use Test::More;

my $exobrain = App::Exobrain->new;

my $msg = $exobrain->message(
    namespace => 'TEST',
    source    => 'TEST',
    data      => { foo => 1, bar => 2 },
    raw       => { foo => 1, bar => 2 },
    summary   => "Test msg",
);

isa_ok($msg, 'App::Exobrain::Message::Raw');
ok($msg->DOES('App::Exobrain::Message'), 'does App::Exobrain::Message');

done_testing;
