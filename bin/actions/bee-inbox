#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use Exobrain;
use Exobrain::Cache;
use WebService::Beeminder;
use POSIX qw(tzset);

# PODNAME: bee-inbox
# ABSTRACT: Watch inbox and send low-water marks to beeminder

use constant DEBUG => 1;

my $exobrain = Exobrain->new;
my $cache = Exobrain::Cache->new(namespace => $0);
my $tz = $exobrain->config->{General}{timezone};

# TODO: Exobrain should set its own TZ, not have us do it
# manually.

if ($tz) {
    say "Setting timezone to $tz";
    $ENV{TZ} = $tz;     ## no critic RequireLocalizedPunctuationVars
    tzset();
}

# When we see a server in this hash, we update the corresponding
# beeminder goal in the value.

my %inbox_goal = (
    'perltraining.com.au' => 'inbox',
);

$exobrain->watch_loop(
    class  => 'Measurement::Mailbox',
    filter => sub {
        $_->mailbox eq 'INBOX' and $inbox_goal{ $_->server }
    },
    then => sub {
        my $event = shift;

        my $server = $event->server;
        my $goal   = $inbox_goal{$server};
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

sub seconds_until_tomorrow {
    my ($s, $m, $h) = localtime;
    return 86400 - ($h * 60 * 60) - ($m * 60) - $s;
}
