package Exobrain::Bus;
use v5.10.0;
use strict;
use warnings;

use ZMQ;
use ZMQ::Constants qw(ZMQ_SUB ZMQ_PUB ZMQ_SUBSCRIBE ZMQ_RCVMORE);

use Moose;
use Method::Signatures;

use Exobrain::Router;
use Exobrain::Message::Raw;

my $context  = ZMQ::Context->new;           # Context is always shared.
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
            my $socket = $context->socket(ZMQ_SUB);
            $socket->connect($self->router->subscriber);
            $socket->setsockopt(ZMQ_SUBSCRIBE, $self->subscribe);
            $self->_socket($socket);
        }

        when('PUB') {
            my $socket = $context->socket(ZMQ_PUB);
            $socket->connect($self->router->publisher);
            $self->_socket($socket);
        }

        default {
            die "Internal error: Can't make a $_ socket.";
        }
    }

    return;
}

method get() {
    my $message = Exobrain::Message::Raw->new( [
        map { $_->data } $self->_socket->recv_multipart
    ] );

    # If I have an exobrain object, attach that to the message.
    if ($self->exobrain) {
        $message->exobrain($self->exobrain);
    }

    return $message;
}

# TODO: This should be retired. Messages come with their own
# send functionality.
method send($msg) {
    $self->_socket->send($msg);
}

method send_msg(%opts) {
    my $msg = Exobrain::Message::Raw->new( %opts );

    return $msg->send_msg( $self->_socket );
}

=for Pod::Coverage BUILD ZMQ_PUB ZMQ_SUB ZMQ_SUBSCRIBE

=cut

1;
