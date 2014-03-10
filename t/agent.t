#!/usr/bin/perl -w
use Test::More;

package Exobrain::Agent::Testing;

use Moose;
use Test::More;
use Exobrain::Test;

with 'Exobrain::Agent';

::ok(1, "Can consume Exobrain::Agent");

package main;

my $agent = Exobrain::Agent::Testing->new;

isa_ok($agent->exobrain,  'Exobrain');
isa_ok($agent->json,      'JSON::Any');
is(    $agent->component, 'Testing');

TODO: {
    local $TODO = "Because this returns a sub-hash, of our config, it's not an obejct";
    # We should probably just be checking for a known key.
    isa_ok($agent->config,    'Exobrain::Config');
}

TODO: {
    local $TODO = "This returns a CHI object, which is probably fine.";
    isa_ok($agent->cache,     'Exobrain::Cache');
}

done_testing;
