package Data::RuledFactory::Rule::CrossProduct;

use strict;
use warnings;
use parent qw(Data::RuledFactory::Rule);
use Iterator::Simple qw(iterator imap iflatten);
use Math::Combinatorics;
use Math::Counting ();
use Set::CrossProduct;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : {@_};

    my $data = delete $args->{data} || [];
    my $k    = scalar @$data;

    my $rows ||= do {
        my $r = 1;
        for (@$data) {
            $r *= scalar(@$_);
        }

        if ($args->{permutation}) {
            $r *= Math::Counting::permutation($k, $k);
        }

        $r;
    };

    my $iterator = $class->_create_iterator($data, $k, $args->{permutation} || 0);

    %$args = $class->default_args(
        data        => $data,
        permutation => 0,
        k           => $k,
        iterator    => $iterator,
        rows        => $rows,
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
    $self->{iterator} = $self->_create_iterator( $self->{data}, $self->{k}, $self->{permutation} );
}

sub _create_iterator {
    my ($proto, $data, $k, $is_permutation) = @_;
    my $cp = Set::CrossProduct->new($data);

    unless ($is_permutation) {
        return iterator {
            my @c = $cp->get;
            return @c == $k ? [ @c ] : undef;
        };
    }

    return iflatten(
        imap {
            my $p = Math::Combinatorics->new( data => $_ );
            iterator {
                my @p = $p->next_permutation;
                return @p == $k ? [ @p ] : undef;
            };
        }
        iterator {
            my @c = $cp->get;
            return @c == $k ? [ @c ] : undef;
        }
    );
}

1;
__END__

=head1 NAME

Data::RuledFactory::Rule::CrossProduct -

=head1 SYNOPSIS

  use Data::RuledFactory::Rule::CrossProduct;

=head1 DESCRIPTION

Data::RuledFactory::Rule::CrossProduct is

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

