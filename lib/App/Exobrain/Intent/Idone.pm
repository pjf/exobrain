package App::Exobrain::Intent::Idone;

use v5.10.0;
use strict;
use warnings;

use Moose;
use Carp;

# A very simple class that allows information to be added to
# idonethis

has summary => (is => 'ro', isa => 'Str', required => 1);

with 'App::Exobrain::Message';

around BUILDARGS => sub {
    my ($orig, $class, @raw_args) = @_;

    my %args = @raw_args;

    $args{message} or croak "Intent::Idone requires a message parameter";

    $args{timestamp}  ||= time();
    $args{data}       ||= { summary => $args{message} };
    $args{raw}        ||= { summary => $args{message} };
    $args{summary}    ||= $args{message};
    $args{namespace}  ||= 'INTENT+IDONE';
    $args{source}     ||= $0;

    return $class->$orig(\%args);
};

1;
