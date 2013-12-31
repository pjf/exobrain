package App::Exobrain::Measurement::Beeminder;

# ABSTRACT: Mailbox measurement packet

# VERSION

use 5.010;
use autodie;
use Moose;
use Carp qw(croak);
use Method::Signatures;

# Declare that we will have a summary attribute. This is to make
# our roles happy.
sub summary;

# This needs to happen at begin time so it can add the 'payload'
# keyword.
BEGIN { with 'App::Exobrain::Message'; }

=head1 DESCRIPTION

A dedicated class for Beeminder callbacks.

    $exobrain->measure('Beeminder',
        source => 'pjf/floss',  # Or pass user and goal separately
        value  => 1,
        id     => '...',        # Bmndr transaction ID
        action => 'ADD',
    );

=cut

# TODO: Exobrain msgs normally have a source, which are *different* from
# the beeminder user/goal string used here. We need to tease them
# apart.

has source => (isa => 'Str', is => 'ro');   # Used to construct user/goal

payload user    => ( isa => 'Str', builder => '_build_user', lazy => 1 );
payload goal    => ( isa => 'Str', builder => '_build_goal', lazy => 1 );

payload id      => ( isa => 'Str' );
payload action  => ( isa => 'Str' );
payload value   => ( isa => 'Str' );
payload comment => ( isa => 'Str', required => 0 );

# Tweak timestamp to be created from the bmndr return
has '+timestamp' => ( init_arg => 'created' );

has summary => (
    isa => 'Str', builder => '_build_summary', lazy => 1, is => 'ro'
);

# Methods for splitting the source into user and goal

method _build_user() {
    return $self->_split_summary('user');
}

method _build_goal() {
    return $self->_split_summary('goal');
}

method _split_summary($attr!) {
    my %attrs;
    @attrs{qw(user goal)} = split('/', $self->source);

    return $attrs{$attr} or croak "No source attribute provided, can't auto-generate $attr attribute";
}

method _build_summary() {
    return join(" ",
        $self->user, "added beeminder", $self->goal, "data: ",
        $self->value,
    );
}

1;
