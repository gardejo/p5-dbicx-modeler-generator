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

our $VERSION = "0.02";


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

DBICx::Modeler::Generator - Dynamic definition of a DBIx::Class::Schema and a DBICx::Modeler

=head1 VERSION

This document describes
L<DBICx::Modeler::Generator|DBICx::Modeler::Generator>
version C<0.02>.

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

    # note: let us use DBICx::Modeler::Generator::CLI instead of above codes.

=head1 DESCRIPTION

An enterprise application requires consideration of better architecture.
Especially, a modeling greatly influences maintainability of the application.

So, I recommend that to separate schemata and models
with L<DBICx::Modeler|DBICx::Modeler>.
This smart module provides a L<Moose|Moose>-based model layer
over L<DBIx::Class|DBIx::Class>.

However, we must define a lot of model modules
to receive the benefits of the separation.
It is a too tiresome job.

Therefore, let us automate tedious common definition
with this C<DBICx::Modeler::Generator> module
which provides features below:

=over 4

=item *

Dynamic deployment of database

=item *

Dynamic generation of L<DBIx::Class|DBIx::Class> schema modules

=item *

Dynamic generation of L<DBICx::Modeler|DBICx::Modeler> model modules

=back

As well, this C<DBICx::Modeler::Generator> module
can also be used as a simple automation wrapper
only dynamic generation of schema modules
with L<DBIx::Class::Schema::Loadler|DBIx::Class::Schema::Loadler>.

=head2 How to model in your application - typical workflow

=over 4

=item 1.

Design schemata with I<MySQL Workbench> application
(L<http://www.mysql.com/products/workbench/>).

This application can design tables, columns, indices, relationships,
and much more.

The sample of a schema file available for
F<examples/doc/DBDSC_schemata.mwb> in this distribution.
It catches L<DBICx::Modeler|DBICx::Modeler>'s test modules
which has C<artist>, C<cd>, and C<track> tables (schemata).

=item 2.

B<Optionally> draw an ERD (Entity-Relationship Diagram) with I<MySQL Workbench>
for documentation.

The sample of an exported graphic file available for
F<examples/doc/DBDERII_Including_Information.png> in this distribution.

=item 3.

Dynamically deploy a database with the schemata by
C<< [Database] - [Forward Engineer...] >> function
of I<MySQL Workbench>.

Or, by L<< deploy_database() method|/$self->deploy_database() >> of this module
with a creation (DDL: Data Definition Language) script which generated by
C<< [File] - [Export] - [Forward Engineer SQL CREATE Script...] >> function
of I<MySQL Workbench>.

The sample of an exported creation script file available for
F<examples/src/myapp_mysql.sql> (for MySQL) and
F<examples/src/myappl.sql> (for SQLite)
in this distribution.

Note: I<MySQL Workbench> can export DDL script for SQLite
with I<SQLite export plugin for MySQL Workbench> plugin
(L<http://www.henlich.de/software/sqlite-export-plugin-for-mysql-workbench/>).

=item 4.

Statically define (it means I<write it yourself>) schema module files
for additional definition.
For example, inflations, deflations, relationships, and much more.

The sample of schema module file
which describes only part of an additional definition available for
F<examples/src/lib/MyApp/Schema/Artist.pm> in this distribution.

=item 5.

Dynamically define schema module files
by L<< update_schemata() method|/$self->update_schemata() >> of this module.

For example, this will enable us to generate schema file which path is
F<examples/lib/MyApp/Schema/Artist.pm>,
F<examples/lib/MyApp/Schema/Cd.pm>, and much more
in this distribution.

=item 6.

Statically define (it means I<write it yourself>) model module files
for additional definition.
For example, L<Moose|Moose>'s attributes, methods, method modifiers,
and much more.

The sample of model module file
which describes only part of an additional definition available for
F<examples/src/lib/MyApp/Model/Cd.pm> in this distribution.

=item 7.

Dynamically define model module files
by L<< update_models() method|/$self->update_models() >> of this module.

For example, this will enable us to generate model file which path is
F<examples/lib/MyApp/Model/Artist.pm>,
F<examples/lib/MyApp/Model/Cd.pm>, and much more
in this distribution.

=back

=head2 Tips about modeling

=head3 Using a batch script

I recommend to use a batch script
which processes dynamic deployment of database, dynamic definition of schemata,
and dynamic definition of models.

The sample of a batch script file available for
F<examples/src/sbin/maintain_models.pl> in this distribution.
See L<EXAMPLES|/EXAMPLES> section for further detail.

=head3 How to make exported graphics the same size

In I<MySQL Workbench>, 1mm of an ERD correspond 5px of an exported PNG graphic
(This premise is correct as version 5.1.18 OSS of Windows binary).

On the basis of this observation, you can specify the size of a PNG graphic.

For example, to export as Quad-VGA resolution (width: 1280px, height: 960px),
I whould suggest that you specify setting below:

=over 4

=item C<< [Paper] >> group

select C<< [A4 (210 mm x 297 mm)] >> item from C<< [Size] >> listbox

=item C<< [Orientation] >> group

turn on C<< [Landscape] >> radio button

=item C<< [Margins] >> group

input C<< [10] >>mm into C<< [Top] >> text box

input C<< [10] >>mm into C<< [Left] >> text box

input C<< [35] >>mm into C<< [Bottom] >> text box

input C<< [12] >>mm into C<< [Right] >> text box 

=back

Just for reference, The sample of a size validator script file available for
F<examples/src/confirm_image_size.pl> in this distribution.

=head1 METHODS

=head2 Constructors

=head3 C<< $di_container->get('/DBICx/Modeler/Generator') >>

Returns a dependency injected object.

To get an object, use the code as the L<synopsis|/Synopsis> above
instead of C<< DBICx::Modeler::Generator->new(...) >>.

See L<DEPENDENCY INJECTION|/DEPENDENCY INJECTION> section
for further detail.

You may use also the wrapped interface
with L<DBICx::Modeler::Generator::CLI|DBICx::Modeler::Generator::CLI>.

=head3 C<< DBICx::Modeler::Generator::CLI->new_with_options(%init_args) >>

Returns an object of
L<DBICx::Modeler::Generator::CLI|DBICx::Modeler::Generator::CLI>.

I B<strongly> recommend that you use this interface to get a generator object
because the interface wraps dependency injection
with L<MooseX::Getopt|MooseX::Getopt>
and L<MooseX::SimpleConfig|MooseX::SimpleConfig>.

See concrete codes below:

    my $generator = DBICx::Modeler::Generator::CLI->new_with_options(
        application => 'MyApp',
        root        => '/path/to/root',
        driver      => 'SQLite',
    )->generator;

=head2 Services

=head3 C<< $self->deploy_database() >>

Deploys database with a creation script.

=head3 C<< $self->update_models() >>

Updates model modules.

=head3 C<< $self->update_schemata() >>

Updates schema modules.

=head1 DEPENDENCY INJECTION

This class and subclasses using L<MooseX::Orochi|MooseX::Orochi>
for DI (dependency injection).

See F<examples/src/sbin/maintain_models.pl> in this distribution
for further datail.

=head2 Mandatory dependencies

=head3 C<< /DBICx/Modeler/Generator/Class >>

It is an instance of an implement class which complies with the
L<DBICx::Modeler::Generator::ClassLike|DBICx::Modeler::Generator::ClassLike>
interface.

This distribution contains the implement class which named
L<DBICx::Modeler::Generator::Class|DBICx::Modeler::Generator::Class>
for common usage.

=head3 C<< /DBICx/Modeler/Generator/Class/application >>

It is a class name of the application root.

=over 4

=item Type

C<< Str >>

=item Example

C<< MyApp >>, C<< My::App >>, etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver >>

It is an instance of an implement class which complies with the
L<DBICx::Modeler::Generator::DriverLike|DBICx::Modeler::Generator::DriverLike>
interface.

This distribution contains the implement classes which named
L<DBICx::Modeler::Generator::Driver::MySQL|
DBICx::Modeler::Generator::Driver::MySQL>
and L<DBICx::Modeler::Generator::Driver::SQLite|
DBICx::Modeler::Generator::Driver::SQLite>
for common usage.

=head3 C<< /DBICx/Modeler/Generator/Model >>

It is an instance of an implement class which complies with the
L<DBICx::Modeler::Generator::ModelLike|DBICx::Modeler::Generator::ModelLike>
interface.

This distribution contains the implement class which named
L<DBICx::Modeler::Generator::Model|DBICx::Modeler::Generator::Model>
for common usage.

=head3 C<< /DBICx/Modeler/Generator/Path >>

It is an instance of an implement class which complies with the
L<DBICx::Modeler::Generator::PathLike|DBICx::Modeler::Generator::PathLike>
interface.

This distribution contains the implement class which named
L<DBICx::Modeler::Generator::Path|DBICx::Modeler::Generator::Path>
for common usage.

=head3 C<< /DBICx/Modeler/Generator/Path/root >>

It is a directory path of the application root.

=over 4

=item Type

L<Path::Class::Dir|Path::Class::Dir>
(can be coerce with L<MooseX::Types::Path::Class|MooseX::Types::Path::Class>)

=item Example

F<< /path/to/root >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema >>

It is an instance of an implement class which complies with the
L<DBICx::Modeler::Generator::SchemaLike|DBICx::Modeler::Generator::SchemaLike>
interface.

This distribution contains the implement class which named
L<DBICx::Modeler::Generator::Schema|DBICx::Modeler::Generator::Schema>
for common usage.

=head3 C<< /DBICx/Modeler/Generator/Tree >>

It is an instance of an implement class which complies with the
L<DBICx::Modeler::Generator::TreeLike|DBICx::Modeler::Generator::TreeLike>
interface.

This distribution contains the implement class which named
L<DBICx::Modeler::Generator::Tree|DBICx::Modeler::Generator::Tree>
for common usage.

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

=head3 C<< /DBICx/Modeler/Generator/Driver/bin >>

=over 4

=item Type

C<< Str >>

=item Default

C<< mysql >>
(in case of that the implement driver class is
L<DBICx::Modeler::Generator::Driver::MySQL|
DBICx::Modeler|DBICx::ModelerDBICx::Modeler::Generator::Driver::MySQL>),
C<< sqlite3 >>
(in case of that the implement driver class is
L<DBICx::Modeler::Generator::Driver::SQLite|
DBICx::Modeler::Generator::Driver::SQLite>),
etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/database >>

=over 4

=item Type

C<< Str >>

=item Default

C<< $application >>, C<< /$root/$application.$database_extension >>, etc.

=item Example

C<< myapp >>, C<< my_app >>, F<< /path/to/root/my_app.db >>, etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/dbd >>

=over 4

=item Type

C<< Str >>

=item Default

C<< mysql >>
(in case of that the implement driver class is
L<DBICx::Modeler::Generator::Driver::MySQL|
DBICx::Modeler::Generator::Driver::MySQL>),
C<< SQLite >>
(in case of that the implement driver class is
L<DBICx::Modeler::Generator::Driver::SQLite|
DBICx::Modeler::Generator::Driver::SQLite>),
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

F<< .db >>
(in case of that the implement driver class is
L<DBICx::Modeler::Generator::Driver::SQLite|
DBICx::Modeler::Generator::Driver::SQLite>),
etc.

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/host >>

=over 4

=item Type

C<< Str >>

=item Default

C<< undef >> (it means C<< localhost >> on general drivers)

=back

=head3 C<< /DBICx/Modeler/Generator/Driver/password >>

=over 4

=item Type

C<< Str >>

=item Default

C<< undef >>

=item Example

C<< foobar >>

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

=item Example

C<< mysql_user >>

=back

=head3 C<< /DBICx/Modeler/Generator/Path/creation_script >>

=over 4

=item Type

L<Path::Class::File|Path::Class::File>
(can be coerce with L<MooseX::Types::Path::Class|MooseX::Types::Path::Class>)

=item Default

C<< /$root/$source/$application.$script_extension >>

=item Example

F<< /path/to/root/src/myapp.sql >>

=back

=head3 C<< /DBICx/Modeler/Generator/Path/module_extension >>

=over 4

=item Type

C<< Str >>

=item Default

F<< .pm >>

=back

=head3 C<< /DBICx/Modeler/Generator/Path/script_extension >>

=over 4

=item Type

C<< Str >>

=item Default

F<< .sql >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema/components >>

=over 4

=item Type

C<< ArrayRef[Str] >>

=item Default

C<< [] >>

(cf. I<Don't use DBIx::Class::UTF8Columns>,
L<http://perl-users.jp/articles/advent-calendar/2009/hacker/04.html>)

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

C<< myapp >> (in calse of that the application class name is C<< MyApp >>),
C<< my_app >> (in calse of that the application class name is C<< My::App >>),
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

This distribution includes whole file which related
L<workflow|/How to model in your application - typical workflow> above.

Run the following command at root directory of this distribution:

    perl -Ilib examples/src/sbin/maintain_models.pl \
         -a MyApp -r examples -d SQLite

or

    perl -Ilib examples/src/sbin/maintain_models.pl            \
         -a MyApp -r examples -d MySQL -u username -w password \
         -l /Path/script_extension=_mysql.sql

or

    perl -Ilib examples/src/sbin/maintain_models.pl \
         --configfile examples/src/myapp.yml

=head1 SEE ALSO

=over 4

=item *

L<DBICx::Modeler|DBICx::Modeler>

=item *

L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader>

=item *

L<DBIx::Class|DBIx::Class>

=item *

Homepage of I<MySQL Workbench> application,
L<http://www.mysql.com/products/workbench/>

=item *

Japanese edition of homepage of I<MySQL Workbench> application,
L<http://www-jp.mysql.com/products/workbench/>

=item *

Martin Fowler,
I<Patterns of Enterprise Application Architecture>,
Toronto: Addison-Wesley Professional,
2002,
560p.,
ISBN 0321127420 / 978-0321127426

(a.k.a. PoEAA, PofEAA)

=item *

I<How to separate schemata and models of an enterprise application>,
L<http://blog.eorzea.asia/2009/10/post_76.html>
(written in Japanese)

=back

=head1 TO DO

=over 4

=item *

More tests

=item *

Using L<Test::mysqld|Test::mysqld> for tests
(cf. L<http://mt.endeworks.jp/d-6/2009/10/things-ive-done-while-using-test-mysqld.html>
by Daisuke Maki, alias lestrrat

=back

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head2 Making suggestions and reporting bugs

Please report any found bugs, feature requests, and ideas for improvements
to C<bug-dbicx-modeler-generator at rt.cpan.org>,
or through the web interface
at L<http://rt.cpan.org/Public/Bug/Report.html?Queue=DBICx-Modeler-Generator>.
I will be notified, and then you'll automatically be notified of progress
on your bugs/requests as I make changes.

When reporting bugs, if possible,
please add as small a sample as you can make of the code
that produces the bug.
And of course, suggestions and patches are welcome.

=head1 SUPPORT

You can find documentation for this module with the C<perldoc> command.

    perldoc DBICx::Modeler::Generator

You can also find the Japanese edition of documentation for this module
with the C<perldocjp> command from L<Pod::PerldocJp|Pod::PerldocJp>.

    perldocjp DBICx::Modeler::Generator.ja

You can also look for information at:

=over 4

=item RT: CPAN's request tracker

L<http://rt.cpan.org/Public/Dist/Display.html?Name=DBICx-Modeler-Generator>

=item AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DBICx-Modeler-Generator>

=item Search CPAN

L<http://search.cpan.org/dist/DBICx-Modeler-Generator>

=item CPAN Ratings

L<http://cpanratings.perl.org/dist/DBICx-Modeler-Generator>

=back

=head1 VERSION CONTROL

This module is maintained using I<git>.
You can get the latest version from
L<git://github.com/gardejo/p5-dbicx-modeler-generator.git>.

=head1 CODE COVERAGE

I use L<Devel::Cover|Devel::Cover> to test the code coverage of my tests,
below is the C<Devel::Cover> summary report on this distribution's test suite.

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

=item MORIYA Masaki, alias Gardejo

C<< <moriya at cpan dot org> >>,
L<http://gardejo.org/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009-2010 MORIYA Masaki, alias Gardejo

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
