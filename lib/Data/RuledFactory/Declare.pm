package Data::RuledFactory::Declare;

use strict;
use warnings;

use parent qw/Exporter/;
our @EXPORT = qw/define/;

use Class::Load qw(load_class);

use Data::RuledFactory;
use Data::RuledFactory::Rule;

sub define {
    my ($fields, $rule_class, $rule_args) = @_;

    my $r = ($rule_class && $rule_args) ?
        [$rule_class, $rule_args] : $rule_class;

    ($rule_class, $rule_args) = Data::RuledFactory::_resolve_rule($r);

    load_class $rule_class;
    my $rule = $rule_class->new($rule_args);

    $fields = [$fields]
        if ref $fields ne "ARRAY";

    my $class = caller();
    my @defined_fields = $class->can('_defined_fields') ?
        $class->_defined_fields : ();

    no strict 'refs';
    for my $field (@$fields) {
        *{"$class\::$field"} = sub { $rule };
        push @defined_fields, $field;
    }

    no warnings 'redefine';
    *{"$class\::_defined_fields"} = sub { @defined_fields };
}


1;
__END__

=head1 NAME

Data::RuledFactory::Declare -

=head1 SYNOPSIS

  use Data::RuledFactory::Declare;

=head1 DESCRIPTION

Data::RuledFactory::Declare is

=head1 AUTHOR

Naosuke Yokoe E<lt>zentoooo@cpan.orgE<gt>

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

