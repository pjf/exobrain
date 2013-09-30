#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

package App::Exobrain::Test;
use Moose;

BEGIN { with 'App::Exobrain::Message'; }

payload 'foo' => (isa => 'Str');
has 'bar' => (isa => 'Int', is => 'ro');

package main;
use Test::More;

my $obj = App::Exobrain::Test->new(foo=> 'Foo', bar => 42);

my $meta = $obj->meta;

is($obj->foo, 'Foo', "foo is set");
is($obj->bar, 42,    "bar is set");

ok(
    ! $meta->get_attribute('bar')->does('App::Exobrain::Message::Trait::Payload'),
    "Bar is not a payload attribute"
);

ok(
    $meta->get_attribute('foo')->does('App::Exobrain::Message::Trait::Payload'),
    "Foo is a payload attribute"
);

done_testing;
