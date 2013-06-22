package App::Exobrain::Message;
use v5.10.0;
use Moose;
use ZMQ::Constants qw(ZMQ_SNDMORE);
use ZMQ::LibZMQ2;
use Method::Signatures;
use warnings;

# Message format:
# * Header string for pub/sub filtering (EXOBRAIN + NAMESPACE + SOURCE)
#   (eg: EXOBRAIN_GEO_FOURSQUARE)
# * Meta-info (JSON)
# * Summary (human string)
# * Data (JSON)
# * Raw data (optional)

has namespace => ( is => 'ro', isa => 'Str', required => 1 );
has timestamp => ( is => 'ro', isa => 'Int'                );  # Epoch
has source    => ( is => 'ro', isa => 'Str', required => 1 );
has data      => ( is => 'ro',               required => 1 );  # JSON
has raw       => ( is => 'ro',                             );  # JSON
has summary   => ( is => 'ro', isa => 'Str'                );  # Human readable

method send($socket) {
    # For some reason multipart sends don't work right now,
    # $socket->ZMQ::Socket::send_multipart( $self->frames );

    my @frames = $self->frames;
    my $last   = pop(@frames);

    foreach my $frame ( @frames) {
        zmq_send($socket, $frame, ZMQ_SNDMORE);
    }

    zmq_send($socket,$last);
    
    return;
}

method frames() {
    my @frames;

    push(@frames, join("_", "EXOBRAIN", $self->namespace, $self->source));
    push(@frames, "XXX - JSON - timestamp => " . $self->timestamp);
    push(@frames, $self->summary // "");
    push(@frames, $self->data); # XXX - JSONify
    push(@frames, $self->raw);  # XXX - JSONify

    return @frames;
}

1;
