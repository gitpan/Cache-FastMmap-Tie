use strict;
use Test::More tests => 10;

BEGIN { use_ok 'Cache::FastMmap::Tie' }

ok(my $fc = tie my %hash, 'Cache::FastMmap::Tie', );

ok($hash{ABC} = 'abc', 'set SCALAR');
ok($hash{abc_def} = [qw(ABC DEF)], 'set ARRAY');
ok($hash{xyz_XYZ} = {aaa=>'AAA',BBB=>[qw(ccc DDD),{eee=>'FFF'}],xxx=>'YYY'}, 'HASH');
is($fc->get('ABC'), $hash{ABC}, 'get SCALAR');
is($fc->get('abc_def')->[0], $hash{abc_def}->[0], 'get ARRAY[0]');
is($fc->get('abc_def')->[1], $hash{abc_def}->[1], 'get ARRAY[1]');
is(($fc->get_keys(0))[0], (keys %hash)[0], 'keys HASH [0]');
is(($fc->get_keys(0))[1], (keys %hash)[1], 'keys HASH [1]');

