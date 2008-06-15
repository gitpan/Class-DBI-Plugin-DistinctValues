use strict;
use warnings;
use Test::More;
use Test::Exception;

BEGIN {
    eval "use Class::DBI::Test::SQLite; use DBD::SQLite;";
    plan $@ ? (skip_all => 'needs Class::DBI::Test::SQLite, DBD::SQLite for testing') : (tests => 3);
}

{
    package Music::CD;
    use base qw/Class::DBI::Test::SQLite/;
    use Class::DBI::Plugin::DistinctValues;
    __PACKAGE__->set_table('cd');
    __PACKAGE__->columns(All => qw/cdid artist title year/);

    sub create_sql {
        q{
            cdid int UNSIGNED auto_increment,
            artist varchar(255),
            title varchar(255),
            year int,
            PRIMARY KEY(cdid)
        }
    }
}

{
    package main;

    Music::CD->insert({
        artist => 'foo',
        title  => 'bar',
        year   => 2004,
    });
    Music::CD->insert({
        artist => 'fog',
        title  => 'bag',
        year   => 2005,
    });
    Music::CD->insert({
        artist => 'fog',
        title  => 'egg',
        year   => 2003,
    });

    is_deeply [sort Music::CD->search_distinct_values('artist')], [sort qw(foo fog)], 'search_distinct_values';
    dies_ok { Music::CD->search_distinct_values('invalid_column') } 'died at invalid column name';

    my $cd = Music::CD->retrieve_all->first;
    dies_ok { $cd->search_distinct_values('artist') } 'search_distinct_values is a class method';
}

