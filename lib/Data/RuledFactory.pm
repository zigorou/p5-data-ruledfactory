package Data::RuledFactory;

use strict;
use warnings;
use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/rules columns rows/],
);
use Class::Load qw(load_class);
use List::Util qw(min);

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args  = ref $_[0] ? $_[0] : { @_ };
    my $rules = delete $args->{rules} || [];

    %$args = (
        columns => undef,
        cursor  => 0,
        rows    => undef,
        rules   => [],
        %$args,
    );

    my $self = bless $args => $class;

    while ( my ($fields, $rule) = splice(@$rules, 0, 2) ) {
        $self->add_rule( $fields, $rule, 1 );
    }

    $self;
}

sub add_rule {
    my ( $self, $fields, $rule, $ignore_adjust_rows ) = @_;

    my ($rule_class, $rule_args);

    if ( ref $rule eq 'ARRAY' ) {
        ($rule_class, $rule_args) = @$rule;
        $rule_class = index($rule_class, '+') == 0 ? substr($rule_class, 1) : 'Data::RuledFactory::Rule::' . $rule_class;
    }
    elsif ( ref $rule eq 'CODE' ) {
        ($rule_class, $rule_args) = (
            'Data::RuledFactory::Rule::Callback',
            { data => $rule },
        );
    }
    else {
        ($rule_class, $rule_args) = (
            'Data::RuledFactory::Rule::Constant',
            { data => $rule },
        );
    }

    load_class $rule_class;
    push(@{$self->{rules}}, [ $fields => $rule_class->new( $rule_args ) ]);

    unless ($ignore_adjust_rows) {
        $self->adjust_rows;
    }
}

sub has_next {
    my $self = shift;

    return 0 if (defined $self->{rows} && $self->{cursor} >= $self->{rows});

    my $has_next = 1;
    for my $rule ( map { $_->[1] } @{$self->{rules}} ) {
        unless ($rule->has_next) {
            $has_next = 0;
            last;
        }
    }

    return $has_next;
}

sub next {
    my ($self, $as_arrayref) = @_;

    unless ($self->has_next) {
        return;
    }

    $self->{cursor}++;

    my $v = {};
    my $columns = $self->{columns};
    my $defined_columns = defined $columns ? 1 : 0;
    $columns ||= [];

    for my $pair (@{$self->{rules}}) {
        my ($fields, $rule) = @$pair;
        my @fields = ref $fields ? @$fields : $fields;
        unless ($defined_columns) {
            push(@$columns, @fields);
        }

        return unless ($rule->has_next);

        my $next_val = $rule->next($v);

        return unless defined $next_val;

        if (@fields > 1) {
            @$v{@fields} = @{$next_val};
        }
        else {
            $v->{$fields} = $next_val;
        }
    }

    $self->{columns} = $columns;

    my $rv = $as_arrayref ? [ @$v{@$columns} ] : { map { $_ => $v->{$_} } @$columns };

    return $rv;
}

sub to_array {
    my ($self, $as_arrayref, $max_rows) = @_;
    $as_arrayref = 0 unless (defined $as_arrayref);
    $max_rows  ||= $self->{rows};
    my @rs = map { $self->next($as_arrayref) } (1 .. $max_rows);
    wantarray ? @rs : \@rs;
}

sub adjust_rows {
    my $self = shift;
    my $min_rows = min grep { defined } map { $_->[1]->rows } @{$self->{rules}};
    unless (defined $self->{rows}) {
        $self->{rows} = $min_rows;
    }
    else {
        $self->{rows} = min( $self->{rows}, $min_rows );
    }
}


1;
__END__

=head1 NAME

Data::RuledFactory -

=head1 SYNOPSIS

  use Data::RuledFactory;

=head1 DESCRIPTION

Data::RuledFactory is

=head1 AUTHOR

Toru Yamaguchi E<lt>zigorou@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
