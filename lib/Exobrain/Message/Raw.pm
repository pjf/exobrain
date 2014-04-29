package Exobrain::Message::Raw;
use v5.10.0;
use Moose;
use JSON::Any;
use Method::Signatures;
use Carp;

use Moose::Util::TypeConstraints;

# ABSTRACT: Raw, low-level access to Exobrain packets
# VERSION

=head1 DESCRIPTION

This class provides low level access to exobrain packets.
You probably want to use the C<intent>, C<measure>,
C<notify> or other methods in L<Exobrain> rather than using
this directly.

=cut

my $json = JSON::Any->new;

# Summary declared early, so our role can see it.

has 'summary'    => ( is => 'ro', isa => 'Str', required => 1 );
has '_data'      => ( is => 'rw', isa => 'Ref' );
has 'namespace'  => ( is => 'ro', isa => 'Str', required => 1 );

with 'Exobrain::Message';

# Stash our explicit data section

sub BUILD {
    my ($self, $args) = @_;

    my $data = $args->{data} or croak "Raw packets need a data argument";

    $self->_data($data);

    return;
};

method data() {
    return $self->_data;
}

# Build a typed message from our raw message

method to_class($class) {
    my $exobrain = $self->exobrain
        or croak "Can't use to_class() on a message without an exobrain object.";

    my $msg = $exobrain->message_class($class,
        %{ $self->data },
        summary   => $self->summary,
        timestamp => $self->timestamp,
        raw       => $self->raw,
        namespace => $self->namespace,
        source    => $self->source,
        nosend    => 1,                 # Without this, we packet-storm!

        # We can leave roles out, because it will auto-calculate
    );
}

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;

    # If called with an arrayref, then we're reconstituting a packet
    # off the wire. We need to make sure we build this with the 'nosend'
    # flag set, otherwise we'll result in a packet-storm!

    if (@args == 1 and ref($args[0]) eq 'ARRAY') {
        my $frames = $args[0];
        my (undef, $namespace, $source) = split(/_/, $frames->[0]);
        my $metadata = $json->decode( $frames->[1] );
        return $class->$orig(
            namespace => $namespace,
            source    => $source,
            timestamp => $metadata->{timestamp},
            roles     => $metadata->{roles},
            summary   => $frames->[2],
            data      => $json->decode( $frames->[3] ),
            raw       => $json->decode( $frames->[4] ),
            nosend    => 1,
        );
    }

    return $class->$orig(@args);
};

=for Pod::Coverage BUILD

=cut

1;
