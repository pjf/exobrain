#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use Test::Most;

use Exobrain;
use Exobrain::Test;

# For making dummy raw packets
my %raw_args = (
    source    => 'test',
    data      => {},
    summary   => 'test',
    namespace => 'test',
    raw       => {},
    nosend    => 1,
);

my %imap_args = (
    server => 'test.example.com',
    user   => 'test',
    mailbox=> 'INBOX',
    count  => 10,
);
   
my $exobrain = Exobrain->new;

# Verify our component is not installed

TODO: {
    local $TODO = "Test a class that *isn't* autoloaded";
    dies_ok( sub { Exobrain::Message::Raw->new(%raw_args) } );
}

# Now load our component

my $class = $exobrain->_load_component('Message::Raw');

is($class,'Exobrain::Message::Raw');

# Now make sure we can use it.

lives_ok( sub { Exobrain::Message::Raw->new(%raw_args) } );

# Now let's try a measurement

dies_ok( sub { Exobrain::Measurement::Mailbox->new(%raw_args, %imap_args)});

my $measurement = $exobrain->measure('Mailbox',%raw_args, %imap_args);

isa_ok($measurement, 'Exobrain::Measurement::Mailbox');

done_testing;
