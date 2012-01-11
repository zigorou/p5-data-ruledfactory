package Declare::User;

use strict;
use warnings;
use Data::RuledFactory::Declare;

factory {
    name 'Default';
    rule [qw/id other_id/] => ( Sequence => { min => 1, max => 100, step => 1 });
    rule name              => ( StringRandom => { data => "[A-Za-z]{8,12}" } );
    rule del_flg           => 0;
    rule cb                => sub { "callback" };
};

factory {
    name 'Deleted';
    parent 'Default';
    rule del_flg => 1;
};

factory {
    name 'ConstantCb';
    parent 'Deleted';
    rule cb => 'constant';
};

1;
