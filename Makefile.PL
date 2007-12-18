use inc::Module::Install;
name 'Cache-FastMmap-Tie';
all_from 'lib/Cache/FastMmap/Tie.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
