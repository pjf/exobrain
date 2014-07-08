package Exobrain::Measurement::Exercise::Cardio;
use Moose::Role;
use Method::Signatures;

# ABSTRACT: Cardio exercise role for Exobrain
# VERSION

BEGIN { with 'Exobrain::Measurement::Exercise' };

payload km => ( isa => 'Num', required => 0 );

has summary => (
    isa => 'Str', builder => '_build_summary', lazy => 1, is => 'ro'
);

method _build_summary() {
    my $activity = $self->activity;
    my $distance = $self->km       // '[UNKNOWN]';
    my $calories = $self->calories // '[UNKNOWN]';
    my $seconds  = $self->seconds  // '[UNKNOWN]';

    return "$activity for $seconds seconds for $distance km ($calories burnt)";
}

method miles() { 
    my $km = $self->km;

    return defined($km) ? $km * 0.62137119 : undef;
}

1;

=for Pod::Coverage summary
