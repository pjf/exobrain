package Exobrain::Intent::HabitRPG;

use v5.10.0;
use Moose;
use Method::Signatures;

=head1 SYNPOSIS

    $exobrain->intent('HabitRPG',
        task      => $id,
        direction => 'up',
    );

=cut

method summary() {
    return join(' ' , "HabitRPG: Move" , $self->task, $self->direction);
}

BEGIN { with 'Exobrain::Intent'; };

payload task      => ( isa => 'Str' , required => 1 );
payload direction => ( isa => 'Str' , required => 1 );  # TODO - Restrict to up/down

1;
