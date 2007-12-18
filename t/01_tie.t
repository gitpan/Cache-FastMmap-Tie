use strict;
use Test::More tests => 10;

BEGIN { use_ok 'Cache::FastMmap::Tie' }

ok(my $mmap = tie my %hash, 'Cache::FastMmap::Tie', {});
ok($hash{ABC} = 'abc');
ok($hash{abc_def} = [qw(ABC DEF)]);
ok($hash{xyz_XYZ} = {aaa=>'AAA',BBB=>[qw(ccc DDD),{eee=>'FFF'}],xxx=>'YYY'});
is($mmap->get('ABC'), $hash{ABC});
is($mmap->get('abc_def')->[0], $hash{abc_def}->[0]);
is($mmap->get('abc_def')->[1], $hash{abc_def}->[1]);
is(($mmap->get_keys(0))[0], (keys %hash)[0]);
is(($mmap->get_keys(0))[1], (keys %hash)[1]);
