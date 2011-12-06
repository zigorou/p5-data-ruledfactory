#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Data::Dump qw(dump);
use Data::RuledFactory;

my $rf = Data::RuledFactory->new;

$rf->add_rule(
    [qw/user friend/] => [ Tuples => { data => [ 1 .. 7 ], k => 2 } ]
);

my $rs = $rf->to_array(0, 10);
dump $rs;
