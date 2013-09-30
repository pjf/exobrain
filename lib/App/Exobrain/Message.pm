package App::Exobrain::Message;

use 5.010;
use strict;
use warnings;
use autodie;
use Method::Signatures;
use Moose::Role;
use Moose::Util::TypeConstraints;

# has timestamp => ( is => 'ro', isa => 'Int' );
# has exobrain  => ( is => 'ro', isa => 'App::Exobrain');
# has raw       => ( is => 'ro', isa => 'Ref' );

# Many classes will provide their own way of getting summary
# data.

# requires qw(summary data);

{
    # Automatic conversion between JSON and Perl Refs.

    use JSON::Any;

    my $json = JSON::Any->new;

    subtype 'JSON',
        as 'Str',
        where { $json->decode($_) }
    ;

    coerce 'JSON',
        from 'Ref',
        via { $json->encode($_) }
    ;
}

=method payload

    payload size => ( isa => 'Int' );

Convenience method which sets the 'payload' trait on an attribute,
as well as marking it as 'ro' by default (this can be overridden).

=cut

func payload($name, @args) {

    # We need to call 'has' from the caller's perspective, so let's
    # find out where we're being called from.

    my ($uplevel) = caller();
    my $uphas = join('::', $uplevel, 'has');

    # Now we'll make the call, as well as adding he payload and ro
    # attributes. We need to turn off strict 'refs' here to assure
    # perl that really it's okay that we're using a string as a
    # subroutine ref.

    no strict 'refs';
    return $uphas->( $name => (traits => [qw(Payload)], is => 'ro', @args) );
}

package App::Exobrain::Message::Trait::Payload;
use Moose::Role;

Moose::Util::meta_attribute_alias('Payload');

# The payload attribute desn't actually do anything directly, but
# we test for it elsewhere to see if something is part of a
# payload that should be transmitted.

1;
