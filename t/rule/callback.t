use strict;
use warnings;

use Test::More;
use Data::RuledFactory::Rule::Callback;

subtest 'default' => sub {
    my $r = Data::RuledFactory::Rule::Callback->new(
        callback => sub {
            my $rule = shift;
            return $rule->cursor * 5;
        },
        rows => 5,
    );

    my $i;

    for $i (1..5) {
        my $expect = 5 * $i;
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        is $r->next, $expect, sprintf('next() equals %d (times: %d)', $expect, $i);
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

