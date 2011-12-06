use strict;
use warnings;

use Test::More;
use Data::RuledFactory::Rule::RangeRandom;

subtest 'min: 10. max: 100' => sub {
    my $r = Data::RuledFactory::Rule::RangeRandom->new(
        min => 10,
        max => 100,
        rows => 5,
        incremental => 0,
    );

    my $i;
    for $i ( 1 .. 5 ) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        my $got = $r->next;
        cmp_ok $got, '>=', 10, sprintf('next() (%02.2f) greather than or equals 10 (times: %d)', $got, $i);
        cmp_ok $got, '<', 100, sprintf('next() (%02.2f) less than 100 (times: %d)', $got, $i);
    }

    $i++;

    ok !$r->has_next, sprintf('has_next() is false (times: %d)', $i);
    is $r->next, undef, sprintf('next() is undef (times: %d)', $i);
};

subtest 'min: -10. max: 10. incremental: 1' => sub {
    my $r = Data::RuledFactory::Rule::RangeRandom->new(
        min => -10,
        max => 10,
        rows => 5,
        incremental => 1,
    );

    my $i;
    my $previous = -10;
    for $i ( 1 .. 5 ) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        my $got = $r->next;
        cmp_ok $got, '>=', -10, sprintf('next() (%02.2f) greather than or equals -10 (times: %d)', $got, $i);
        cmp_ok $got, '<', 10, sprintf('next() (%02.2f) less than 10 (times: %d)', $got, $i);
        cmp_ok $got, '>=', $previous, sprintf('next() (%02.2f) greather than or equals %02.2f (times: %d)', $got, $previous, $i);
        $previous = $got;
    }

    $i++;

    ok !$r->has_next, sprintf('has_next() is false (times: %d)', $i);
    is $r->next, undef, sprintf('next() is undef (times: %d)', $i);
};

subtest 'min: -10. max: 10. incremental: 1. integer: 1' => sub {
    my $r = Data::RuledFactory::Rule::RangeRandom->new(
        min => -10,
        max => 10,
        rows => 5,
        incremental => 1,
        integer => 1,
    );

    my $i;
    my $previous = -10;
    for $i ( 1 .. 5 ) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        my $got = $r->next;
        cmp_ok $got, '>=', -10, sprintf('next() (%d) greather than or equals -10 (times: %d)', $got, $i);
        cmp_ok $got, '<', 10, sprintf('next() (%d) less than 10 (times: %d)', $got, $i);
        cmp_ok $got, '>=', $previous, sprintf('next() (%d) greather than or equals %02.2f (times: %d)', $got, $previous, $i);
        $previous = $got;
    }

    $i++;

    ok !$r->has_next, sprintf('has_next() is false (times: %d)', $i);
    is $r->next, undef, sprintf('next() is undef (times: %d)', $i);
};

subtest 'min: -10. max: 10. incremental: -1. integer: 1' => sub {
    my $r = Data::RuledFactory::Rule::RangeRandom->new(
        min => -10,
        max => 10,
        rows => 5,
        incremental => -1,
        integer => 1,
    );

    my $i;
    my $previous = 10;
    for $i ( 1 .. 5 ) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        my $got = $r->next;
        cmp_ok $got, '>=', -10, sprintf('next() (%d) greather than or equals -10 (times: %d)', $got, $i);
        cmp_ok $got, '<', 10, sprintf('next() (%d) less than 10 (times: %d)', $got, $i);
        cmp_ok $got, '<=', $previous, sprintf('next() (%d) less than or equals %02.2f (times: %d)', $got, $previous, $i);
        $previous = $got;
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

