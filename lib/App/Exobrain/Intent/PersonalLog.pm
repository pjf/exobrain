package App::Exobrain::Intent::PersonalLog;

use v5.10.0;

use Moose;
use Method::Signatures;

=head1 SYNOPSIS

    my $msg = $exobrain->intent( 'PersonalLog',
        message => "Wrote some awesome code",
    );

=cut

method summary() { return $self->message; }

BEGIN { with 'App::Exobrain::Intent'; }

payload 'message' => ( isa => 'Str' );

1;
