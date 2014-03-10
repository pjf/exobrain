use Exobrain;
use Exobrain::Test;
use Test::More;

my $exobrain = Exobrain->new;

isa_ok($exobrain,'Exobrain');

# Build a sample geo message and test

my $message = $exobrain->measure('Geo::Test',
    source => 'Foursquare',
    user    => 'pjf',
    user_name => 'Paul Fenwick',
    is_me   => 1,
    poi => {
        id   => 'abc01234ff',
        name => 'Some place',
    },
    message => 'Drinking a coffee',
    nosend => 1,
);

ok($message->DOES('Exobrain::Message'), 'Does Exobrain::Message');
ok($message->DOES('Exobrain::Measurement::Geo'), 'Does Exobrain::Measurement::Geo');
isa_ok($message,  'Exobrain::Measurement::Geo::Test');

is($message->user,'pjf','user field');
ok($message->is_me,'self field');
is($message->message,'Drinking a coffee','message field');
isa_ok($message->poi,'Exobrain::Measurement::Geo::POI');
is($message->poi->source, 'Foursquare', 'POI source');

is($message->summary, qq{Paul Fenwick is at Some place with message: "Drinking a coffee" ( via Foursquare ) [Me]}, "Summary msg");

is($message->namespace, 'Measurement::Geo::Test');

done_testing;
