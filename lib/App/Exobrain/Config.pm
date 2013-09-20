package App::Exobrain::Config;

use parent 'Config::Tiny';

# Bare-bones hack to wrap Config::Tiny

sub new {
    my ($class) = @_;

    my $self = $class->read("$ENV{HOME}/.exobrainrc");

    $self or die "Cannot read config - " . Config::Tiny->errstr;

    return $self;
}

1;
