use strict;
use warnings;

use Test::More;
use Test::Exception;
use Data::RuledFactory;

sub test_create_rule {
    my %specs = @_;
    my ($input, $expects, $desc) = @specs{qw/input expects desc/};

    subtest $desc => sub {
        lives_and {
            my $rule = Data::RuledFactory->create_rule(@$input);
            isa_ok($rule, $expects->{rule_class});
            for my $field (keys %{$expects->{rule_args}}) {
                is_deeply($rule->$field, $expects->{rule_args}{$field}, sprintf('field (%s) equals expected value', $field));
            }

        } 'create_rule() lives ok';
    };
}

test_create_rule(
    desc => 'Rule as array reference',
    input => [ [ Sequence => {} ] ],
    expects => {
        rule_class => 'Data::RuledFactory::Rule::Sequence',
        rule_args  => { start => 1, step => 1 },
    },
);

my $regex_str = q#[a-zA-Z0-9]{8,10}#;

test_create_rule(
    desc => 'Rule as array',
    input => [ StringRandom => { data => $regex_str } ],
    expects => {
        rule_class => 'Data::RuledFactory::Rule::StringRandom',
        rule_args  => { data => $regex_str },
    },
);

my $cb = sub { "test"; };

test_create_rule(
    desc => 'Code reference shortcut',
    input => [ $cb ],
    expects => {
        rule_class => 'Data::RuledFactory::Rule::Callback',
        rule_args  => {
            data => $cb,
        },
    },
);

test_create_rule(
    desc => 'Constant value shortcut',
    input => [ 10 ],
    expects => {
        rule_class => 'Data::RuledFactory::Rule::Constant',
        rule_args  => {
            data => 10,
        },
    },
);

done_testing;
