package Declare::User;

use strict;
use warnings;

use Data::RuledFactory::Declare;

define [qw/id other_id/] => "Sequence", +{ min => 1, max => 100, step => 1 };
define name => "StringRandom", +{ data => "[A-Za-z]{8,12}" };
define del_flg => 0;
define cb => sub { "callback" };

1;
