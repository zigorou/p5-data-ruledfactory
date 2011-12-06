package Data::RuledFactory::Rule::Tuples;

use strict;
use warnings;
use parent qw(Data::RuledFactory::Rule);
use Algorithm::Combinatorics qw(tuples);

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : {@_};

    my $data = delete $args->{data} || [];
    my $k    = delete $args->{k}    || 1;
    my @tuples = tuples( $data, $k );

    if ($k == 1) {
        @tuples = map { $_->[0] } @tuples;
    }

    %$args = $class->default_args(
        k      => $k,
        tuples => \@tuples,
        rows   => scalar(@tuples),
        data   => $data,
        %$args,
    );

    bless $args => $class;
}

sub _next {
    my $self = shift;
    return $self->{tuples}[$self->{cursor} - 1];
}

1;
__END__

=head1 NAME

Data::RuledFactory::Rule::Tuples -

=head1 SYNOPSIS

  use Data::RuledFactory::Rule::Tuples;

=head1 DESCRIPTION

Data::RuledFactory::Rule::Tuples is

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

