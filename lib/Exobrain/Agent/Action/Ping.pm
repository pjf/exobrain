package Exobrain::Agent::Action::Ping;
use Moose;
use Method::Signatures;

with 'Exobrain::Agent::Run';

# ABSTRACT: Automatically respond to any 'ping' tag sent to us.

method run() {
    $self->exobrain->watch_loop(
        class  => 'Measurement::Social',
        filter => sub { $_->to_me and grep { /^ping$/ } @{ $_->tags } },
        then   => sub { $_->respond("Ack (via exobrain)"); },
    );
}

1;
