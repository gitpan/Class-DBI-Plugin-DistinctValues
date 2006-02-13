use strict;
use warnings;
use Test::More;
use Test::Exception;

BEGIN {
    eval "use DBD::SQLite";
    plan $@ ? (skip_all => 'needs DBD::SQLite for testing') : (tests => 3);
}

{
    package Music::CD;
    use base 'Class::DBI';
    use File::Temp qw/tempfile/;
    use Class::DBI::Plugin::DistinctValues;

    my (undef, $DB) = tempfile();
    my @DSN = ("dbi:SQLite:dbname=$DB", '', '', { AutoCommit => 1 });

    END { unlink $DB if -e $DB }

    __PACKAGE__->set_db(Main => @DSN);
    __PACKAGE__->table('cd');
    __PACKAGE__->columns(All => qw/cdid artist title year/);

    sub CONSTRUCT {
        my $class = shift;
        $class->db_Main->do(qq{
            CREATE TABLE cd (
                cdid int UNSIGNED auto_increment,
                artist varchar(255),
                title varchar(255),
                year int,
                PRIMARY KEY(cdid)
            )
        });
        $class->insert({
            artist => 'foo',
            title  => 'bar',
            year   => 2004,
        });
        $class->insert({
            artist => 'fog',
            title  => 'bag',
            year   => 2005,
        });
        $class->insert({
            artist => 'fog',
            title  => 'egg',
            year   => 2003,
        });
    }
}

{
    package main;
    Music::CD->CONSTRUCT;
    is_deeply [Music::CD->search_distinct_values('artist')], [qw(foo fog)], 'search_distinct_values';
    dies_ok { Music::CD->search_distinct_values('invalid_column') } 'died at invalid column name';

    my $cd = Music::CD->retrieve_all->first;
    dies_ok { $cd->search_distinct_values('artist') } 'search_distinct_values is a class method';
}

