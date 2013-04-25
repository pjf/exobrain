#!/usr/bin/perl -w
use 5.010;
use strict;
use warnings;
use autodie;

use ZMQ::LibZMQ2;
use ZMQ::Constants qw(ZMQ_FORWARDER ZMQ_SUBSCRIBE ZMQ_PUB ZMQ_SUB);

my $zmq = zmq_init;
my $sub = zmq_socket($zmq, ZMQ_SUB);
zmq_bind($sub, 'tcp://127.0.0.1:3456');
zmq_setsockopt($sub, ZMQ_SUBSCRIBE, '');    # Sub everything

my $pub = zmq_socket($zmq, ZMQ_PUB);
zmq_bind($pub, 'tcp://127.0.0.1:3457');

zmq_device(ZMQ_FORWARDER, $pub, $sub);
