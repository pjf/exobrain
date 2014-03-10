package Exobrain::Agent::Action::SimpleBeeHabit;
use Moose;
use Method::Signatures;

with 'Exobrain::Agent::Run';

# ABSTRACT: Update HabitRPG events from Beeminder

=head1 SYNOPSIS

    [Action::BeeHabit]

    ; Every time the beeminder goal on the LHS is incremented, the
    ; habit on the RPG will gain XP.
    
    floss     = a670fc50-4e04-4b0f-9583-e4ee55fced02
    weight    = c5199061-a5cc-4013-810d-0e3314bdbbca
    gitminder = a5bf1893-9fc8-4d11-8283-59257f939462

=head1 DESCRIPTION

This agent allows XP and GP to be awarded whenever the a user's Beeeminder
goal is incremented.

This agent does not support goals which should cause penalties on update, nor
goals where the resulting actions should depend upon the direction of
goal movement on Beeminder.

=cut

method run() {

    # Habits are in the config file in 'bmndr-id = hrpg-uuid' pairs
    my $hrpg_tasks = $self->config;

    $self->exobrain->watch_loop(
        class  => 'Measurement::Beeminder',
        filter => { $hrpg_tasks->{ $_->goal } },
        then  => sub {
            $self->exobrain->intent('HabitRPG',
                task      => $hrpg_tasks->{ $_->goal },
                direction => 'up',
            );
        }
    );
}

1;
