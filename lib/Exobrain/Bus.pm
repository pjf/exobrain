package Exobrain::Bus;
use v5.10.0;
use strict;
use warnings;

use ZMQ::LibZMQ3;
use ZMQ::Constants qw(ZMQ_SUB ZMQ_PUB ZMQ_SUBSCRIBE ZMQ_RCVMORE);

use Moose;
use Method::Signatures;

use Exobrain::Router;
use Exobrain::Message::Raw;

my $context  = zmq_init();                  # Context is always shared.
my $endpoint = 'tcp://localhost:3568/';     # TODO: From config file?
my $router   = Exobrain::Router->new;

has context   => ( is => 'ro', default => sub { $context } );
has router    => ( is => 'ro', default => sub { $router  } );
has type      => ( is => 'ro', );   # TODO: Type
has subscribe => ( is => 'rw', isa => 'Str', default => '' );
has _socket   => ( is => 'rw' );
has exobrain  => ( is => 'ro', isa => 'Exobrain' );

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

    return;
}

method get() {
    my @frames;
    my $more = 1;
    while ($more) {
        push(@frames, zmq_msg_data( zmq_recv( $self->_socket ) ) );

        # Check to see if there's more...
        $more = zmq_getsockopt($self->_socket, ZMQ_RCVMORE);
    }

    my $message = Exobrain::Message::Raw->new(\@frames);

    # If I have an exobrain object, attach that to the message.
    if ($self->exobrain) {
        $message->exobrain($self->exobrain);
    }

    return $message;
}

# This should probably be retired. Messages come with their own
# send functionality.
method send($msg) {
    zmq_send($self->_socket, $msg);
}

method send_msg(%opts) {
    my $msg = Exobrain::Message::Raw->new( %opts );

    return $msg->send_msg( $self->_socket );
}

=for Pod::Coverage BUILD ZMQ_PUB ZMQ_SUB ZMQ_SUBSCRIBE

=cut

1;
