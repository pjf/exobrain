package Exobrain::JSONify;
use Moose::Role;
use Storable qw(dclone);
use Data::Structure::Util 0.16 qw(unbless);

# Basic role that allows converting self object into JSON.
# Really we should use MooseX::Storage instead.

sub TO_JSON {
    my ($self) = @_;

    return unbless dclone $self;   # Yuck!
}

=for Pod::Coverage TO_JSON

=cut

1;
