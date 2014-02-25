package Exobrain::Agent::Poll;
use Moose::Role;
use Method::Signatures;
use Try::Tiny;
use Exobrain::Types qw(TimeOut PosInt);

# ABTRACT: Role for exobrain sources which poll a source.

with 'Exobrain::Agent';

requires('poll');
excludes('run');

has frequency  => (isa => TimeOut, is => 'rw', default => 90 );
has max_errors => (isa => PosInt,  is => 'rw', default =>  5 );

=method start

Automatically called when a C<Source> class is started, this 
starts the actual agent (wrapping C<poll>), and never returns.

=cut

method start() {
    my $errors = 0;

    while (1) {
        try {
            $self->poll;
            sleep( $self->frequency );
            $errors = 0;
        }
        catch {
            warn $_;
            $errors++;

            # If we see too many continuous errors, bail out!
            if ($errors > $self->max_errors) {
                my $class   = ref($self);
                my $message = "Too many contiguous errors for $class. Bailing out.";
                try { $self->exobrain->notify($message, priority => 1); };

                die $message;
            }
        };
    }
}

1;
