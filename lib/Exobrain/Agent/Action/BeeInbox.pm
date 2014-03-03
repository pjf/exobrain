package Exobrain::Agent::Action::BeeInbox;
use Exobrain;
use Method::Signatures;
use Moose;

with 'Exobrain::Agent::Run';

use constant DEBUG => 0;

# ABSTRACT: Watch inbox and send low-water marks to beeminder

method run() {

    my $exobrain = $self->exobrain;
    my $cache    = $self->cache;

    # Load our dependencies first so we fail quickly if they're
    # not installed.

    # TODO: Replace these with a real way of signalling dependencies (GH #44).

    $exobrain->_load_component('Measurement::Mailbox');
    $exobrain->_load_component('Intent::Beeminder');

    # Our inbox goals are 'server => beeminder goal' pairs.
    my $inbox_goals = $self->config->inbox_goals;

    $exobrain->watch_loop(
        class  => 'Measurement::Mailbox',
        filter => sub {
            $_->mailbox eq 'INBOX' and $inbox_goals->{ $_->server }
        },
        then => sub {
            my $event = shift;

            my $server = $event->server;
            my $goal   = $inbox_goals->{$server};
            my $count  = $event->count;
            my $key    = ['INBOX', $server];

            warn "$server has $count messages for $goal\n" if DEBUG;

            my $old_count = $cache->get($key);

            # If we don't have a count yet, or if our new count is
            # smaller, then cache it, and send it to beeminder!

            # Our cache expires at midnight, so we always push a
            # new measurement each day.

            if (! $old_count or $count < $old_count) {
                $exobrain->intent('Beeminder',
                    goal => $goal,
                    value => $count,
                    comment => "Submitted via exobrain",
                );

                $exobrain->notify(
                    "Updated bmndr/$goal to $count msgs",
                    priority => -1,
                );

                say "Updating beeminder goal $goal to $count msgs" if DEBUG;

                $cache->set($key, $count, seconds_until_tomorrow());
            }
        }
    );
}

sub seconds_until_tomorrow {
    my ($s, $m, $h) = localtime;
    return 86400 - ($h * 60 * 60) - ($m * 60) - $s;
}

1;

=for Pod::Coverage DEBUG seconds_until_tomorrow
