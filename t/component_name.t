use Exobrain;
use Test::More;

my $exobrain = Exobrain->new;

# We know that BeeInbox uses the default component code.
my $agent = $exobrain->_load_component('Agent::Action::BeeInbox')->new;

is ($agent->component, 'Action::BeeInbox', "Auto-component code");

done_testing;
