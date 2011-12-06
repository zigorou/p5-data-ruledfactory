package Data::RuledFactory::Rule::Callback;

use strict;
use warnings;
use parent qw(Data::RuledFactory::Rule);

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : { @_ };
    %$args = $class->default_args(%$args);
    bless $args => $class;
}

sub has_next {
    my $self = shift;

    unless ($self->{data}) {
        return 0;
    }

    $self->SUPER::has_next();
}

sub _next {
    my $self = shift;
    return $self->{data}->($self);
}

1;
__END__

=head1 NAME

Data::RuledFactory::Rule::Callback -

=head1 SYNOPSIS

  use Data::RuledFactory::Rule::Callback;

=head1 DESCRIPTION

Data::RuledFactory::Rule::Callback is

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

