use strict;
use warnings;

use lib 't/lib';
use Test::More;
use Declare::User;

subtest 'default' => sub {
    my $rf = Declare::User->build('Default');
    isa_ok($rf, 'Data::RuledFactory');

    isa_ok($rf->get_rule([qw/id other_id/]), 'Data::RuledFactory::Rule::Sequence');
    isa_ok($rf->get_rule('name'), 'Data::RuledFactory::Rule::StringRandom');
    isa_ok($rf->get_rule('del_flg'), 'Data::RuledFactory::Rule::Constant');
    isa_ok($rf->get_rule('cb'), 'Data::RuledFactory::Rule::Callback');

    is($rf->get_rule('del_flg')->data, 0, 'del_flg is constant value equals 0');
};

subtest 'deleted' => sub {
    my $rf = Declare::User->build('Deleted');
    isa_ok($rf, 'Data::RuledFactory');

    isa_ok($rf->get_rule([qw/id other_id/]), 'Data::RuledFactory::Rule::Sequence');
    isa_ok($rf->get_rule('name'), 'Data::RuledFactory::Rule::StringRandom');
    isa_ok($rf->get_rule('del_flg'), 'Data::RuledFactory::Rule::Constant');
    isa_ok($rf->get_rule('cb'), 'Data::RuledFactory::Rule::Callback');

    is($rf->get_rule('del_flg')->data, 1, 'del_flg is constant value equals 1');
};

subtest 'constant cb' => sub {
    my $rf = Declare::User->build('ConstantCb');
    isa_ok($rf, 'Data::RuledFactory');

    isa_ok($rf->get_rule([qw/id other_id/]), 'Data::RuledFactory::Rule::Sequence');
    isa_ok($rf->get_rule('name'), 'Data::RuledFactory::Rule::StringRandom');
    isa_ok($rf->get_rule('del_flg'), 'Data::RuledFactory::Rule::Constant');
    isa_ok($rf->get_rule('cb'), 'Data::RuledFactory::Rule::Constant');

    is($rf->get_rule('del_flg')->data, 1, 'del_flg is constant value equals 1');
};

done_testing;
