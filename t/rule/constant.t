use strict;
use warnings;

use Test::More;
use Data::RuledFactory::Rule::Constant;

subtest 'default' => sub {
    my $r = Data::RuledFactory::Rule::Constant->new(
        const => 10,
        rows => 5,
    );

    my $i;

    for $i (1..5) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        is $r->next, 10, 'next() equals 10';
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

