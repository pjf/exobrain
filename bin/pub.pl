#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use ZMQ::LibZMQ2;
use ZMQ::Constants qw(ZMQ_PUB);

my $zmq_context = zmq_init();
my $pub = zmq_socket($zmq_context, ZMQ_PUB);

zmq_connect($pub, 'tcp://127.0.0.1:3456');

while(1) {
    my $hdr = rand() < 0.5 ? "[X]" : "[Y]";
    my $time = localtime();
    zmq_send($pub,"$hdr $time");
    say $time;
    sleep 1;
}
