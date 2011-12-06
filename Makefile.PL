use inc::Module::Install;
name 'Data-RuledFactory';
all_from 'lib/Data/RuledFactory.pm';

requires 'constant';
requires 'parent';
requires 'Carp';
requires 'Class::Accessor::Lite';
requires 'Class::Load';
requires 'Data::WeightedRoundRobin';
requires 'Iterator::Simple';
requires 'List::Util';
requires 'Math::Combinatorics';
requires 'Math::Counting';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
