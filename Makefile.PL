use inc::Module::Install;
name 'Data-RuledFactory';
all_from 'lib/Data/RuledFactory.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
