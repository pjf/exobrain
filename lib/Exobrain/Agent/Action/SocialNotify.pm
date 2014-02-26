package Exobrain::Agent::Action::SocialNotify;
use Moose;
use Method::Signatures;

# ABSTRACT: Notify user of social events directed at them.
# VERSION

with 'Exobrain::Agent::Run';

method run {
    $self->exobrain->watch_loop(
        class  => 'Measurement::Social',
        filter => sub { $_->to_me },
        then   => sub {
            $self->exobrain->notify( $_->summary )
        },
    );
}

1;
