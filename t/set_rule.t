use strict;
use warnings;

use Test::More;
use Test::Exception;

use Data::RuledFactory;

sub test_set_rule {
    my %specs = @_;
    my ($input, $expects, $desc) = @specs{qw/input expects desc/};

    subtest $desc => sub {
        my ($rf, $fields, $args)             = @$input{qw/factory fields args/};
        my ($expected_index, $expected_rule) = @$expects{qw/index rule/};

        lives_and {
            $rf->set_rule($fields, @$args);
            my $rule_pair = $rf->rules->[$expected_index];
            is_deeply($rule_pair->[0], $fields, 'The fields of added rule equals given value');
            isa_ok($rule_pair->[1], $expected_rule);
        } 'set_rule() lives ok'; 
    };
}

my $rf = Data::RuledFactory->new(
    rules => [
        id   => [ Sequence => {} ],
        name => [ StringRandom => {} ],
    ],
);

test_set_rule(
    desc => 'override id field',
    input => {
        factory => $rf,
        fields  => 'id',
        args    => [ 10 ],
    },
    expects => {
        index => 0,
        rule  => 'Data::RuledFactory::Rule::Constant',
    },
);

test_set_rule(
    desc => 'add published_on field',
    input => {
        factory => $rf,
        fields  => 'published_on',
        args    => [ RangeRandom => {} ],
    },
    expects => {
        index => 2,
        rule  => 'Data::RuledFactory::Rule::RangeRandom',
    },
);

done_testing;
