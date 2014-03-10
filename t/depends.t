use Test::More;
use Test::Deep;
use Exobrain::Agent::Action::SimpleBeeHabit;

my $simple_bee = 'Exobrain::Agent::Action::SimpleBeeHabit';

ok($simple_bee->DOES('Exobrain::Agent::Depends'), "Depends role check");

ok(
    cmp_set(
        [ $simple_bee->depends ],
        [ 'Intent::HabitRPG', 'Measurement::Beeminder' ],
    ),
    "Depends set check"
);

done_testing;
