#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use App::Exobrain::Bus;
use App::Exobrain::Message;

my $bus = App::Exobrain::Bus->new(
    type => 'PUB',
);

while (<>) {
    my $msg = App::Exobrain::Message->new(
        namespace => 'NOTICE',
        timestamp => time(),
        source    => $0,
        summary   => $_,
        data      => { message => $_ },
        raw       => { message => $_ },
    );

    $msg->send( $bus->_socket );
}
