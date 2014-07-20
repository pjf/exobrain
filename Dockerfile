# DOCKER-VERSION 0.9.1
FROM            ubuntu
MAINTAINER      pjf0

# Let's start with some yak shaving!
# Ubic has the stale file handle bug discussed below, but needs a PPA,
# and to add the PPA we need software-properties-common.

RUN     apt-get update
RUN     apt-get install -y software-properties-common
RUN     add-apt-repository -y ppa:berekuk/ubic

# Get all the base libraries we need
RUN     apt-get update
RUN     apt-get upgrade -y
RUN     apt-get install -y libmodule-build-perl
RUN     apt-get install -y libzmq3-dev libexpat-dev libnet-ssleay-perl libnet-libidn-perl libcrypt-ssleay-perl cpanminus make liblocal-lib-perl

# These should be installable via cpanm, but have failing tests
# when run inside a docker container. All relate to stale file handle
# errors, but I'm not sure what they mean.

RUN     apt-get install -y libpath-class-perl libfile-remove-perl libchi-perl ubic

# I haven't even checked why this doesn't install via cpanm
RUN     apt-get install -y libdevel-checklib-perl

# Install heavyweight modules via apt-get
RUN     apt-get install -y libmoose-perl libppi-perl libperl-critic-perl libxml-parser-perl liblog-log4perl-perl libwww-mechanize-perl libxml-simple-perl

# Add a user for exobrain
RUN     adduser exobrain --disabled-password --gecos Exobrain

# Change to that user's homedir.
WORKDIR /home/exobrain

# Set up local::lib
RUN     sudo -i -u exobrain perl -Mlocal::lib >> ~exobrain/.profile

# ZMQ can be tricky to install.
RUN     sudo -i -u exobrain PERL_ZMQ_BACKEND=ZMQ::LibZMQ3 cpanm ZMQ

# Install Exobrain and dependencies
RUN     sudo -i -u exobrain cpanm Exobrain

# Install all the optional extras
RUN     sudo -i -u exobrain cpanm Exobrain::Beeminder Exobrain::Foursquare Exobrain::HabitRPG Exobrain::Idonethis Exobrain::Twitter

# Set up ubic locally
# For some reason docker containers don't like their crontab messed with
RUN     sudo -i -u exobrain ubic-admin setup --batch-mode --local --reconfigure --no-crontab

# Install a patched File::XDG, because the one from CPAN gives spurious warnings
RUN     sudo -i -u exobrain cpanm https://github.com/pjf/perl-file-xdg/archive/exobrain.tar.gz

# And we're done!
ENTRYPOINT /bin/bash
