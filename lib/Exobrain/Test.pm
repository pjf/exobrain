package Exobrain::Test;
use strict;
use warnings;

# ABSTRACT: Establish test environment for Exobrain

=head1 SYNOPSIS

    use Exobrain;
    use Exobrain::Test;
    use Test More;

=head1 DESCRIPTION

This module tests up a testing environment for Exobrain.
You should I<never> be using it outside of test cases.

This module may change functionality or be removed in the future.

=cut

# Right now we just set a variable to look for our config files in
# the same directory as our main program.

use FindBin qw($Bin);

$ENV{EXOBRAIN_CONFIG} = "$Bin/.exobrainrc";

1;
