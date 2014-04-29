package Exobrain::Agent::Poll;
use Moose::Role;
use Method::Signatures;
use Try::Tiny;
use Exobrain::Types qw(TimeOut PosInt);

# ABSTRACT: Role for exobrain sources which poll a source.
# VERSION

=head1 SYNOPSIS

    package Exobrain::Agent::Action::Foo;
    use Moose;

    with 'Exobrain::Agent::Poll';

    sub poll {
        # This method will be called on a regular basis.
    }

=head1 DESCRIPTION

This role arranges for the consumer's C<poll> method to
be called on a periodic basis. It also includes the
functionality of L<Exobrain::Agent>.

=cut

with 'Exobrain::Agent';

requires('poll');
excludes('run');

has frequency  => (isa => TimeOut, is => 'rw', default => 90 );
has max_errors => (isa => PosInt,  is => 'rw', default =>  5 );

=method start

This is a wrapper around the actual agent, which arranges to
call its C<poll> method every C<$self->frequency> seconds.

It never returns.

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
