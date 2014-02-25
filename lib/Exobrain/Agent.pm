package Exobrain::Agent;
use Moose::Role;
use Exobrain;
use Exobrain::Cache;
use Method::Signatures;
use Exobrain::Types qw(Exobrain);

has exobrain => (
    is => 'ro',
    isa => Exobrain,
    lazy => 1,
    builder => '_build_exobrain',
);

sub _build_exobrain { return Exobrain->new; }

has config => (
    is => 'ro',
    lazy => 1,
    builder => '_build_config',
);

# By using the class name as the heading for our config, it's easy
# to clearly tell which config belongs where. Consumers can always
# call $exobrain->config if they want to access the top-level one.

method _build_config() {
    my $class = ref($self);
    return $self->exobrain->config->{$class};
}

has cache => (
    is => 'ro',
    lazy => 1,
    builder => '_build_cache',
);

method _build_cache() {
    my $class = ref($self);

    return Exobrain::Cache->new( namespace => $class );
}

1;
