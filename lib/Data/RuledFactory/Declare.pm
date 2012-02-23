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
    *{"$package\::rule"}        = sub { goto &rule; };
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

    local *rule = sub {
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
*rule   = __stub 'rule';

1;

__END__

=head1 NAME

Data::RuledFactory::Declare - DSL to predefine rules on .pm files

=head1 SYNOPSIS

    package MyProj::DataFactory::User;

    use Data::RuledFactory::Declare;

    factory {
        name 'Default';
        rule [qw/id other_id/] => (Sequence => +{ min => 1, max => 100, step => 1 });
        rule name => (StringRandom => +{ data => "[A-Za-z]{8,12}" };
        rule del_flg => 0;
        rule cb => sub { "callback" };
    };

    factory {
        name 'Deleted';
        parent 'Default';
        rule del_flg => 1; # override parent's rule
    };

    1;

    use MyProj::DataFactory::User;

    # create Data::RuledFactory instance with predefined rules in MyProj::DataFactory::User

    my $rf_user = MyProj::DataFactory::User->build('Default');

    my $user = $rf_user->next;
    # do whatever you want with $user

    my $rf_user_deleted = MyProj::DataFactory::User->build('Deleted');
    my $deleted_user = $rf_user_deleted->next; # got user with del_flg => 1


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

