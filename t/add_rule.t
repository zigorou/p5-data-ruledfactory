use strict;
use warnings;

use Test::More;
use Test::Exception;
use Data::RuledFactory;

sub test_add_rule {
    my %specs = @_;
    my ($input, $expects, $desc) = @specs{qw/input expects desc/};

    subtest $desc => sub {
        my ($rf, $fields, $args)             = @$input{qw/factory fields args/};
        my ($expected_index, $expected_rule) = @$expects{qw/index rule/};

        lives_and {
            $rf->add_rule($fields, @$args);
            my $rule_pair = $rf->rules->[$expected_index];
            is_deeply($rule_pair->[0], $fields, 'The fields of added rule equals given value');
            isa_ok($rule_pair->[1], $expected_rule);
        } 'add_rule() lives ok';
    };
}

my $rf = Data::RuledFactory->new;
my $i  = 0;

test_add_rule(
    desc => 'Add rule as array reference',
    input => {
        factory => $rf,
        fields  => 'id',
        args    => [ [ Sequence => {} ] ],
    },
    expects => {
        index => $i++,
        rule  => 'Data::RuledFactory::Rule::Sequence',
    },
);

test_add_rule(
    desc => 'Add rule as array',
    input => {
        factory => $rf,
        fields  => 'name',
        args    => [ StringRandom => {} ],
    },
    expects => {
        index => $i++,
        rule  => 'Data::RuledFactory::Rule::StringRandom',
    },
);

test_add_rule(
    desc => 'Add rule as array with multi fields',
    input => {
        factory => $rf,
        fields  => [qw/foo bar/],
        args    => [ Tuples => { data => [ 1 .. 10 ], k => 2 } ],
    },
    expects => {
        index => $i++,
        rule  => 'Data::RuledFactory::Rule::Tuples',
    },
);

test_add_rule(
    desc => 'Add rule as code reference',
    input => {
        factory => $rf,
        fields  => [qw/cb/],
        args    => [ sub { "cb" } ],
    },
    expects => {
        index => $i++,
        rule  => 'Data::RuledFactory::Rule::Callback',
    },
);

test_add_rule(
    desc => 'Add rule as single scalar variable',
    input => {
        factory => $rf,
        fields  => [qw/const/],
        args    => [ "constant" ],
    },
    expects => {
        index => $i++,
        rule  => 'Data::RuledFactory::Rule::Constant',
    },
);

done_testing;
