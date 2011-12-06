use strict;
use warnings;

use Test::More;
use Data::RuledFactory::Rule::Sequence;

subtest 'min: 1. max: 10. step: 1' => sub {
    my $r = Data::RuledFactory::Rule::Sequence->new(
        min => 1,
        max => 10,
        step => 1,
    );

    my $i;
    for $i (1..10) {
        my $expect = 1 + 1 * ( $i - 1 );
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        is $r->next, $expect, sprintf('next() is %02.2f (times: %d)', $expect, $i);
    }

    $i++;

    ok !$r->has_next, sprintf('has_next() is false (times: %d)', $i);
    is $r->next, undef, sprintf('next() is undef (times: %d)', $i);
};

subtest 'min: 1. max: 10. step: 1.5' => sub {
    my $r = Data::RuledFactory::Rule::Sequence->new(
        min => 1,
        max => 10,
        step => 1.5,
    );

    my $i;
    for $i (1..7) {
        my $expect = 1 + 1.5 * ( $i - 1 );
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        is $r->next, $expect, sprintf('next() is %02.2f (times: %d)', $expect, $i);
    }

    $i++;

    ok !$r->has_next, sprintf('has_next() is false (times: %d)', $i);
    is $r->next, undef, sprintf('next() is undef (times: %d)', $i);
};

subtest 'min: -10. max: -1. step: -3' => sub {
    my $r = Data::RuledFactory::Rule::Sequence->new(
        min => -10,
        max => -1,
        step => -3,
    );

    my $i;
    for $i (1..4) {
        my $expect = -1 - 3 * ( $i - 1 );
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        is $r->next, $expect, sprintf('next() is %02.2f (times: %d)', $expect, $i);
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

