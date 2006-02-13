use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'         => 'Class::DBI::Plugin::DistinctValues',
    'VERSION_FROM' => 'lib/Class/DBI/Plugin/DistinctValues.pm', # finds $VERSION
    'PREREQ_PM'    => {
        Test::More         => 0.32,
        Test::Exception    => 0.21,
        Class::DBI         => '3.0.11',
        Class::DBI::Plugin => 0.03,
        Scalar::Util       => 1.13,
    },
);
