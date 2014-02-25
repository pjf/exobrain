package Exobrain::Agent::Source::Twitter;
use v5.10.0;
use Moose;
use Net::Twitter;
use Method::Signatures;
use Date::Manip::Date;

with 'Exobrain::Agent::Poll';

=head1 DESCRIPTION

Exobrain agent class for twitter.

This requires the following configuration section:

    [Exobrain::Agent::Source::Twitter]
    consumer_key =
    consumer_secret =
    access_token =
    access_token_secret =

=cut

# Key used by the cache for our last Twitter ID.
# Called 'last_check' for historical reasons.
use constant CACHE_LAST_MENTION => 'last_mention';
use constant DEBUG              => 0;

has twitter => (
    is => 'ro',
    isa => 'Net::Twitter',
    lazy => 1,
    builder => '_build_twitter',
);

method _build_twitter() {
    my $config = $self->config;

    return Net::Twitter->new(
        traits   => [qw(API::RESTv1_1)],
        consumer_key        => $config->{consumer_key},
        consumer_secret     => $config->{consumer_secret},
        access_token        => $config->{access_token},
        access_token_secret => $config->{access_token_secret},
        ssl                 => 1,
    );
}

has last_mention => (
    is => 'rw',
    lazy => 1,
    builder => '_build_last_mention',
    trigger => \&_cache_last_mention,
);

method _build_last_mention() {
    return $self->cache->get( CACHE_LAST_MENTION ) || 0;
}

method _cache_last_mention($new, $old?) {
    say "Setting last mention to $new" if DEBUG;
    $self->cache->set( CACHE_LAST_MENTION, $new );
    return;
}

method poll() {
    my $last_mention = $self->last_mention;

    my $statuses = 
        $last_mention ?
        $self->twitter->mentions({ since_id => $last_mention }) :
        $self->twitter->mentions()
    ;

    for my $status ( @$statuses ) {
        my $text = $status->{text};
        my @tags;

        # TODO: Move all this into the Measurement::Tweet class,
        # so it can auto-inflate from a single tweet

        while ($text =~ m{\#(?<tag>\w+)}g) {
            push @tags, $+{tag};
        }

        my $epoch_time = do {
            my $dmd = Date::Manip::Date->new;
            my $timestamp = $status->{created_at};
            $dmd->parse($timestamp) and die "Can't parse $timestamp";
            $dmd->printf("%s");
        };

        print "[$status->{id}] $epoch_time <$status->{user}{screen_name}> $status->{text} (Tags: @tags)\n" if DEBUG;

        # TODO: Parse or figure out who this is to, for the 'to' attribute.

        $self->exobrain->measure('Tweet',
            timestamp => $epoch_time,
            from      => $status->{user}{screen_name},
            tags      => \@tags,
            to_me     => 1,     # Because we're only looking at replies
            text      => $status->{text},
            raw       => $status,
        );

        # We explicitly check to see if we have a newer last_mention
        # because we don't want to rely upon the ordering in which
        # tweets are returned. In fact, they're almost always in the
        # order we don't want.

        if ($status->{id} > $self->last_mention) {
            $self->last_mention( $status->{id} );
        }
    }
}

1;

=for Pod::Coverage DEBUG CACHE_LAST_MENTION

