#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use Getopt::Std;
use Exobrain::Bus;

my $bus = Exobrain::Bus->new(
    type => 'SUB',
);

say @ARGV;

my %opts = ( v => 0 );

getopts('v', \%opts);

if ($opts{v}) { say "Verbose mode enabled"; }

while (1) {
    if ($opts{v}) {
        say $bus->get->dump;      # Verbose
        say "-" x 50;
    }
    else {
        say $bus->get->summary;
    }
}
