package Exobrain::Measurement::Geo;
use Moose::Role;
use Method::Signatures;
use Exobrain::Measurement::Geo::POI;
use Exobrain::Types qw(POI);

# ABSTRACT: Geo measurement packet for Exobrain
# VERSION

# Declare that we will have a summary attribute. This is to make
# our roles happy.
sub summary;

# This needs to happen at begin time so it can add the 'payload'
# keyword.
BEGIN { with 'Exobrain::Message'; }

=head1 DESCRIPTION

A standard form of measuring a geolocation, which may be
from Foursquare, brightkite, twitter, facebook, or anything
else that lets us snoop on poeple.

This is a I<role>, and must be consumed by a class that implments
it. For one example, see L<Exobrain::Measurement::Geo::Foursquare>

=cut

payload user     => ( isa => 'Str' );    # User on that service
payload user_name=> ( isa => 'Str', required => 0);
payload poi      => ( isa => POI,   required => 0, coerce => 1 );    # Point of interest
payload is_me    => ( isa => 'Bool' );   # Is this the current user?
payload message  => ( isa => 'Str', required => 0);  # Any message with checkin

has summary => (
    isa => 'Str', builder => '_build_summary', lazy => 1, is => 'ro'
);

method _build_summary() {

    my $fmt_msg = "";

    if (my $message = $self->message) {
        $fmt_msg = qq{with message: "$message"};
    }
    return join(" ",
        $self->user_name || $self->user, 'is at', $self->poi->name,
        $fmt_msg,
        '( via', $self->source, ')', ($self->is_me ? "[Me]" : ""),
    );
}

no warnings qw(redefine);

sub BUILD { };

after BUILD => method (...) {

    # Fill our POI source if required

    if ($self->poi and not $self->poi->source) {
        $self->poi->source($self->source);
    }

};

1;

=for Pod::Coverage summary
