package Exobrain::Agent::Action::GeoLog;
use Exobrain;
use Moose;

with 'Exobrain::Agent::Run';
with 'Exobrain::Agent::Depends';

# ABSTRACT: Log our own check-ins to a personal log (such as idonethis).
# VERSION

method depends() { return qw(Measurement::Geo Intent::PersonalLog) }

method run() {
    $self->exobrain->watch_loop(
        class  => 'Measurement::Geo',
        filter => sub { $_->is_me },
        then   => sub {
            $self->exobrain->intent("PersonalLog",
                message => $_->summary
            );
        },
    );
}

__PACKAGE__->meta->make_immutable;

1;
