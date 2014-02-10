#!/usr/env perl
use 5.010;
use strict;
use warnings;
use Test::Most;
use Exobrain;
use Exobrain::Test;

my $exobrain = Exobrain->new;

# Actual bmndr callback packet

my $raw = {
          'urtext' => '2013 12 31.7 1',
          'source' => 'pjf/test',
          'value' => '1.0',
          'origin' => 'web',
          'splat' => [
                       '1'
                     ],
          'created' => '1388470212',
          'comment' => '',
          'action' => 'ADD',
          'id' => '52c25fc40fdccb60bd00000e',
          'daystamp' => '16070'
        };

my $pkt;

lives_ok { $pkt =  $exobrain->measure('Beeminder', %$raw) };

is($pkt->user, 'pjf',  'user');
is($pkt->goal, 'test', 'goal');

done_testing;
