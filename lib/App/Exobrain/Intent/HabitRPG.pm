package App::Exobrain::Intent::HabitRPG;

use v5.10.0;
use Moose;
use Method::Signatures;

=head1 SYNPOSIS

    $exobrain->intent('HabitRPG',
        task      => $id,
        direction => 'up',
        public    => 1,
    );

=cut

method summary() {
    return join(' ' , "HabitRPG: Move" , $self->task, $self->direction);
}

BEGIN { with 'App::Exobrain::Intent'; };

payload task      => ( isa => 'Str' , required => 1 );
payload direction => ( isa => 'Str' , required => 1 );  # TODO - Restrict to up/down
payload public    => ( isa => 'Bool', default => 0 );

1;
