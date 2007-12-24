use inc::Module::Install;
name 'Cache-FastMmap-Tie';
all_from 'lib/Cache/FastMmap/Tie.pm';

requires('Cache::FastMmap');
requires('Class::Inspector');
requires('UNIVERSAL::require');

build_requires 'Test::More';
use_test_base;
auto_include;
auto_install;
WriteAll;
