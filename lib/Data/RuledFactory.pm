package Data::RuledFactory;

use strict;
use warnings;
use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/rules columns rows/],
);
use Class::Load qw(load_class);
use List::MoreUtils qw(first_index);
use List::Util qw(first min);

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args  = ref $_[0] ? $_[0] : { @_ };
    my $rules = delete $args->{rules} || [];

    %$args = (
        columns    => undef,
        cursor     => 0,
        rows       => undef,
        rules      => [],
        %$args,
    );

    my $self = bless $args => $class;

    while ( my ($fields, $rule) = splice(@$rules, 0, 2) ) {
        $self->_add_rule( $fields, $rule );
    }

    $self->adjust_rows;

    $self;
}

sub create_rule {
    my $proto = shift;

    return $_[0] if ( UNIVERSAL::isa($_[0], 'Data::RuledFactory::Rule' ) );

    my ($rule_class, $rule_args);

    if ( ref $_[0] eq 'ARRAY' || @_ == 2 ) {
        ($rule_class, $rule_args) = ref $_[0] ? @{$_[0]} : @_;
        $rule_class = index($rule_class, '+') == 0 ? substr($rule_class, 1) : 'Data::RuledFactory::Rule::' . $rule_class;
    }
    elsif ( ref $_[0] eq 'CODE' ) {
        ($rule_class, $rule_args) = (
            'Data::RuledFactory::Rule::Callback',
            { data => $_[0] },
        );
    }
    else {
        ($rule_class, $rule_args) = (
            'Data::RuledFactory::Rule::Constant',
            { data => $_[0] },
        );
    }
    
    load_class $rule_class;

    return $rule_class->new( $rule_args );
}

sub add_rule {
    my $self   = shift;
    my $fields = shift;

    $self->_add_rule($fields, @_);
    $self->adjust_rows;

    1;
}

sub _add_rule {
    my ($self, $fields, @rule_args) = @_;
    my $rule = $self->create_rule(@rule_args);
    push(@{$self->{rules}}, [ $fields => $rule ]);
    1;
}

sub get_rule {
    my ( $self, $fields ) = @_;

    my $rule_pair;
    if (ref $fields eq 'ARRAY') {
        $rule_pair = 
            first { join('_', @{$_->[0]}) eq join('_', @$fields) } 
            grep { ref $_->[0] }
            @{$self->{rules}};
    }
    else {
        $rule_pair = 
            first { $_->[0] eq $fields }
            grep { !ref $_->[0] }
            @{$self->{rules}};
    }

    return $rule_pair ? $rule_pair->[1] : undef;
}

sub get_rule_index {
    my ( $self, $fields ) = @_;

    my $idx;
    if (ref $fields eq 'ARRAY') {
        $idx = 
            first_index { ref $_->[0] && join('_', @{$_->[0]}) eq join('_', @$fields) } 
            @{$self->{rules}};
    }
    else {
        $idx = 
            first_index { !ref $_->[0] && $_->[0] eq $fields }
            @{$self->{rules}};
    }

    return $idx;
}

sub set_rule {
    my ($self, $fields, @rule_args) = @_;

    my $idx = $self->get_rule_index($fields);
    if ($idx == -1) {
        return $self->add_rule($fields, @rule_args);
    }

    $self->{rules}[$idx][1] = $self->create_rule(@rule_args);

    return 1;
}

sub is_exists_rule {
    my ( $self, $fields ) = @_;
    $self->get_rule_index($fields) >= 0 ? 1 : 0;
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

sub reset {
    my $self = shift;
    for (map { $_->[1] } @{$self->{rules}}) {
        $_->reset;
    }
}

sub adjust_rows {
    my $self = shift;
    my $min_rows = min grep { defined } map { $_->[1]->rows } @{$self->{rules}};

    return unless (defined $min_rows);

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

Data::RuledFactory - Create array or hash data given rules.

=head1 SYNOPSIS

  use Data::Dumper;
  use Data::RuledFactory;

  my $rf = Data::RuledFactory->new();
  $rf->add_rule(
    id => [
      Sequence => {
        min => 0,
        max => 100,
        step => 2,
      },
    ],
  );
  $rf->add_rule(
    name => [
      StringRandom => {
        data => '[A-Za-z]{8,12}',
      },
    ],
  );
  $rf->rows(5);

  while ($rf->has_next) {
      warn Dumper($rf->next);
  }

=head1 DESCRIPTION

=head2 Introduction

Data::RuledFactory is data generator library.
At first, you should define rules in order to each rule's syntax. For example:

  #!/usr/bin/env perl
  
  use strict;
  use warnings;
  use FindBin;
  use lib "$FindBin::Bin/../lib";
  use DateTime;
  use Data::RuledFactory;
  
  my $rf = Data::RuledFactory->new;
  
  $rf->add_rule( id => [ Sequence => { min => 1, max => 100, step => 1 } ] );
  $rf->add_rule( name => [ ListRandom => { data => [qw/foo bar baz/] } ] );
  $rf->add_rule(
      published_on => [
          RangeRandom => {
              min => DateTime->new( year => 2011, month => 12, day => 1 )->epoch,
              max => DateTime->new( year => 2011, month => 12, day => 24 )->epoch,
              incremental => 1,
              integer     => 1,
          }
      ]
  );
  
  $rf->rows(10);
  
  while ($rf->has_next) {
      my $d = $rf->next;
      printf(
          "id: %d, name: %s, published_on: %s\n",
          $d->{id},
          $d->{name},
          $d->{published_on},
      );
  }

Above example will output:

  id: 1, name: bar, published_on: 1324164976
  id: 2, name: foo, published_on: 1324209646
  id: 3, name: bar, published_on: 1324248870
  id: 4, name: foo, published_on: 1324334507
  id: 5, name: baz, published_on: 1324334794
  id: 6, name: foo, published_on: 1324387979
  id: 7, name: bar, published_on: 1324409908
  id: 8, name: baz, published_on: 1324410608
  id: 9, name: foo, published_on: 1324413150
  id: 10, name: bar, published_on: 1324438020

You might notice the way to use this module. It is two topics how to write rules and retrieve data.
In the next section describe the way to write rules.

=head2 Write rule definitions

At first, all supported built-in rule modules are following list.

=over

=item L<Data::RuledFactory::Rule::Callback>

Generate data from given callback.

=item L<Data::RuledFactory::Rule::Combinations>

Generate combination data from given list and size parameters. See L<Algorithm::Combinatorics>'s combinations routine.

=item L<Data::RuledFactory::Rule::Constant>

Generate constant data from given constant value.

=item L<Data::RuledFactory::Rule::ListRandom>

Generate random data from given list.

=item L<Data::RuledFactory::Rule::RangeRandom>

Generate random data from given range.

=item L<Data::RuledFactory::Rule::Sequence>

Generate sequential data from given step and other initial parameters.

=item L<Data::RuledFactory::Rule::StringRandom>

Generate random data from given regex. See L<String::Random>'s random_regex() routine.

=item L<Data::RuledFactory::Rule::Tuples>

Generate tuple data from given list and size parameters. See L<Algorithm::Combinatorics>'s combinations routine.

=back

When you want to define some field, you would use add_rule($fields, $rule[, ignore_adjust_rows]) method.
The method is ordinary accepted two arguments. First argument '$fields' must be scalar or array reference consist of field names.
And second argument is rule definition as array reference. The first element is rule module's name, for example 'Sequence'.
And next element is passing to rule module's constructor.

For example, you want to make single field retrieving sequential value:

  #!/usr/bin/env perl
  
  use strict;
  use warnings;
  use FindBin;
  use lib "$FindBin::Bin/../lib";
  use Data::Dumper;
  use Data::RuledFactory;
  
  my $rf = Data::RuledFactory->new;
  
  $rf->add_rule(
      id => [ Sequence => { min => 1, max => 100, step => 1 } ]
  );
  
  my @rs = $rf->to_array(0, 10);
  
  print join(',', map { $_->{id} } @rs);

Above example will output:

  1,2,3,4,5,6,7,8,9,10

Possibly, you might want to make combinations or tuples fields, For example:

  #!/usr/bin/env perl
  
  use strict;
  use warnings;
  use FindBin;
  use lib "$FindBin::Bin/../lib";
  use Data::Dump qw(dump);
  use Data::RuledFactory;
  
  my $rf = Data::RuledFactory->new;
  
  $rf->add_rule(
      [qw/user friend/] => [ Tuples => { data => [ 1 .. 7 ], k => 2 } ]
  );
  
  my $rs = $rf->to_array(0, 10);
  dump $rs;

Above example will output:

   { friend => 2, user => 1 },
   { friend => 3, user => 1 },
   { friend => 4, user => 1 },
   { friend => 5, user => 1 },
   { friend => 6, user => 1 },
   { friend => 7, user => 1 },
   { friend => 1, user => 2 },
   { friend => 3, user => 2 },
   { friend => 4, user => 2 },
   { friend => 5, user => 2 },

When you want to know detail of usage to each rule modules, you should read each documents.
The rule module is pluggable, so you can extend and make custom rule. Please see the source code of built-in rule module.

=head2 Retrieving generated data

=head1 METHODS

=head2 new()

=head2 add_rule()

=head2 has_next()

=head2 next()

=head2 to_array()

=head2 reset()

=head2 adjust_rows()

Internal use only.

=head1 AUTHOR

Toru Yamaguchi E<lt>zigorou@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
