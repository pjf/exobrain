package App::Exobrain::Measurement::Geo;

# ABSTRACT: Geo measurement packet

# VERSION

use 5.010;
use autodie;
use Moose;
use Method::Signatures;

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
        service => 'Foursquare',
        user    => 'pjf',
        is_me   => 1,
        poi     => App::Exobrain::Measurement::Geo::POI->new(
            id   => 'abc01234ff',
            name => 'Some place',
        )
    );

=cut

payload service  => ( isa => 'Str' );    # 4SQ, facebook, etc
payload user     => ( isa => 'Str' );    # User on that service
payload poi      => ( isa => 'App::Exobrain::Measurement::Geo::POI' );    # Point of interest
payload is_me    => ( isa => 'Bool' );   # Is this the current user?

has summary => (
    isa => 'Str', builder => '_build_summary', lazy => 1, is => 'ro'
);

has '+namespace' => ( is => 'ro', isa => 'Str', default => 'GEO' );

method _build_summary() {
    return join(" ",
        $self->user, 'is at ', $self->poi->name, '(via ',
        $self->service, ')',
    );
}

package App::Exobrain::Measurement::Geo::POI;

use Moose;

# Practically a stub class for now.

has id   => (is => 'ro', isa => 'Str', required => 1);
has name => (is => 'ro', isa => 'Str', required => 1);

no Moose;

1;
