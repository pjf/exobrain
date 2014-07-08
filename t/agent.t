#!/usr/bin/perl -w
use Test::More;

package Exobrain::Agent::Testing;

use Moose;
use Test::More;
use Exobrain::Test;

BEGIN { with 'Exobrain::Agent'; }

::ok(1, "Can consume Exobrain::Agent");

cached cached_value => (
    isa => 'Int',
    default => 0,
);

package main;

my $agent = Exobrain::Agent::Testing->new;

isa_ok($agent->exobrain,  'Exobrain');
isa_ok($agent->json,      'JSON::Any');
is(    $agent->component, 'Testing');

# Set our cached value on our original object,
# and test newly minted objects pick that up.

foreach my $v (0..2) {
    $agent->cached_value($v);

    my $agent2 = Exobrain::Agent::Testing->new;

    is($agent2->cached_value, $v, "Cached value test");
}

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
