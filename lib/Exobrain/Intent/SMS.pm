package Exobrain::Intent::SMS;

use 5.010;
use Moose;
use Method::Signatures;
use Exobrain::Types qw(SmsStr PhoneNum);

# ABSTRACT: Send an SMS intent via Exobrain
# VERSION

=head1 SYNOPSIS

    $exobrain->intent('SMS',
        to   => $your_number,
        text => 'Hello World!',
    );

=cut

method summary() { return 'SMS to ' . join(" : ", $self->to, $self->text); }

BEGIN { with 'Exobrain::Intent'; }

payload text     => ( isa => SmsStr   );
payload to       => ( isa => PhoneNum );

1;
