use strict;
use warnings;

use Test::More;
use Data::RuledFactory::Rule::CrossProduct;

subtest 'data: [ [1,2], [3,4] ]. permutation: 0' => sub {
    my $r = Data::RuledFactory::Rule::CrossProduct->new(
        data => [ [1, 2], [3, 4] ],
        permutation => 0,
    );

    is($r->rows, 4, 'rows');

    my $i;
    for $i (1..$r->rows) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        my $got = $r->next;
        is scalar @$got, 2, sprintf('next() returns 2 items array reference');
        like($got->[0], qr/^(1|2)$/, 'got data[0]');
        like($got->[1], qr/^(3|4)$/, 'got data[1]');
    }

    $i++;

    ok !$r->has_next, sprintf('has_next() is false (times: %d)', $i);
    is $r->next, undef, sprintf('next() is undef (times: %d)', $i);
};

subtest 'data: [ [1,2], [3,4] ]. permutation: 1' => sub {
    my $r = Data::RuledFactory::Rule::CrossProduct->new(
        data => [ [1, 2], [3, 4] ],
        permutation => 1,
    );

    is($r->rows, 8, 'rows');

    my $i;
    for $i (1..$r->rows) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        my $got = $r->next;
        is scalar @$got, 2, sprintf('next() returns 2 items array reference');

        if ($got->[0] < 3) {
            like($got->[0], qr/^(1|2)$/, 'got data[0]');
            like($got->[1], qr/^(3|4)$/, 'got data[1]');
        }
        else {
            like($got->[0], qr/^(3|4)$/, 'got data[0]');
            like($got->[1], qr/^(1|2)$/, 'got data[1]');
        }
    }

    $i++;

    ok !$r->has_next, sprintf('has_next() is false (times: %d)', $i);
    is $r->next, undef, sprintf('next() is undef (times: %d)', $i);
};

done_testing;

# Local Variables:
# mode: perl
# perl-indent-level: 4
# indent-tabs-mode: nil
# coding: utf-8-unix
# End:
#
# vim: expandtab shiftwidth=4:

