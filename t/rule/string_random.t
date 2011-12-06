use strict;
use warnings;

use Test::More;
use Data::RuledFactory::Rule::StringRandom;

subtest 'default' => sub {
    my $r = Data::RuledFactory::Rule::StringRandom->new(
        rows => 10,
    );

    my $i;

    for $i ( 1.. 10 ) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        like $r->next, qr/^\w+$/, 'next() matches given regex';
    }

    $i++;

    ok !$r->has_next, sprintf('has_next() is false (times: %d)', $i);
    is $r->next, undef, sprintf('next() is undef (times: %d)', $i);
};

subtest 'data: "[a-z]{6,8}". rows: 5' => sub {
    my $r = Data::RuledFactory::Rule::StringRandom->new(
        data => q#[a-z]{6,8}#,
        rows => 10,
    );

    my $i;

    for $i ( 1.. 10 ) {
        ok $r->has_next, sprintf('has_next() is true (times: %d)', $i);
        like $r->next, qr/^[a-z]{6,8}$/, 'next() matches given regex';
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

