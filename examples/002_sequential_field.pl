#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Data::Dumper;
use Data::RuledFactory;

my $rf = Data::RuledFactory->new;

$rf->add_rule(
    id => [ Sequence => { min => 1, max => 100, step => 1 } ]
);

my @rs = $rf->to_array(0, 10);

print join(',', map { $_->{id} } @rs);
