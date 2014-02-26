package Exobrain::Measurement::DirectMessage;

use Moose;
use Method::Signatures;

# ABSTRACT: A direct message of any sort
# VERSION

# Declare that we will have a summary attribute. This is to make
# our roles happy.
sub summary;

# This needs to happen at begin time so it can add the 'payload'
# keyword.

# TODO: Should this *really* be a ::Social ?

BEGIN { with 'Exobrain::Measurement::Social'; }

=head1 DESCRIPTION

Requires everything from Measurement::Social

=cut

# A summary *must* be provided
has summary => (
    isa => 'Str', is => 'ro', required => 1,
);

# Direct messages are to me, unless set otherwise.
has '+private' => ( default => 1 );
has '+to_me'   => ( default => 1 );

1;
