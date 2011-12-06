package Data::RuledFactory::Rule::Combinations;

use strict;
use warnings;
use parent qw(Data::RuledFactory::Rule);
use Math::Counting ();
use Math::Combinatorics;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : { @_ };

    my $data = delete $args->{data} || [];
    my $k    = delete $args->{k} || 1;

    my $iterator = Math::Combinatorics->new( data => $data, count => $k );

    %$args = $class->default_args(
        data     => $data,
        iterator => $iterator,
        k        => $k,
        rows     => Math::Counting::combination(scalar @$data, $k),
        %$args,
    );

    bless $args => $class;
}

sub _next {
    my $self = shift;
    my @c = $self->{iterator}->next_combination;
    return @c > 1 ? \@c : $c[0];
}

sub reset {
    my $self = shift;
    $self->SUPER::reset;
    $self->{iterator} = Math::Combinatorics->new( data => $self->{data}, count => $self->{k} );
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

