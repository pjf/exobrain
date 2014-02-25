#!/usr/bin/perl -w

package Exobrain::Agent::Testing;

use Moose;
use Test::More;
use Exobrain::Test;

with 'Exobrain::Agent';

ok(1, "Can consume Exobrain::Agent");

done_testing;
