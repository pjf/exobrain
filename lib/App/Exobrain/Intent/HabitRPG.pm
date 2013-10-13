package App::Exobrain::Intent::HabitRPG;

use v5.10.0;
use strict;
use warnings;

use Moose;
use Carp;

has summary => (is => 'ro', isa => 'Str', required => 1);

# This provides a message which HabitRPG sinks will act upon.
# Intent::Tweet->new( task => $id, direction => 'up', public => 1 );

with 'App::Exobrain::Message';

around BUILDARGS => sub {
    my ($orig, $class, @raw_args) = @_;

    my %args = @raw_args;

    $args{task}      or croak "Intent::HabitRPG requires a task";
    $args{direction} or croak "Intent::HabitRPG requires a direction";

    my $public = $args{public} || 0;

    my $payload = {
        task      => $args{task},
        direction => $args{direction},
        public    => $public,
    };

    $args{timestamp}  ||= time();
    $args{data}       ||= $payload;
    $args{raw}        ||= $payload;
    $args{summary}    ||= "HabitRPG: Move $args{task} in $args{direction}";
    $args{namespace}  ||= 'INTENT+HABITRPG';
    $args{source}     ||= $0;

    return $class->$orig(\%args);
};

1;
