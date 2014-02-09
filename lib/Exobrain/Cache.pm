package Exobrain::Cache;

use v5.10.0;
use strict;
use warnings;

use parent qw(CHI);

__PACKAGE__->config({
    defaults => {
        driver   => 'File',
        root_dir => "$ENV{HOME}/.exobrain/cache",
    }
});

1;
