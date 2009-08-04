package Class::DBI::Plugin::DistinctValues;
use strict;
use warnings;
our $VERSION = '0.04';
use base qw/Class::DBI::Plugin/;
use Scalar::Util qw/blessed/;
use 5.008001;

sub init {
    my $class = shift;

    $class->set_sql(DistinctValues => q{
        SELECT DISTINCT %s FROM __TABLE__
    });
}

sub search_distinct_values : Plugged {
    my ($class, $column) = @_;

    $class->_corak("search_distinct_values is class method") if blessed $class;
    $class->_croak("Unknown column : $column") unless $class->has_real_column($column);

    my $sth = $class->sql_DistinctValues($column);
    $sth->execute;
    return map {@{$_}} @{$sth->fetchall_arrayref};
}

1;
__END__

=head1 NAME

Class::DBI::Plugin::DistinctValues - You can get unique values of a column

=head1 SYNOPSIS

    package Music::CD;
    use base qw/Class::DBI/;
    use Class::DBI::Plugin::DistinctValues;
    __PACKAGE__->columns(All => qw/id artist title year/);

    package main;
    use Music::CD;
    my @artists = Music::CD->search_distinct_values('artist');

=head1 DESCRIPTION

Class::DBI::Plugin::DistinctValues is plugin for CDBI.
You can get unique values of a column.

=head1 AUTHOR

MATSUNO Tokuhiro E<lt>tokuhiro at mobilefactory.jpE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Class::DBI>

=cut
