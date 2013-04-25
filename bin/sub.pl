#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use ZMQ::LibZMQ2;
use ZMQ::Constants qw(ZMQ_SUB ZMQ_SUBSCRIBE);

my $zmq_context = zmq_init();

my $sub = zmq_socket($zmq_context, ZMQ_SUB);
zmq_connect($sub, 'tcp://localhost:3457');
zmq_setsockopt($sub, ZMQ_SUBSCRIBE, '[X]');

# Set filter. In this case we grab everything.

say "Listening...";

while (1) {
    my $str = zmq_msg_data(zmq_recv($sub));
    say $str;
}
