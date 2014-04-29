package Exobrain::Cache;

use v5.10.0;
use strict;
use warnings;

use parent qw(CHI);

# ABSTRACT: Cache class for Exobrain
# VERSION

=head1 SYNOPSIS

    my $cache = Exobrain->cache;

=head1 DESCRIPTION

This provides a ready-made cache for any code using the Exobrain framework.

This directly inherits from the fantastic L<CHI> system. See its documentation
for more details.

=cut

__PACKAGE__->config({
    defaults => {
        driver   => 'File',
        root_dir => "$ENV{HOME}/.exobrain/cache",
    }
});

1;
