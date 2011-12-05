package Data::RuledFactory::Rule;

use strict;
use warnings;
use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/after_next cursor rows prepare_next/],
);

our $VERSION = '0.01';

sub has_next { 0 }

sub next {
    my ($self, $v) = @_;

    if ( $self->{prepare_next} ) {
        $self->{prepare_next}->($self, $v);
    }

    unless ($self->has_next) {
        return;
    }

    $self->{cursor}++;
    my $rv = $self->_next;

    $self->{after_next} ? $self->{after_next}->($rv) : $rv;
}

sub apply_cb {
    my ($self, $callback, @args) = @_;
    return $self->{$callback} ? $self->{$callback}->(@args) : @args;
}



1;
__END__

=head1 NAME

Data::RuledFactory::Rule -

=head1 SYNOPSIS

  use Data::RuledFactory::Rule;

=head1 DESCRIPTION

Data::RuledFactory::Rule is

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

