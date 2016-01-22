package Exobrain::Types;
use 5.010;
use strict;
use warnings;

use JSON::Any;

# ABSTRACT: Type system for Exobrain
# VERSION

=head1 SYNOPSIS

    use Exobrain::Types qw(SmsStr PhoneNum);

=head1 DESCRIPTION

This provides a central point for accessing the type-system
used by Exobrain. At this time you'll need to view this
module's source to see all the types available.

Documentation patches are very, very welcome.

=cut

my $json = JSON::Any->new( allow_blessed => 1 );

use MooseX::Types -declare => [qw(
    JSON
    POI
    SmsStr
    PhoneNum
    Exobrain
    PosNum
    PosInt
    TimeOut
)];

use MooseX::Types::Moose qw(
    HashRef
    Ref
    Str
    Num
    Int
);

subtype JSON,
    as Str,
    where { $json->decode($_) }
;

coerce JSON,
    from Ref,
    via { $json->encode($_) }
;

subtype SmsStr,
    as Str,
    where { length($_) <= 160 }
;

# Phone number type. Consists of only digits
#   Example: 18005555555 or 1234567
subtype PhoneNum,
    as Str,
    where { $_ =~ /\d+/ },
;

subtype PosNum,
    as Num,
    where { $_ > 0 }
;

subtype PosInt,
    as Int,
    where { $_ > 0 }
;

subtype TimeOut,
    as PosNum,
    where { 1 },
;

class_type Exobrain, { class => 'Exobrain' } ;

class_type POI,
    { class => 'Exobrain::Measurement::Geo::POI' }
;

coerce POI,
    from HashRef,
    via { Exobrain::Measurement::Geo::POI->new(%$_) }
;

1;
