package Data::RuledFactory::Rule::Combinations;

use strict;
use warnings;
use parent qw(Data::RuledFactory::Rule);
use Algorithm::Combinatorics qw(combinations);

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : { @_ };

    my $data = delete $args->{data} || [];
    my $k    = delete $args->{k} || 1;
    my @combinations = combinations($data, $k);

    if ($k == 1) {
        @combinations = map { $_->[0] } @combinations;
    }

    %$args = $class->default_args(
        data         => $data,
        combinations => \@combinations,
        k            => $k,
        rows         => scalar(@combinations),
        %$args,
    );

    bless $args => $class;
}

sub _next {
    my $self = shift;
    return $self->{combinations}[$self->{cursor} - 1];
}

1;
__END__

=head1 NAME

Data::RuledFactory::Rule::Combinations -

=head1 SYNOPSIS

  use Data::RuledFactory::Rule::Combinations;

=head1 DESCRIPTION

Data::RuledFactory::Rule::Combinations is

=head1 AUTHOR

Toru Yamaguchi E<lt>zigorou@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# Local Variables:
# mode: perl
# perl-indent-level: 4
# indent-tabs-mode: nil
# coding: utf-8-unix
# End:
#
# vim: expandtab shiftwidth=4:

