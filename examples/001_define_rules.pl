#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use DateTime;
use Data::RuledFactory;

my $rf = Data::RuledFactory->new;

$rf->add_rule( id => [ Sequence => { min => 1, max => 100, step => 1 } ] );
$rf->add_rule( name => [ ListRandom => { data => [qw/foo bar baz/] } ] );
$rf->add_rule(
    published_on => [
        RangeRandom => {
            min => DateTime->new( year => 2011, month => 12, day => 1 )->epoch,
            max => DateTime->new( year => 2011, month => 12, day => 24 )->epoch,
            incremental => 1,
            integer     => 1,
        }
    ]
);

$rf->rows(10);

while ($rf->has_next) {
    my $d = $rf->next;
    printf(
        "id: %d, name: %s, published_on: %s\n",
        $d->{id},
        $d->{name},
        $d->{published_on},
    );
}
