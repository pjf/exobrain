package Exobrain::Intent::Response;

use 5.010;
use Moose;
use Method::Signatures;

# VERSION
# ABSTRACT: A generic class for responses to social media messages

=head1 SYNOPSIS

    $exobrain->intent('Response',
        to             => 'pjf',
        text           => 'Thanks!',
        platform       => 'Twitter',
        in_response_to => $twitter_status_id,
    );

=cut

# TODO: Find a good way of doing platform verification

method summary() { return $self->to.'@'.$self->platform.': '.$self->text; }

BEGIN { with 'Exobrain::Intent'; }

payload text           => ( isa => 'Str' );
payload to             => ( isa => 'Str' ); # User to receive message
payload in_response_to => ( isa => 'Str' ); # Status/event we're responding to
payload platform       => ( isa => 'Str' ); # Platform to respond on.

1;
