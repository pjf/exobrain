#!/usr/bin/perl -w

package Exobrain::Source::Testing;

use Moose;
use Test::More;
use Exobrain::Test;

with 'Exobrain::Source';

ok(1, "Can consume Exobrain::Source");

done_testing;
