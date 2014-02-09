package Exobrain::Intent::Beeminder;

use v5.10.0;

use Moose;
use Method::Signatures;

# This provides a message which Beeminder sinks will act upon.
# Intent::Beeminder->new( goal => 'inbox', value => 52 );

method summary() {
    my $summary = join(' ', 'Beeminder: Set', $self->goal, 'to', $self->value);
    
    if (my $comment = $self->comment)  {
        $summary .= " ($comment)";
    }

    return $summary;
}

BEGIN { with 'Exobrain::Intent' }

payload goal    => (isa => 'Str');
payload value   => (isa => 'Num');
payload comment => (isa => 'Str', required => 0);

1;
