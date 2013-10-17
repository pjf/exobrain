package App::Exobrain::Intent::Beeminder;

use v5.10.0;
use strict;
use warnings;

use Moose;
use Carp;

# This provides a message which Beeminder sinks will act upon.
# Intent::Beeminder->new( goal => 'inbox', value => 52 );

has summary => (is => 'ro', isa => 'Str', required => 1 );

# XXX - This isn't a great solution, because we're not a "raw"
# message. But it does the right thing for encoding and transmitting
# our payload.

extends 'App::Exobrain::Message::Raw';

around BUILDARGS => sub {
    my ($orig, $class, @raw_args) = @_;

    my %args = @raw_args;

    my $goal    = $args{goal}  or croak "Intent::Beeminder requires a goal";
    my $value   = $args{value} or croak "Intent::Beeminder requires a value";
    my $comment = $args{comment} // undef;

    my $payload = {
        goal      => $goal,
        value     => $value,
        comment   => $comment,
    };

    $args{timestamp}  ||= time();
    $args{data}       ||= $payload;
    $args{raw}        ||= $payload;
    $args{summary}    ||= "Beeminder: Set $goal to $value";
    $args{summary}     .= " ($comment)" if defined $comment;
    $args{namespace}  ||= 'INTENT+BEEMINDER';
    $args{source}     ||= $0;

    return $class->$orig(\%args);
};

1;
