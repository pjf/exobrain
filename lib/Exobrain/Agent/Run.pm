package Exobrain::Agent::Run;
use Moose::Role;
use Method::Signatures;
use Try::Tiny;

# ABSTRACT: Role for agents which run 'continously'

with 'Exobrain::Source';

requires('run');
excludes('poll');

=method start

Called automatically by exobrain. This just wraps the C<run> method,
and signals an error should that method ever return.

=cut

method start() {
    $self->run;

    my $class = ref($self);
    my $message = "Error: $class exited run() method unexpectedly.";

    try { $self->exobrain->notify($message, priority => 1); };

    die $message;

}

1;
