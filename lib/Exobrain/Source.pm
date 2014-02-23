package Exobrain::Source;
use Moose::Role;
use Exobrain;
use Method::Signatures;
use Exobrain::Types qw(Exobrain);

# Want to do init? Put it in BUILD.
# Need to poll something? Have a 'poll' method.
# Need to run something continuously? Put it in 'run'.

# TODO: We need something we can give to Ubic::Service::Common.
# A function which returns start/stop/status would be great.

# TODO: Check that at least 'poll' or 'run' is defined.
# TODO: Error (or at least feel uneasy) if both 'poll' and 'run' are defined.

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
    return $self->exobrain->{$class};
}

1;
