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

isa_ok($rf->get_rule('id'), 'Data::RuledFactory::Rule::Sequence');
isa_ok($rf->get_rule('name'), 'Data::RuledFactory::Rule::StringRandom');
isa_ok($rf->get_rule([qw/foo bar/]), 'Data::RuledFactory::Rule::Callback');
isa_ok($rf->get_rule([qw/hoge fuga piyo/]), 'Data::RuledFactory::Rule::Combinations');
isa_ok($rf->get_rule('sex'), 'Data::RuledFactory::Rule::Constant');
isa_ok($rf->get_rule('published_on'), 'Data::RuledFactory::Rule::RangeRandom');
is($rf->get_rule('not_exists_field'), undef, 'Not exists single field');
is($rf->get_rule([qw/aaa bbb/]), undef, 'Not exists multi fields');

done_testing;
