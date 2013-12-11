package App::Exobrain::Measurement::Geo;

# ABSTRACT: Geo measurement packet

# VERSION

use 5.010;
use autodie;
use Moose;
use Method::Signatures;

use App::Exobrain::Measurement::Geo::POI;
use App::Exobrain::Types qw(POI);

# Declare that we will have a summary attribute. This is to make
# our roles happy.
sub summary;

# This needs to happen at begin time so it can add the 'payload'
# keyword.
BEGIN { with 'App::Exobrain::Message'; }

=head1 DESCRIPTION

A standard form of measuring a geolocation, which may be
from Foursquare, brightkite, twitter, facebook, or anything
else that lets us snoop on poeple.

Eg:

    $exobrain->measure('Geo',
        source => 'Foursquare',
        user    => 'pjf',
        user_name => 'Paul Fenwick',
        is_me   => 1,
        poi     => {
            id   => 'abc01234ff',
            name => 'Some place',
            lat  => $latitude,  # optional
            long => $longitude, # optional
        },
        message => 'Drinking a coffee',
        lat  => $latitude,  # optional
        long => $longitude, # optional
    );

In the future C<user> and C<user_name> may be combined into
a user object.

=cut

payload user     => ( isa => 'Str' );    # User on that service
payload user_name=> ( isa => 'Str', required => 0);
payload poi      => ( isa => POI,   required => 0, coerce => 1 );    # Point of interest
payload is_me    => ( isa => 'Bool' );   # Is this the current user?
payload message  => ( isa => 'Str', required => 0);  # Any message with checkin
payload lat      => ( isa => 'Num', required => 0); # TODO: Custom type
payload long     => ( isa => 'Num', required => 0); # TODO: Custom type

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

method BUILD(...) {

    # Fill our POI source if required

    if ($self->poi and not $self->poi->source) {
        $self->poi->source($self->source);
    }

}

1;
