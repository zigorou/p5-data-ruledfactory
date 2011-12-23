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
    is(scalar Declare::User->_defined_fields, 5, "we defined five rules");

    isa_ok(Declare::User->del_flg, "Data::RuledFactory::Rule::Constant");
    isa_ok(Declare::User->cb, "Data::RuledFactory::Rule::Callback");
};

subtest 'override define' => sub {
    my $del_flg = Declare::User->del_flg;
    my $del_flg_deleted = Declare::User::Deleted->del_flg;
    is($del_flg->next, 1, "original del_flg rule returns constant 1");
    is($del_flg_deleted->next, 0, "overidden del_flg rule returns constant 0");
};

subtest 'create Data::RuledFactory object from declared class' => sub {
    my $rf = Data::RuledFactory->new(base_class => "Declare::User");
    isa_ok($rf, "Data::RuledFactory");
    is(scalar @{$rf->rules}, 5);

    note explain $rf->next;
};

done_testing;
