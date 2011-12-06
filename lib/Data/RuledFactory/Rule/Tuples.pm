package Data::RuledFactory::Rule::Tuples;

use strict;
use warnings;
use parent qw(Data::RuledFactory::Rule);
use Iterator::Simple qw(iterator imap iflatten);
use Math::Counting ();
use Math::Combinatorics;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : {@_};

    my $data = delete $args->{data} || [];
    my $k    = delete $args->{k}    || 1;

    my $iterator = $class->_create_iterator($data, $k);

    %$args = $class->default_args(
        data   => $data,
        k      => $k,
        iterator => $iterator,
        rows => Math::Counting::permutation(scalar @$data, $k),
        %$args,
    );

    bless $args => $class;
}

sub _next {
    my $self = shift;
    my $p = $self->{iterator}->next;
    return @$p > 1 ? $p : $p->[0];
}

sub reset {
    my $self = shift;
    $self->SUPER::reset;
    $self->{iterator} = $self->_create_iterator( $self->{data}, $self->{k} );
}

sub _create_iterator {
    my ($proto, $data, $k) = @_;

    my $c = Math::Combinatorics->new( data => $data, count => $k );
    return iflatten(
        imap {
            my $p = Math::Combinatorics->new( data => $_ );
            iterator {
                my @p = $p->next_permutation;
                return @p == $k ? [ @p ] : undef;
            };
        }
        iterator {
            my @c = $c->next_combination;
            return @c == $k ? [ @c ] : undef;
        }
    );
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

