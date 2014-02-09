package Exobrain::Intent::Notify;

use 5.010;
use Moose;
use Method::Signatures;

# Basic notification class

method summary() { return $self->message; }

BEGIN { with 'Exobrain::Intent'; }

payload message  => ( isa => 'Str' );
payload priority => ( isa => 'Int', default => 0 );

# TODO: Add title, URL, etc?

1;
