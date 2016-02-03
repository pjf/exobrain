package Exobrain::Bus;
use v5.10.0;
use Moose;

use ZMQ;
use ZMQ::Constants qw(ZMQ_SUB ZMQ_PUB ZMQ_SUBSCRIBE ZMQ_RCVMORE);

use Method::Signatures;

use Exobrain::Router;
use Exobrain::Message::Raw;

# ABSTRACT: Connection to the Exobrain bus
# VERSION

=head1 DESCRIPTION

Messages in Exobrain are broadcasted on a bus, the low-level access to
which is provided by this class.

You probably don't want low-level access, and should be using the
methods in the L<Exobrain> class instead.

=cut

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

    my $type = $self->type;

    if ($type eq 'SUB') {
        my $socket = $context->socket(ZMQ_SUB);
        $socket->connect($self->router->subscriber);
        $socket->setsockopt(ZMQ_SUBSCRIBE, $self->subscribe);
        $self->_socket($socket);
    }
    elsif ($type eq 'PUB') {
        my $socket = $context->socket(ZMQ_PUB);
        $socket->connect($self->router->publisher);
        
        # Unfortunately ZMQ in some scenarios will try to send
        # data to a socket that isn't ready. ZMQ_EVENTS looked
        # interesting however seems to respond the same
        # regardless of it being ready. This is quite brute force
        # but solves it. We could make this configurable and
        # possibly utilise Time::HiRes to tune it to be faster. 
        # 2014-09-23 - Leon Wright < leon@cpan.org >
        sleep 1;

        $self->_socket($socket);
    }
    else {
        die "Internal error: Can't make a $type socket.";
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
