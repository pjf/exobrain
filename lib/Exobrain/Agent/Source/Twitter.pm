package Exobrain::Agent::Source::Twitter;
use Moose;
use Net::Twitter;
use Method::Signatures;
use Date::Manip::Date;

with 'Exobrain::Source::Poll';

# Key used by the cache for our last Twitter ID.
# Called 'last_check' for historical reasons.
use constant CACHE_LAST_ID => 'last_check';
use constant DEBUG         => 1;

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

has last_id => (
    is => 'rw',
    lazy => 1,
    builder => '_build_last_id',
    trigger => '_cache_last_id',
);

method _build_last_id() {
    return $self->cache->get( CACHE_LAST_ID ) || 0;
}

method _cache_last_id($new, $old?) {
    $self->cache->set( CACHE_LAST_ID, $new );
    return;
}

method poll() {
    my $statuses = $self->twitter->mentions({ since_id => $self->last_id });

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

        $self->last_id( $status->{id} );
    }
}

1;
