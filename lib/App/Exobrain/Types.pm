package App::Exobrain::Types;
use 5.010;
use strict;
use warnings;

my $json = JSON::Any->new( allow_blessed => 1 );

use MooseX::Types -declare => [qw(
    JSON
    POI
)];;

use MooseX::Types::Moose qw(
    HashRef
    Ref
    Str
);

subtype JSON,
    as Str,
    where { $json->decode($_) }
;

coerce JSON,
    from Ref,
    via { $json->encode($_) }
;

class_type POI,
    { class => 'App::Exobrain::Measurement::Geo::POI' }
;

coerce POI,
    from HashRef,
    via { App::Exobrain::Measurement::Geo::POI->new(%$_) }
;

1;
