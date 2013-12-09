package App::Exobrain::Types;
use 5.010;
use strict;
use warnings;

use MooseX::Types -declare => [qw(
    POI
)];;

use MooseX::Types::Moose qw(HashRef);

class_type POI, { class => 'App::Exobrain::Measurement::Geo::POI' };

coerce POI,
    from HashRef,
    via { App::Exobrain::Measurement::Geo::POI->new(%$_) }
;

1;
