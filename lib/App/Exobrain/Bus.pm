package App::Exobrain::Bus;
use v5.10.0;
use strict;
use warnings;

use ZMQ::LibZMQ2;
use ZMQ::Constants qw(ZMQ_SUB ZMQ_PUB ZMQ_SUBSCRIBE);

use Moose;
use Method::Signatures;

use App::Exobrain::Router;

my $context  = zmq_init();                  # Context is always shared.
my $endpoint = 'tcp://localhost:3568/';     # TODO: From config file?
my $router   = App::Exobrain::Router->new;

has context   => ( is => 'ro', default => sub { $context } );
has router    => ( is => 'ro', default => sub { $router  } );
has type      => ( is => 'ro', );   # TODO: Type
has subscribe => ( is => 'rw', isa => 'Str', default => '' );
has _socket   => ( is => 'rw' );

sub BUILD {
    my ($self) = @_;

    given ($self->type) {

        when('SUB') {
            my $socket = zmq_socket($self->context, ZMQ_SUB);
            zmq_connect($socket, $self->router->subscriber);
            zmq_setsockopt($socket, ZMQ_SUBSCRIBE, $self->subscribe);
            $self->_socket($socket);
        }

        when('PUB') {
            my $socket = zmq_socket($self->context, ZMQ_PUB);
            zmq_connect($socket, $self->router->publisher);
            $self->_socket($socket);
        }

        default {
            die "Internal error: Can't make a $_ socket.";
        }
    }
}

method get() {
    my $packet = zmq_msg_data( zmq_recv( $self->_socket ) );
    return $packet;
}

method send($msg) {
    zmq_send($self->_socket, $msg);
}

1;
