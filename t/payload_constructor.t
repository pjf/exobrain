#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

package App::Exobrain::Test;
use Moose;

BEGIN { with 'App::Exobrain::Message'; }

payload 'foo' => (isa => 'Str');
has     'bar' => (isa => 'Int', is => 'ro');

package main;
use Test::More;

my $obj = App::Exobrain::Test->new(foo=> 'Foo', bar => 42, timestamp=>1000);

my $meta = $obj->meta;

is($obj->foo, 'Foo', "foo is set");
is($obj->bar, 42,    "bar is set");
is($obj->timestamp, 1000, "Timestamp manual setting works");

is($obj->data->{foo}, 'Foo', "Foo is in data packet");
is(scalar (keys $obj->data), 1, "Only one attribute in data packet");

ok(
    ! $meta->get_attribute('bar')->does('App::Exobrain::Message::Trait::Payload'),
    "Bar is not a payload attribute"
);

ok(
    $meta->get_attribute('foo')->does('App::Exobrain::Message::Trait::Payload'),
    "Foo is a payload attribute"
);

my $time = time();
my $obj2 = App::Exobrain::Test->new(foo=> 'Foo', bar => 42);

ok (
    abs($time - $obj2->timestamp) < 1000,
    "Auto timestamps work " . $obj2->timestamp
);

done_testing;
