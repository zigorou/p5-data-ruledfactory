package Data::RuledFactory::Rule::ListRandom;

use strict;
use warnings;
use parent qw(Data::RuledFactory::Rule);

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args  = ref $_[0] ? $_[0] : { @_ };

    %$args = $class->default_args(
        unique  => 0,
        data    => [],
        %$args,
    );

    if ($args->{unique}) {
        $args->{data} = [
            map { $_->[0] }
            sort { $a->[1] <=> $b->[1] }
            map { [ $_, rand ] }
            @{$args->{data}}
        ];
        $args->{rows} = scalar(@{$args->{data}});
    }

    bless $args => $class;
}

sub _next {
    my $self = shift;
    if ($self->{unique}) {
        return $self->{data}[$self->{cursor} - 1];
    }
    else {
        return $self->{data}[int(rand(scalar(@{$self->{data}})))];
    }
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

