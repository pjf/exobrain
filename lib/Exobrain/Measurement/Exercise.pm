package Exobrain::Measurement::Exercise;
use Moose::Role;
use Method::Signatures;

# ABSTRACT: Exercise measurement packet for Exobrain
# VERSION

# Declare that we will have a summary attribute. This is to make
# our roles happy.
sub summary;

# This needs to happen at begin time so it can add the 'payload'
# keyword.
BEGIN { with 'Exobrain::Message'; }

=head1 DESCRIPTION

A standard form of measuring exercise.

This is a I<role>, and must be consumed by a class that implments
it. However it's recommended you consume the
L<Exobrain::Measurement::Exercise::Cardio> or
L<Exobrain::Measurement::Exercise::Strength>
roles as required.

For one example, see L<Exobrain::Measurement::Exercise::ZombiesRun> .

=cut

payload activity => ( isa => 'Str'  );  # Eg, walk/run/sit-ups, etc
payload is_me    => ( isa => 'Bool' );  # Is this the current user?
payload calories => ( isa => 'Num', required => 0 );
payload seconds  => ( isa => 'Num', required => 0 );

=method activity

    my $activity = $self->activity;

Returns a string with a description of the activity performed.

=method is_me

    if ($self->is_me) { ... }

Returns true if the active user is the one performing the exercise.

=method seconds

    my $seconds = $self->seconds;

Returns the duration in seconds of the exercise.

=method calories

    my $cal = $self->cal;

Returns energy spent in calories.

=method kj

    my $kj = $self->kj;

Returns energy spent in kilojoules.

=cut

method kj() {
    my $cal = $self->calories;

    return defined($cal) ? $cal * 4.1868 : undef;
}

1;

=for Pod::Coverage summary
