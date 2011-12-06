package Data::RuledFactory::Rule::Sequence;

use strict;
use warnings;
use constant {
    pinf  => 2 ** 31 - 1,
    ninf => - 2 ** 31 - 1,
};
use parent qw(Data::RuledFactory::Rule);
use Carp;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : { @_ };

    %$args = $class->default_args(
        min        => undef,
        max        => undef,
        start      => undef,
        step       => 1,
        %$args,
    );

    if ( $args->{step} > 0 ) {
        $args->{min}   = 1            unless ( defined $args->{min} );
        $args->{max}   = pinf         unless ( defined $args->{max} );
        $args->{start} = $args->{min} unless ( defined $args->{start} );
        $args->{rows}  = int( ( $args->{max} - $args->{start} ) / $args->{step} ) + 1;
    }
    elsif ( $args->{step} < 0 ) {
        $args->{min}   = ninf         unless ( defined $args->{min} );
        $args->{max}   = -1           unless ( defined $args->{max} );
        $args->{start} = $args->{max} unless ( defined $args->{start} );
        $args->{rows}  = int( ( $args->{min} - $args->{start} ) / $args->{step} ) + 1;
    }
    else {
        croak 'step field must not be zero';
    }

    bless $args => $class;
}

sub _next {
    my ($self, $v) = @_;
    return $self->{start} + $self->{step} * ( $self->{cursor} - 1 );
}


1;
__END__

=head1 NAME

Data::RuledFactory::Rule::Sequence -

=head1 SYNOPSIS

  use Data::RuledFactory::Rule::Sequence;

=head1 DESCRIPTION

Data::RuledFactory::Rule::Sequence is

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

