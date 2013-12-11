package App::Exobrain::Intent::Tweet;

use v5.10.0;

use Moose;
use Method::Signatures;
use App::Exobrain::Types qw( TweetStr );

# This provides a message which twitter sinks will act upon.
# Intent::Tweet->new( tweet => 'Hello World' );

method summary() { return $self->tweet; }

BEGIN { with 'App::Exobrain::Intent'; }

payload tweet => ( isa => TweetStr );

1;
