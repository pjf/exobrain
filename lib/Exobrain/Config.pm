package Exobrain::Config;
use strict;
use warnings;
use parent 'Config::Tiny';

# Bare-bones hack to wrap Config::Tiny

# TODO: Use an exobrain.config.d/ or similar multi-file structure.

sub new {
    my ($class) = @_;

    my $file = $ENV{EXOBRAIN_CONFIG} || "$ENV{HOME}/.exobrainrc";

    my $self = $class->read($file);

    $self or die "Cannot read config - " . Config::Tiny->errstr;

    return $self;
}

1;
