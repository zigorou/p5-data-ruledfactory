use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Declare::User;
use Declare::User::Deleted;

subtest 'define' => sub {
    can_ok("Declare::User", qw/id name del_flg/);
    my $id_rule = Declare::User->id;
    isa_ok($id_rule, "Data::RuledFactory::Rule", "declared method returns each rule");
    is(scalar keys %{ Declare::User->_defined_fields }, 5, "we defined five rules");

    isa_ok(Declare::User->del_flg, "Data::RuledFactory::Rule::Constant");
    isa_ok(Declare::User->cb, "Data::RuledFactory::Rule::Callback");
};

subtest 'override define' => sub {
    my $del_flg = Declare::User->del_flg;
    my $del_flg_deleted = Declare::User::Deleted->del_flg;
    is($del_flg->next, 0, "original del_flg rule returns constant 0");
    is($del_flg_deleted->next, 1, "overidden del_flg rule returns constant 1");
};

subtest 'create Data::RuledFactory object from declared class' => sub {
    my $user = Data::RuledFactory->new(base_class => "Declare::User");
    my $user_with_age = $user->child_rule("WithAge");

    isa_ok($user, "Data::RuledFactory");
    is(scalar @{ $user->rules }, 5);

    isa_ok($user_with_age, "Data::RuledFactory");
    is(scalar @{ $user_with_age->rules }, 6);

    note explain $user->next;
    note explain $user_with_age->next;
};

done_testing;
