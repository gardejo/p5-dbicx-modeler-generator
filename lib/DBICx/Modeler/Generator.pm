package DBICx::Modeler::Generator;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# perl dependency
# ****************************************************************

use 5.008_001;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;
use MooseX::Orochi;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# class constant(s)
# ****************************************************************

our $VERSION = "0.00";


# ****************************************************************
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator' => (
    args => {
        class  => bind_value '/DBICx/Modeler/Generator/Class',
        driver => bind_value '/DBICx/Modeler/Generator/Driver',
        model  => bind_value '/DBICx/Modeler/Generator/Model',
        path   => bind_value '/DBICx/Modeler/Generator/Path',
        schema => bind_value '/DBICx/Modeler/Generator/Schema',
    },
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'class' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::ClassLike',
    required    => 1,
    handles     => {
        _reload_model_class  => [ reload_class => 'model'  ],
        _reload_schema_class => [ reload_class => 'schema' ],
    },
);

has 'driver' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::DriverLike',
    required    => 1,
    handles     => {
        deploy_database => 'deploy_database',
    },
);

has 'model' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::ModelLike',
    required    => 1,
    handles     => {
        _make_models => 'make_models',
    },
);

has 'path' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::PathLike',
    required    => 1,
    handles     => {
        _remove_models      => [ remove_path => {
            file      => 'target_model',
            directory => 'target_models',
        } ],
        _remove_schemata    => [ remove_path => {
            file      => 'target_schema',
            directory => 'target_schemata',
        } ],
        _add_source_library => 'add_source_library',
    },
);

has 'schema' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::SchemaLike',
    required    => 1,
    handles     => {
        _make_schemata => 'make_schemata',
    },
);


# ****************************************************************
# public method(s)
# ****************************************************************

sub update_models {
    my $self = shift;

    $self->_remove_models;

    $self->_make_models;

    # $self->_add_source_library;
    # $self->_reload_model_class;
    # $self->_make_models;

    return;
}

sub update_schemata {
    my $self = shift;

    $self->_remove_schemata;

    $self->_make_schemata;

    $self->_add_source_library;
    $self->_reload_schema_class;
    $self->_make_schemata;

    return;
}


# ****************************************************************
# compile-time process(es)
# ****************************************************************

__PACKAGE__->meta->make_immutable;


# ****************************************************************
# return true
# ****************************************************************

1;
__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

DBICx::Modeler::Generator - Dynamic definition of a DBICx::Modeler model

=head1 SYNOPSIS

    use Orochi;

    my $container = Orochi->new;
    $container->inject_literal('/Class/application' => 'MyApp');
    $container->inject_literal('/Path/root' => 'examples');
    # ...
    $container->inject_class('DBICx::Modeler::Generator');
    $container->inject_class('DBICx::Modeler::Generator::Class');
    # ...
    my $generator = $container->get('/DBICx/Modeler/Generator');

    $generator->deploy_database;
    $generator->update_schemata;
    $generator->update_models;

    # note: use DBICx::Modeler::Generator::CLI instead of above codes.

=head1 DESCRIPTION

This module provides dynamic definition of a L<DBICx::Modeler> model.

=head1 METHODS

=head2 Services

=head3 C<< $self->deploy_database() >>

Deploys database with a creation script.

=head3 C<< $self->update_models() >>

Updates model modules.

=head3 C<< $self->update_schemata() >>

Updates schema modules.

=head1 DEPENDENCY INJECTION

This class and subclasses using L<MooseX::Orochi> for dependency injection.

See C</examples/src/sbin/maintain_models.pl> in this distribution
for further datail.

=head2 Mandatory dependencies

=head3 C<< /DBICx/Modeler/Generator/Class >>

It is an implement class
which complies with the L<DBICx::Modeler::Generator::ClassLike> interface.

This distribution contains the implement class
which named L<DBICx::Modeler::Generator::Class> for common usage.

=head3 C<< /DBICx/Modeler/Generator/Class/application >>

It is a class name of the application root.

=over 4

=item Type

C<< Str >>

=item Example

C<< MyApp >>, C<< My::App >>, etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver >>

It is an implement class
which complies with the L<DBICx::Modeler::Generator::DriverLike> interface.

This distribution contains the implement classes
which named L<DBICx::Modeler::Generator::Driver::MySQL>
and L<DBICx::Modeler::Generator::Driver::SQLite>
for common usage.

=head3 C<< /DBICx/Modeler/Generator/Model >>

It is an implement class
which complies with the L<DBICx::Modeler::Generator::ModelLike> interface.

This distribution contains the implement class
which named L<DBICx::Modeler::Generator::Model> for common usage.

=head3 C<< /DBICx/Modeler/Generator/Path >>

It is an implement class
which complies with the L<DBICx::Modeler::Generator::PathLike> interface.

This distribution contains the implement class
which named L<DBICx::Modeler::Generator::Path> for common usage.

=head3 C<< /DBICx/Modeler/Generator/Path/root >>

It is a directory path of the application root.

=over 4

=item Type

L<Path::Class::Dir> (can be coerce with L<MooseX::Types::Path::Class>)

=item Example

C<< /path/to/root >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema >>

It is an implement class
which complies with the L<DBICx::Modeler::Generator::SchemaLike> interface.

This distribution contains the implement class
which named L<DBICx::Modeler::Generator::Schema> for common usage.

=head3 C<< /DBICx/Modeler/Generator/Tree >>

It is an implement class
which complies with the L<DBICx::Modeler::Generator::TreeLike> interface.

This distribution contains the implement class
which named L<DBICx::Modeler::Generator::Tree> for common usage.

=head2 Optional dependencies

=head3 C<< /DBICx/Modeler/Generator/Class/base_part >>

=over 4

=item Type

C<< Str >>

=item Default

C<< Base >>

=back

=head3 C<< /DBICx/Modeler/Generator/Class/model_part >>

=over 4

=item Type

C<< Str >>

=item Default

C<< Model >>

=back

=head3 C<< /DBICx/Modeler/Generator/Class/schema_part >>

=over 4

=item Type

C<< Str >>

=item Default

C<< Schema >>

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/database >>

=over 4

=item Type

C<< Str >>

=item Default

C<< $application >>, C<< /$root/$application.$database_extension >>, etc.

=item Example

C<< myapp >>, C<< my_app >>, C<< /path/to/root/my_app.db >>, etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/bin >>

=over 4

=item Type

C<< Str >>

=item Default

C<< mysql >>
(from the implement class L<DBICx::Modeler::Generator::Driver::MySQL>),
C<< sqlite3 >>
(from the implement class L<DBICx::Modeler::Generator::Driver::SQLite>),
etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/dbd >>

=over 4

=item Type

C<< Str >>

=item Default

C<< mysql >>
(from the implement class L<DBICx::Modeler::Generator::Driver::MySQL>),
C<< SQLite >>
(from the implement class L<DBICx::Modeler::Generator::Driver::SQLite>),
etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/dsn >>

=over 4

=item Type

C<< Str >>

=item Default

C<< dbi:$dbd:database=$database >>,
C<< dbi:$dbd:database=$database;host=$host >>,
C<< dbi:$dbd:database=$database;host=$host;port=$port >>,
C<< dbi:$dbd:dbname=$database >>,
etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/extension >>

=over 4

=item Type

C<< Str >>

=item Default

C<< .db >>
from the implement class L<DBICx::Modeler::Generator::Driver::SQLite>,
etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/host >>

=over 4

=item Type

C<< Str >>

=item Default

C<< undef >> (it means C<< localhost >>)

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/password >>

=over 4

=item Type

C<< Str >>

=item Example

C<< foobar >>

=item Default

C<< undef >>

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/port >>

=over 4

=item Type

C<< Int >>

=item Example

C<< 3306 >>, C<< 3307 >>, etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/username >>

=over 4

=item Type

C<< Str >>

=item Eexample

C<< mysql_user >>

=back

=head3 C<< /DBICx/Modeler/Generator/Path/creation_script >>

=over 4

=item Type

L<Path::Class::File> (can be coerce with L<MooseX::Types::Path::Class>)

=item Default

C<< /$root/$source/$application.$script_extension >>

=item Example

C<< /path/to/root/src/myapp.sql >>

=back

=head3 C<< /DBICx/Modeler/Generator/Path/module_extension >>

=over 4

=item Type

C<< Str >>

=item Default

C<< .pm >>

=back

=head3 C<< /DBICx/Modeler/Generator/Path/script_extension >>

=over 4

=item Type

C<< Str >>

=item Default

C<< .sql >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema/components >>

=over 4

=item Type

C<< ArrayRef[Str] >>

=item Default

C<< [qw(UTF8Columns)] >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema/is_debug >>

=over 4

=item Type

C<< Bool >>

=item Default

C<< 0 >> (false)

=back

=head3 C<< /DBICx/Modeler/Generator/Tree/application >>

=over 4

=item Type

C<< Str >>

=item Default

C<< myapp >> (from application class name C<< MyApp >>),
C<< my_app >> (from application class name C<< My::App >>),
etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Tree/library >>

=over 4

=item Type

C<< ArrayRef[Str] >>

=item Default

C<< [qw(lib)] >>

=back

=head3 C<< /DBICx/Modeler/Generator/Tree/source >>

=over 4

=item Type

C<< ArrayRef[Str] >>

=item Default

C<< [qw(src)] >>

=back

=head3 C<< /DBICx/Modeler/Generator/Tree/target >>

=over 4

=item Type

C<< ArrayRef[Str] >>

=item Default

C<< [] >>

=back

=head1 EXAMPLES

Run the following command at root directory of this distribution:

    perl -Ilib examples/src/sbin/maintain_models.pl \\
         -a MyApp -r examples -d SQLite

or

    perl -Ilib examples/src/sbin/maintain_models.pl \\
         -a MyApp -r examples -d MySQL -u username -w password \\
         -l /Path/script_extension=_mysql.sql

or

    perl -Ilib examples/src/sbin/maintain_models.pl \\
         -a MyApp -r examples -d MySQL -u username -w password \\
         -h hostname -p 3307 \\
         -l /Path/script_extension=_mysql.sql

or

    perl -Ilib examples/src/sbin/maintain_models.pl \\
         --configfile examples/src/myapp.yml

=head1 SEE ALSO

=over 4

=item *

L<DBICx::Modeler>

=item *

L<DBIx::Class::Schema::Loader>

=item *

L<DBIx::Class>

=back

=head1 TO DO

=over 4

=item *

More tests

=item *

Using L<Test::mysqld> for tests
(cf. L<http://mt.endeworks.jp/d-6/2009/10/things-ive-done-while-using-test-mysqld.html>
by Daisuke Maki, a.k.a. lestrrat)

=item *

Using L<Test::Moose> for tests

=back

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head2 Making suggestions and reporting bugs

Please report any found bugs, feature requests, and ideas for improvements
to L<http://github.com/gardejo/p5-dbicx-modeler-generator/issues>.
I will be notified, and then you'll automatically be notified of progress
on your bugs/requests as I make changes.

When reporting bugs, if possible,
please add as small a sample as you can make of the code
that produces the bug.
And of course, suggestions and patches are welcome.

=head1 SUPPORT

You can find documentation for this module with the C<perldoc> command.

    perldoc DBICx::Modeler::Generator

=head1 VERSION CONTROL

This module is maintained using git.
You can get the latest version from
L<git://github.com/gardejo/p5-dbicx-modeler-generator.git>.

=head1 CODE COVERAGE

I use L<Devel::Cover> to test the code coverage of my tests,
below is the C<Devel::Cover> summary report on this library's test suite.

 ---------------------------- ------ ------ ------ ------ ------ ------ ------
 File                           stmt   bran   cond    sub    pod   time  total
 ---------------------------- ------ ------ ------ ------ ------ ------ ------
 ...BICx/Modeler/Generator.pm  100.0    n/a    n/a  100.0  100.0    0.0  100.0
 .../Modeler/Generator/CLI.pm  100.0  100.0    n/a  100.0    0.0   22.2   98.0
 ...odeler/Generator/Class.pm  100.0    n/a    n/a  100.0  100.0    0.0  100.0
 ...er/Generator/ClassLike.pm  100.0    n/a    n/a  100.0    n/a    0.0  100.0
 .../Generator/Driver/Base.pm  100.0  100.0    n/a  100.0  100.0    0.0  100.0
 ...Generator/Driver/MySQL.pm  100.0  100.0    n/a  100.0    n/a    0.0  100.0
 ...enerator/Driver/SQLite.pm  100.0    n/a    n/a  100.0    n/a   11.1  100.0
 ...r/Generator/DriverLike.pm  100.0    n/a    n/a  100.0    n/a    0.0  100.0
 ...odeler/Generator/Model.pm  100.0  100.0    n/a  100.0  100.0   44.4  100.0
 ...er/Generator/ModelLike.pm  100.0    n/a    n/a  100.0    n/a    0.0  100.0
 ...Modeler/Generator/Path.pm  100.0  100.0    n/a  100.0  100.0    0.0  100.0
 ...ler/Generator/PathLike.pm  100.0    n/a    n/a  100.0    n/a    0.0  100.0
 ...deler/Generator/Schema.pm  100.0   50.0    n/a  100.0  100.0   22.2   97.6
 ...r/Generator/SchemaLike.pm  100.0    n/a    n/a  100.0    n/a    0.0  100.0
 ...Modeler/Generator/Tree.pm  100.0    n/a    n/a  100.0    n/a    0.0  100.0
 ...ler/Generator/TreeLike.pm  100.0    n/a    n/a  100.0    n/a    0.0  100.0
 Total                         100.0   94.4    n/a  100.0   91.7  100.0   99.7
 ---------------------------- ------ ------ ------ ------ ------ ------ ------

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. "Gardejo")

C<< <moriya at ermitejo dot com> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by MORIYA Masaki (a.k.a. "Gardejo"),
L<http://ttt.ermitejo.com>.

This library is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl> and L<perlartistic>.

=cut
