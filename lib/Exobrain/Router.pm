package Exobrain::Router;
use v5.10.0;
use Moose;
use warnings;
use Method::Signatures;
use Carp qw(croak);
use ZMQ::LibZMQ2;
use ZMQ::Constants qw(ZMQ_SUB ZMQ_SUBSCRIBE ZMQ_PUB ZMQ_FORWARDER);

has subscriber => (is => 'ro', default => 'tcp://127.0.0.1:3546');     # Subscribers connect here
has publisher  => (is => 'ro', default => 'tcp://127.0.0.1:3547');     # Publishers connect here
has server     => (is => 'ro', isa => 'Bool', default => 0);

# Clients should never call start. 

method start() {

    # Most things SHOULDN'T be trying to start this. So we'll
    # check if we were built with the server flag to prevent
    # accidental starting.

    if (not $self->server) {
        croak "Attempt to start non-server.";
    }

    my $zmq = zmq_init;
    my $sub = zmq_socket($zmq, ZMQ_SUB);
    zmq_bind($sub, $self->publisher);
    zmq_setsockopt($sub, ZMQ_SUBSCRIBE, '');    # Sub everything

    my $pub = zmq_socket($zmq, ZMQ_PUB);
    zmq_bind($pub, $self->subscriber);

    zmq_device(ZMQ_FORWARDER, $pub, $sub);
}

=for Pod::Coverage ZMQ_FORWARDER ZMQ_PUB ZMQ_SUB ZMQ_SUBSCRIBE

=cut

1;
