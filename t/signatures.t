use Exobrain;
use Test::More;

# Exobrain should automatically set Method Signatures. Let's make
# sure it does!

eval 'func foo() { return "Foo" }';
is($@, "", "Compile function");

is(foo(), 'Foo', "Call function");

done_testing;
