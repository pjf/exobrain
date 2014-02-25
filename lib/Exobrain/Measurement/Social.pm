package Exobrain::Measurement::Social;

use 5.010;
use strict;
use warnings;
use autodie;
use Moose::Role;

# ABSTRACT: Base class for all social media events

BEGIN { with 'Exobrain::Message'; }

payload from    => ( isa => 'Str' );
payload to      => ( isa => 'ArrayRef[Str]', default => sub { [] } );
payload from_me => ( isa => 'Bool', default => 0);
payload to_me   => ( isa => 'Bool', default => 0);
payload tags    => ( isa => 'ArrayRef[Str]', default => sub { [] } );
payload text    => ( isa => 'Str' );
payload private => ( isa => 'Bool', default => 0);

1;
