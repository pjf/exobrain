package App::Exobrain::Measurement::Mailbox;

# ABSTRACT: Mailbox measurement packet

# VERSION

use 5.010;
use autodie;
use Moose;

# See GH schwern/method-signatures #41 as to why we need to do our
# 'withs' before loading Method::Signatures.

BEGIN { with 'App::Exobrain::Message'; }
use Method::Signatures;

=head1 DESCRIPTION

A standard form of measuring a mailbox, whether that's via IMAP,
POP, Facebook API, or otherwise.

Eg:

    $exobrain->measure('Mailbox')->new(
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

method _build_summary() {
    return join(" ",
        $self->user, '@', $self->server, "/", $self->folder,
        "has", $self->count, "messages"
    );
}

1;
