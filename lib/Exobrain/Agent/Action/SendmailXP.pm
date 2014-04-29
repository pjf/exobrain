package Exobrain::Agent::Action::SendmailXP;
use Moose;
use Method::Signatures;

with 'Exobrain::Agent::Run';
with 'Exobrain::Agent::Depends';

# ABSTRACT: Reward users on HabitRPG for sending email.
# VERSION

use constant DEBUG => 0;

method depends() { qw(Intent::HabitRPG Measurement::Mailbox) }

# WTF exobrain, why do I need to use a (...) signature here?
# What on earth are you being passed?

method run(...) {
    my $task  = $self->config->{task} or die "No HabitRPG task";
    my $cache = $self->cache;

    $self->exobrain->watch_loop(
        class  => 'Measurement::Mailbox',
        filter => sub { $_->mailbox =~ /sent/i },
        then   => sub {
            my $event = shift;

            my $key = [ $event->server, $event->mailbox ];
            my $count = $event->count;

            my $old_count = $cache->get( $key ) || 0;

            warn "Handling @$key at $count (from $old_count) msgs\n" if DEBUG;

            if ($count > $old_count) {

                # Sweet! They sent email
                $cache->set( $key, $count );

                $event->exobrain->intent('HabitRPG',
                    task      => $task,
                    direction => 'up',
                );
            }
        }
    );
}

1;

=for Pod::Coverage DEBUG
