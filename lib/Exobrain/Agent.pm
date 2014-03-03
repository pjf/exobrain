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

# Our component name is by default the same as the class name with
# 'Exobrain::Agent::' stripped off. However different modules can
# declare themselves to be part of the same component, thereby sharing
# config and cache.

has component => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_component',
);

method _build_component() {
    if (my $method = $self->can("component_name") ) {
        return $self->$method;
    }

    my $component = ref($self);
    $component =~ s/Exobrain::Agent:://;
    return $component;
}

has config => (
    is => 'ro',
    lazy => 1,
    builder => '_build_config',
);

# By using the component name as the heading for our config, it's easy
# to clearly tell which config belongs where. Consumers can always
# call $exobrain->config if they want to access the top-level one.

method _build_config() {
    return $self->exobrain->config->{ $self->component };
}

has cache => (
    is => 'ro',
    lazy => 1,
    builder => '_build_cache',
);

method _build_cache() {
    return Exobrain::Cache->new( namespace => $self->component );
}

1;
