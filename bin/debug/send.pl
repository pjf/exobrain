#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use Exobrain::Bus;
use Exobrain::Message;

my $bus = Exobrain::Bus->new(
    type => 'PUB',
);

while (<>) {
    my $msg = Exobrain::Message->new(
        namespace => 'NOTICE',
        timestamp => time(),
        source    => $0,
        summary   => $_,
        data      => { message => $_ },
        raw       => { message => $_ },
    );

    $msg->send( $bus->_socket );
}
