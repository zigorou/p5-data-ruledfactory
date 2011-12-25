package Data::RuledFactory::Declare;

use strict;
use warnings;

use parent qw/Exporter/;
our @EXPORT = qw/define/;

use Class::Load qw(load_class);

use Data::RuledFactory;

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
    my $defined_fields = $class->can('_defined_fields') ?
        $class->_defined_fields : ();

    no strict 'refs';
    for my $field (@$fields) {
        *{"$class\::$field"} = sub { $rule };
        $defined_fields->{$field} = 1;
    }

    no warnings 'redefine';
    *{"$class\::_defined_fields"} = sub { $defined_fields };
}


1;
__END__

=head1 NAME

Data::RuledFactory::Declare - DSL to predefine rules on .pm files

=head1 SYNOPSIS

    package MyProj::DataFactory::User;

    use Data::RuledFactory::Declare;

    define [qw/id other_id/] => "Sequence", +{ min => 1, max => 100, step => 1 };
    define name => "StringRandom", +{ data => "[A-Za-z]{8,12}" };
    define del_flg => 0;

    1;

    package MyProj::DataFactory::User::Deleted;

    use parent qw/MyProj::DataFactory::User/;

    # override parent's rule
    define del_flg => 1;

    1;

    use strict;
    use warnings;

    # create Data::RuledFactory instance with predefined rules in MyProj::DataFactory::User
    my $rf_user = Data::RuledFactory->new(
        base_class => "MyProj::DataFactory::User",
    );
    my $rf_user_deleted = $rf_user->subclass("Deleted");

    while ($rf_user->has_next) {
        my $d = $rf_user->next;
        # use $d for something
    }

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

