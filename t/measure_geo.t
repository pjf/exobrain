#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use App::Exobrain;
use Test::More;

my $exobrain = App::Exobrain->new;

isa_ok($exobrain,'App::Exobrain');

# Build a sample geo message and test

my $message = $exobrain->measure('Geo',
    source => 'Foursquare',
    user    => 'pjf',
    user_name => 'Paul Fenwick',
    is_me   => 1,
#    poi     => App::Exobrain::Measurement::Geo::POI->new(
#        id   => 'abc01234ff',
#        name => 'Some place',
#    ),
    message => 'Drinking a coffee',
);

ok($message->DOES('App::Exobrain::Message'), 'Does Exobrain::Message');
isa_ok($message,'App::Exobrain::Measurement::Geo');

is($message->user,'pjf','user field');
ok($message->is_me,'self field');
is($message->message,'Drinking a coffee','message field');

done_testing;
