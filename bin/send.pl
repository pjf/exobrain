#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use App::Exobrain::Bus;

my $bus = App::Exobrain::Bus->new(
    type => 'PUB',
);

while (<>) {
    $bus->send($_);
}
