package Data::RuledFactory::Declare;

use strict;
use warnings;

use Carp;
use Data::RuledFactory;

sub import {
    my $class = shift;
    my $package = scalar caller;

    no strict 'refs';
    no warnings 'redefine';

    *{"$package\::__FACTORY__"} = {};
    *{"$package\::build"}       = \&build;
    *{"$package\::factory"}     = \&factory;
    *{"$package\::name"}        = sub { goto &name; };
    *{"$package\::parent"}      = sub { goto &parent; };
    *{"$package\::define"}      = sub { goto &define; };
}

sub build {
    my ($class, $name) = @_;

    no strict 'refs';
    unless ( exists ${"$class\::__FACTORY__"}{$name} ) {
        croak sprintf('Specified factory name (%s) is not exists', $name);
    }

    my $opts = ${"$class\::__FACTORY__"}{$name};

    my $rf = Data::RuledFactory->new(
        rules => [ @{$opts->{rules}} ],
    );

    my $parent = $opts->{parent};

    while (defined $parent && exists ${"$class\::__FACTORY__"}{$parent}) {
        my $parent_opts = ${"$class\::__FACTORY__"}{$parent};

        my @parent_rules = @{$parent_opts->{rules}};
        while ( my ($fields, $rule) = splice(@parent_rules, 0, 2) ) {
            next if ($rf->is_exists_rule($fields));
            $rf->set_rule($fields, $rule);
        }
        $parent = $parent_opts->{parent};
    }

    return $rf;
}

sub factory(&;@) {
    my $cb = shift;
    my $package = scalar caller;

    no strict 'refs';
    no warnings 'redefine';

    my %opts = (
        name    => undef,
        parent  => undef,
        rules   => [],
    );

    local *name   = sub {
        my $name = shift;
        $opts{name} = $name;
    };

    local *parent = sub {
        my $parent = shift;
        $opts{parent} = $parent;
    };

    local *define = sub {
        my $fields = shift;
        my $rule_args = @_ > 1 ? [ @_ ] : $_[0];
        my $rule = Data::RuledFactory->create_rule($rule_args);
        push(@{$opts{rules}}, $fields, $rule);
    };

    $cb->();

    unless (defined $opts{name}) {
        croak 'The name() is mandatory';
    }

    if (defined $opts{parent} && !exists *{"$package\::__FACTORY__"}->{$opts{parent}}) {
        croak sprintf('Specified parent factory(%s) is not exists', $opts{parent});
    }

    ${"$package\::__FACTORY__"}{$opts{name}} = \%opts;

    return 1;
}

### Inspired from Web::Scraper, miyagawa++
sub __stub {
    my $func = shift;
    return sub {
        croak "Can't call $func() outside factory block";
    };
}

*name   = __stub 'name';
*parent = __stub 'parent';
*define = __stub 'define';

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

