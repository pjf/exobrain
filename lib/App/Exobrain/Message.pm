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

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;

    # If called with an arrayref, then we're reconstituting a packet
    # off the wire

    if (@args == 1 and ref($args[0]) eq 'ARRAY') {
        my $frames = $args[0];
        my (undef, $namespace, $source) = split(/_/, $frames->[0]);
        return $class->$orig(
            namespace => $namespace,
            source    => $source,
            timestamp => time(), # XXX - This should be off the wire
            summary   => $frames->[2],
            data      => $frames->[3],
            raw       => $frames->[4],
        );
    }

    return $class->$orig(@args);
};

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

method dump() {
    my $dumpstr = "";

    foreach my $method ( qw(namespace timestamp source data raw summary)) {
        $dumpstr .= "$method : " . $self->$method . "\n";
    }

    return $dumpstr;
}

1;
