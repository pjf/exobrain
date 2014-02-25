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
use constant CACHE_LAST_DM      => 'last_dm';
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
    print "Setting last mention to $new\n" if DEBUG;
    $self->cache->set( CACHE_LAST_MENTION, $new );
    return;
}

has last_dm => (
    is => 'rw',
    lazy => 1,
    builder => '_build_last_dm',
    trigger => \&_cache_last_dm,
);

method _build_last_dm() {
    return $self->cache->get( CACHE_LAST_DM ) || 0;
}

method _cache_last_dm($new, $old?) {
    print "Setting last DM to $new\n" if DEBUG;
    $self->cache->set( CACHE_LAST_DM, $new );
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

        my $text       = $status->{text};
        my @tags       = $self->tags( $text );
        my $epoch_time = $self->to_epoch( $status->{created_at} );

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

    # Ugh. Repeated code for DMs. We should be able to combine
    # These two loops.

    my $last_dm = $self->last_dm;

    my $dms =
        $last_dm ?
        $self->twitter->direct_messages({ since_id => $last_dm }) :
        $self->twitter->direct_messages
    ;

    foreach my $dm ( @$dms ) {
        my $text       = $dm->{text};
        my $epoch_time = $self->to_epoch( $dm->{created_at} );
        my $from       = $dm->{sender_screen_name};

        $self->exobrain->measure('DirectMessage',
            timestamp => $epoch_time,
            from      => $from,
            text      => $text,
            summary   => "[DM] \@$from: $text",
            raw       => $dm,
        );

        if ($dm->{id} > $self->last_dm ) {
            $self->last_dm( $dm->{id} );
        }
    }
}

method tags(Str $text) {
    my @tags;

    while ($text =~ m{\#(?<tag>\w+)}g) {
        push @tags, $+{tag};
    }
    
    return @tags;
}

method to_epoch(Str $timestamp) {
    my $dmd = Date::Manip::Date->new;
    $dmd->parse($timestamp) and die "Can't parse $timestamp";
    return $dmd->printf("%s");
}

1;

=for Pod::Coverage DEBUG CACHE_LAST_MENTION CACHE_LAST_DM

