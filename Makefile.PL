use inc::Module::Install;
name 'Data-RuledFactory';
all_from 'lib/Data/RuledFactory.pm';

requires 'constant';
requires 'parent';
requires 'Algorithm::Combinatorics';
requires 'Carp';
requires 'Class::Accessor::Lite';
requires 'Class::Load';
requires 'Data::WeightedRoundRobin';
requires 'List::Util';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
