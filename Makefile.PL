use inc::Module::Install;

all_from 'lib/Class/DBI/Plugin/DistinctValues.pm';

requires 'Class::DBI'        => '3.0.11';
requires 'Class::DBI::Plugin' => 0.03;
requires 'Scalar::Util'      => 1.13;

test_requires 'Test::More'        => 0.32;
test_requires 'Test::Exception'   => 0.21;

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
author_tests 'xt';
use_test_base;
auto_include;
WriteAll;

