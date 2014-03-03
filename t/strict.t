use Exobrain;
use Test::More;
use Test::Warn;

# Exobrain should automatically set strict and warnings, so make
# sure it does!

eval '$foo = 3';
like($@, qr{requires explicit package name}, 'Strict enabled');

warning_like { print undef } qr{Use of uninitialized value in print}, "warnings enabled";

done_testing;
