package App::Exobrain::Measurement::Geo::POI;

# ABSTRACT: Geo Point Of Interest class

# VERSION

use 5.010;
use Moose;

# Practically a stub class for now.

has id     => (is => 'ro', isa => 'Str', required => 1);
has name   => (is => 'ro', isa => 'Str', required => 1);
has lat    => (is => 'ro', isa => 'Num', required => 0);
has long   => (is => 'ro', isa => 'Num', required => 0);

# Source is (for example) Foursquare, Facebook, etc
# This may be filled by our containing class
has source => (is => 'rw', isa => 'Str', required => 0);

no Moose;

1;
