#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;
use Exobrain;
use Test::More;

my $exobrain = Exobrain->new;

isa_ok($exobrain,'Exobrain');

# Build a sample geo message and test

my $message = $exobrain->measure('Geo',
    source => 'Foursquare',
    user    => 'pjf',
    user_name => 'Paul Fenwick',
    is_me   => 1,
    poi => {
        id   => 'abc01234ff',
        name => 'Some place',
    },
    message => 'Drinking a coffee',
);

ok($message->DOES('Exobrain::Message'), 'Does Exobrain::Message');
isa_ok($message,'Exobrain::Measurement::Geo');

is($message->user,'pjf','user field');
ok($message->is_me,'self field');
is($message->message,'Drinking a coffee','message field');
isa_ok($message->poi,'Exobrain::Measurement::Geo::POI');
is($message->poi->source, 'Foursquare', 'POI source');

is($message->summary, qq{Paul Fenwick is at Some place with message: "Drinking a coffee" ( via Foursquare ) [Me]}, "Summary msg");

is($message->namespace, 'Measurement::Geo');

done_testing;
