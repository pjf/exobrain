package App::Exobrain::Intent::Tweet;

use v5.10.0;
use strict;
use warnings;

use Moose;
use Carp;

# This provides a message which twitter sinks will act upon.
# Intent::Tweet->new( tweet => 'Hello World' );

extends 'App::Exobrain::Message';

around BUILDARGS => sub {
    my ($orig, $class, @raw_args) = @_;

    my %args = @raw_args;

    $args{tweet} or croak "Intent::Tweet requires a tweet parameter";

    if (length $args{tweet} > 140) {
        carp "Tweet trimmed to 140 characters";
        $args{tweet} = substr(0,140,$args{tweet});
    }

    $args{timestamp}  ||= time();
    $args{data}       ||= { summary => $args{tweet} };
    $args{raw}        ||= { summary => $args{tweet} };
    $args{summary}    ||= $args{tweet};
    $args{namespace}  ||= 'INTENT+TWEET';
    $args{source}     ||= $0;

    return $class->$orig(\%args);
};

1;
