use 5.010;
use strict;
use warnings;
use Test::More;
use File::Spec;
use FindBin qw($Bin);

use Exobrain::Config;

$ENV{EXOBRAIN_CONFIG} = File::Spec->catfile($Bin, 'config.d');

my $config = Exobrain::Config->new;

is($config->{Test}{foo},  "baz", "Override data test");
is($config->{Test}{nyan}, "cat", "Simple config test");

my $res = Exobrain::Config->write_config('write_test.ini', "Hello World!\n");
like($res, qr/write_test\.ini$/, 'New config file created');
is(-s $res, 13, 'New config file has correct size');
ok(unlink $res, 'Cleanup');

done_testing;
