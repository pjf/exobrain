package App::Exobrain::Measurement::Mailbox;

# ABSTRACT: Mailbox measurement packet

# VERSION

use 5.010;
use autodie;
use Moose;
use Method::Signatures;

# Declare that we will have a summary attribute. This is to make
# our roles happy.
sub summary;

# This needs to happen at begin time so it can add the 'payload'
# keyword.
BEGIN { with 'App::Exobrain::Message'; }

=head1 DESCRIPTION

A standard form of measuring a mailbox, whether that's via IMAP,
POP, Facebook API, or otherwise.

Eg:

    $exobrain->measure('Mailbox',
        server => 'imap.example.com',
        user   => 'pjf',
        folder => 'INBOX',
        raw    => $raw_data,
        count  => $cnt,
    );

=cut

payload server => ( isa => 'Str' );
payload user   => ( isa => 'Str' );
payload folder => ( isa => 'Str' );
payload count  => ( isa => 'Int' );

has summary => (
    isa => 'Str', builder => '_build_summary', lazy => 1, is => 'ro'
);

has '+namespace' => ( is => 'ro', isa => 'Str', default => 'EMAIL' );

method _build_summary() {
    return join(" ",
        $self->user, '@', $self->server, "/", $self->folder,
        "has", $self->count, "messages"
    );
}

1;
