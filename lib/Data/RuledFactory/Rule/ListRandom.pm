package Data::RuledFactory::Rule::ListRandom;

use strict;
use warnings;
use parent qw(Data::RuledFactory::Rule);
use Data::WeightedRoundRobin;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : { @_ };

    %$args = (
        list    => [],
        rows    => undef,
        cursor  => 0,
        %$args,
    );

    $args->{list} = Data::WeightedRoundRobin->new($args->{list});

    bless $args => $class;
}

sub has_next {
    my $self = shift;

    unless ( defined $self->{rows} ) {
        return 1;
    }

    return $self->{cursor} < $self->{rows} ? 1 : 0;
}

sub _next {
    my $self = shift;
    $self->{list}->next;
}


1;
__END__

=head1 NAME

Data::RuledFactory::Rule::ListRandom -

=head1 SYNOPSIS

  use Data::RuledFactory::Rule::ListRandom;

=head1 DESCRIPTION

Data::RuledFactory::Rule::ListRandom is

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

