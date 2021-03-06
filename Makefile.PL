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
requires 'Set::CrossProduct';
requires 'String::Random';

tests_recursive 't';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'Test::LoadAllModules';
auto_set_repository;
auto_include;
WriteAll;
