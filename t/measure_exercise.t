#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use Test::More;
use Exobrain;
use Exobrain::Test;

{
    package Exobrain::Measurement::Exercise::Test;

    use Moose;

    BEGIN { with 'Exobrain::Measurement::Exercise::Cardio'; }

}

my %raw = (
    calories => 100,
    km       => 2.5,
    seconds  => 7200,
    activity => 'running',
    is_me    => 1,
    nosend   => 1,
);

my $msg1 = Exobrain::Measurement::Exercise::Test->new(
    %raw,
    raw => \%raw,
);

is($msg1->calories, 100, 'calories');
is($msg1->km,       2.5, 'km'      );
is($msg1->seconds, 7200, 'seconds' );
is($msg1->activity, 'running', 'activity');

like($msg1->summary, qr/running for 7200 seconds for 2.5 km/, 'summary');

done_testing;
