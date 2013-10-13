package App::Exobrain::Message::Raw;
use v5.10.0;
use Moose;
use ZMQ::Constants qw(ZMQ_SNDMORE);
use ZMQ::LibZMQ2;
use JSON::Any;
use Method::Signatures;
use Carp;
use warnings;

use Moose::Util::TypeConstraints;

with 'App::Exobrain::Message';

# Automatic conversion between JSON and Perl Refs.

my $json = JSON::Any->new;

subtype 'JSON',
    as 'Str',
    where { $json->decode($_) }
;

coerce 'JSON',
    from 'Ref',
    via { $json->encode($_) }
;

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
has data      => ( is => 'ro', isa => 'Ref'                );
has raw       => ( is => 'ro', isa => 'Ref'                );
has summary   => ( is => 'ro', isa => 'Str'                );  # Human readable
has exobrain  => ( is => 'ro', isa => 'App::Exobrain',     );

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
            data      => $json->decode( $frames->[3] ),
            raw       => $json->decode( $frames->[4] ),
        );
    }

    return $class->$orig(@args);
};

method send($socket?) {

    # If we don't have a socket, grab it from our exobrain object
    # (if it exists)

    if (not $socket) {
        if (my $exobrain = $self->exobrain) {
            $socket = $exobrain->pub->_socket;
        }
        else {
            croak "send() is missing a socket or exobrain";
        }
    }

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
    push(@frames, $json->encode( $self->data ));
    push(@frames, $json->encode( $self->raw  ));

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
