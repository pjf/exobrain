package Exobrain::Types;
use 5.010;
use strict;
use warnings;

use JSON::Any;

my $json = JSON::Any->new( allow_blessed => 1 );

use MooseX::Types -declare => [qw(
    JSON
    POI
    TweetStr
    SmsStr
    PhoneNum
)];

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

subtype TweetStr,
    as Str,
    where { length($_) <= 140 }
;

subtype SmsStr,
    as Str,
    where { length($_) <= 160 }
;

# TODO: Properly define phone numbers
subtype PhoneNum,
    as Str
;

class_type POI,
    { class => 'Exobrain::Measurement::Geo::POI' }
;

coerce POI,
    from HashRef,
    via { Exobrain::Measurement::Geo::POI->new(%$_) }
;

1;
