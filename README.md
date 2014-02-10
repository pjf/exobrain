[![Build Status](https://travis-ci.org/pjf/exobrain.png?branch=master)](https://travis-ci.org/pjf/exobrain)

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

Writing an *action* is a very simple affair. @pjf has notifications
configured to go to his pebble watch, and uses this code to send
all tweets directed at him to said watch:

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

    $ sudo apt-get install libzmq-dev libexpat-dev libnet-ssleay-perl \
        libnet-libidn-perl libcrypt-ssleay-perl cpanminus make \
        liblocal-lib-perl libmethod-signatures-perl

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

    ubic-admin setup

Copy the `exobrain` file into your ubic services:

    cp `which exobrain` ~/ubic/service

**Step 3: Add configuration**

Exobrain uses a `~/.exobrainrc` file. You can copy the `example.exobrainrc`
file from the `docs/` directory to get started.

For RememberTheMilk integration, you'll need a valid `~/.rtmagent` file.

You can now start your exobrain. Start with the core:

    ubic start exobrain.core

To get some data flowing through your exobrain, you can try starting
the end-points:

    ubic start exobrain.source
    ubic start exobrain.sink

And to get intelligence, you can bring on-line the classifers:

    ubic start exobrain.classify

Of course, you can get *EVERYTHING* online in one go with just:

    ubic start exobrain

You probably won't use all the components, though, so it's recommended
that you only configure and switch on the ones you need.

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

# SUPPORTING EXOBRAIN DEVELOPMENT

If you like my work, you can [tip me on gittip](https://gittip.com/pjf).

If you wish to see Exobrain features implemented more quickly, you
can [place bounties on Bountysource](https://www.bountysource.com/trackers/347315-exobrain).

All code contributions, tests, bug reports, feature ideas, documentation,
and anything else are extremely welcome! Exobrain is free and open
source software, please use it to make the world a better place.

# LICENSE

Same as Perl 5 itself.
