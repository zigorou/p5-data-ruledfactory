package Data::RuledFactory::Rule::StringRandom;

use strict;
use warnings;
use parent qw(Data::RuledFactory::Rule);
use String::Random qw(random_regex);

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args  = ref $_[0] ? $_[0] : { @_ };

    %$args = $class->default_args(
        data    => q{\w+},
        %$args,
    );

    bless $args => $class;
}

sub _next {
    my $self = shift;
    return random_regex($self->{data});
}

1;
__END__

=head1 NAME

Data::RuledFactory::Rule::StringRandom -

=head1 SYNOPSIS

  use Data::RuledFactory::Rule::StringRandom;

=head1 DESCRIPTION

Data::RuledFactory::Rule::StringRandom is

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

