use strict;
use warnings;

use Test::More;
use Data::RuledFactory::Rule::Tuples;

subtest 'data: 1..4. k:2' => sub {
    my $r = Data::RuledFactory::Rule::Tuples->new(
        data => [1 .. 4],
        k => 2,
    );

    my $i;

    for $i (1..$r->rows) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        my $got = $r->next;
        is scalar @$got, 2, sprintf('next() returns 2 items array reference');
        isnt $got->[0], $got->[1], sprintf('item[0] is not equals item[1]');
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

