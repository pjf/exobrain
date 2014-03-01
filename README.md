[![Build Status](https://travis-ci.org/pjf/exobrain.png?branch=master)](https://travis-ci.org/pjf/exobrain)

[![Support via Gittip](https://rawgithub.com/twolfson/gittip-badge/0.1.0/dist/gittip.png)](https://www.gittip.com/pjf/)

# What is this?

Exobrain is a collection of agents which collect, classify, and act
upon data. They share a common bus for communication. Think of it as
IFTTT, but free, open source, and *you* keep control of your privacy.

Examples of things that exobrain can currently do:

* Give you XP in HabitRPG when you update your beeminder goals
* Let others add items to your RememberTheMilk TODO lists via twitter
* Update beeminder by checking your inbox sizes using IMAP
* Reward you for responding to email
* Automatically log life events to idonethis

You can find pre-built actions in the
[`bin/actions`](https://github.com/pjf/exobrain/tree/master/bin/actions)
directory.

Exobrain is designed to make it very easy to write and trigger
events using standard interfaces. 

# Technology

The core of exobrain is written in Perl, but uses a shared
message bus (0MQ) and packet format (JSON) to make it easy to
connect components from other languages.

Writing an *action* is a very simple affair. For example, @pjf has
notifications configured to go to his pebble watch, and uses this code
to send all tweets directed at him to said watch:

    #!/usr/bin/env perl
    use Exobrain;

    my $exobrain = Exobrain->new;

    $exobrain->watch_loop(
        class  => 'Measurement::Tweet',
        filter => sub { $_->to_me },
        then   => sub {
            $exobrain->notify( $_->summary );
        },
    );

# Installation

**Step 1: Install exobrain**

The following works for a fresh install of Ubuntu 13.10.

Firstly, make sure you've got all the dependencies:

    $ sudo apt-get install libzmq3-dev libexpat-dev libnet-ssleay-perl \
        libnet-libidn-perl libcrypt-ssleay-perl cpanminus make \
        liblocal-lib-perl

Exobrain can use either ZMQ2 or ZMQ3, but we prefer ZMQ3:

    export PERL_ZMQ_BACKEND=ZMQ::LibZMQ3

Configure `local::lib` if you haven't already done so:

    $ perl -Mlocal::lib >> ~/.bashrc
    $ eval $(perl -Mlocal::lib)

If installing from git, you can then use:

    $ dzil authordeps | cpanm
    $ dzil listdeps   | cpanm
    $ dzil install

If installing from CPAN, it's just:

    $ cpanm Exobrain

Note that Exobrain has *many* dependencies. If you're feeling hungry,
this would be a good time to go out for a meal or find a snack. You
can also use `cpanm --notest` instead of `cpanm` in all the lines above,
which will get things installed sooner by not rigorously testing
Exobrain and every one of its dependencies.

When you return from your meal, you should find that you have exobrain
installed!  However to use it properly, you'll want to manage it with `ubic`.

**Step 2: Configure ubic**

Set up ubic (if you haven't already done so):

    $ ubic-admin setup

Set up exobrain:

    $ exobrain setup

**Step 3: Add configuration**

If you install the `Exobrain::Twitter` extension (you should) then you
can run `exobrain-twitter-auth` to configure your Twitter endpoints.

Exobrain uses a `~/.exobrainrc` file. You can copy the `example.exobrainrc`
file from the `docs/` directory to get started. Exobrain will also use
config files found in your `~/.config/exobrain` directory (or the XDG
config directory on your system). Installable components will often write
their configuration to this area.

For RememberTheMilk integration, you'll need a valid `~/.rtmagent` file.

You can now start your exobrain. You can see what exobrain services
you have available with:

    $ ubic status

The exobrain core must *always* be running for anything to work.
You can start it with:

    $ ubic start exobrain.core

If you've configured Twitter, or another extension, you can start
that with:

    $ ubic start exobrain.twitter

While the `exobrain.action` services are slowly being replaced with
dedicated agent classes, many of them are useful, especially for testing.
You can start the ping service with:

    $ ubic start exobrain.action.ping

# DEBUGGING

If things don't seem to be working right, you start up the debugger:

    $ exobrain debug        # Watch the exobrain bus
    $ exobrain debug -v     # Watch the exobrain bus verbosely

These commands will show you what's happening *right now*. If
things are quiet, then nothing will be shown.

You can also look at the files in `~/ubic/log/exobrain`. Often
these will reveal problems such as missing or incorrect configuration
and the like.

# GLOSSARY

An exobrain `source` is a data provider. It integrates with some
external service, and produces *Measurements*. These can be events on
social media, inbox counts, check-ins, call-backs, or anything else
which is bringing data into the system.

An exobrain `sink` is a data consumer. It listens for *intents* and
makes them happen. This may be sending a tweet, recording a TODO
item, sending a notification, updating a data-point, etc.

An exobrain `action` bridges sources and sinks. It listens for
measurements, and produces intents. These are the most common
components, and also the easiest to write.

# BUGS

Heaps. Report and/or fix them at https://github.com/pjf/exobrain/issues/

# SUPPORT

You can join us on `#exobrain` on chat.freenode.net (IRC).

We have a mailing list at http://groups.google.com/d/forum/exobrain .

If you like my work, you can [tip me on gittip](https://gittip.com/pjf).

If you wish to see Exobrain features implemented more quickly, you
can [place bounties on Bountysource](https://www.bountysource.com/trackers/347315-exobrain).

All code contributions, tests, bug reports, feature ideas, documentation,
and anything else are extremely welcome! Exobrain is free and open
source software, please use it to make the world a better place.

Exobrain is [hosted on github](https://github.com/pjf/exobrain).

# LICENSE

Same as Perl 5 itself.
