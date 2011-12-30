use strict;
use warnings;

use Test::More;
use Test::Exception;

use Data::RuledFactory;

my $rf = Data::RuledFactory->new(
    rules => [
        id                     => [ Sequence => {} ],
        name                   => [ StringRandom => {} ],
        [ qw/foo bar/ ]        => sub { [ int rand(1000), int rand(10) ] },
        [ qw/hoge fuga piyo/ ] => [ Combinations => +{ data => [ 1 .. 20 ], k => 3 } ],
        sex                    => 'MALE',
        published_on           => [ RangeRandom => { integer => 1, min => time - 24 * 60 * 60, max => time, incremental => 1 } ],
    ],
);

is($rf->get_rule_index('id'), 0, 'The index of id field equals 0');
is($rf->get_rule_index('name'), 1, 'The index of name field equals 1');
is($rf->get_rule_index([qw/foo bar/]), 2, 'The index of foo bar field equals 1');
is($rf->get_rule_index([qw/hoge fuga piyo/]), 3, 'The index of hoge, fuga, piyo field equals 1');
is($rf->get_rule_index('sex'), 4, 'The index of sex field equals 1');
is($rf->get_rule_index('published_on'), 5, 'The index of published_on field equals 1');
is($rf->get_rule_index('not_exists_field'), -1, 'Not exists single field');
is($rf->get_rule_index([qw/aaa bbb/]), -1, 'Not exists multi fields');

done_testing;
