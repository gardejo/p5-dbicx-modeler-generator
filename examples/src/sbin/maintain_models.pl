#! /usr/local/bin/perl


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use DBICx::Modeler::Generator::CLI;


# ****************************************************************
# main routine
# ****************************************************************

my $application = DBICx::Modeler::Generator::CLI->new_with_options;
$application->generator->make_database;
$application->generator->update_schemata;
$application->generator->update_models;


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

maintain_models - Maintainer of schema and model modules

=head1 SYNOPSIS

    $ perl -Ilib examples\src\sbin\maintain_models.pl   \\
           -a MyApp                                     \\
           -r examples                                  \\
           -d SQLite

    # or

    $ perl -Ilib examples\src\sbin\maintain_models.pl   \\
           --application=MyApp                          \\
           --root=examples                              \\
           --driver=SQLite

    # or

    $ perl -Ilib examples\src\sbin\maintain_models.pl   \\
           -a MyApp                                     \\
           -r examples                                  \\
           -d MySQL                                     \\
           -u mysql_user                                \\
           -w foobar                                    \\
           -l /Path/script_extension=_mysql.sql

    # or

    $ perl -Ilib examples\src\sbin\maintain_models.pl   \\
           --application=MyApp                          \\
           --root=examples                              \\
           --driver=MySQL                               \\
           --username=mysql_user                        \\
           --password=foobar                            \\
           --literal /Path/script_extension=_mysql.sql

    # or

    $ perl -Ilib examples\src\sbin\maintain_models.pl   \\
           --application=MyApp                          \\
           --root=examples                              \\
           --driver=MySQL                               \\
           --username=mysql_user                        \\
           --password=foobar                            \\
           --host=hostname                              \\
           --port=3306                                  \\
           --literal /Path/script_extension=_mysql.sql

    # Note: using default values...
    # literal => {
    #     '/Class/base_part'       => 'Base',
    #     '/Class/model_part'      => 'Model',
    #     '/Class/schema_part'     => 'Schema',
    #     '/Driver/bin'            => 'sqlite',
    #     '/Driver/dbd'            => 'SQLite',
    #     '/Driver/dbname'         => 'myapp',
    #     '/Driver/dsn'            => 'dbi:SQLite:dbname=examples/myapp.db',
    #     '/Driver/extension'      => '.db',
    #     '/Driver/host'           => 'localhost',
    #     '/Driver/port'           => 3306,
    #     '/Path/creation_script'  => 'examples/src/myapp_sqlite.sql',
    #     '/Path/module_extension' => '.pm',
    #     '/Schema/components'     => [qw(UTF8Columns)],
    #     '/Schema/is_debug'       => 1,
    #     '/Tree/application'      => 'myapp',
    #     '/Tree/library'          => [qw(lib)],
    #     '/Tree/src'              => [qw(src)],
    #     '/Tree/target'           => [qw()],
    # }

=head1 DESCRIPTION

This script provides a simple interface to L<DBICx::Modeler::Generator>.

=head2 Directory tree of the example

    example/
        myapp.db (... generating target)
        lib/
            MyApp/ (... generating target)
                Schema.pm
                Model/
                    *.pm
                Schema/
                    *.pm
        src/
            myapp.sql (... SQLite source)
            myapp_mysql.sql (... MySQL source)
            lib/
                MyApp/
                    Model/ (... model sources)
                        *.pm
                    Schema/ (... schema sources)
                        *.pm
            sbin/
                maintain_models.pl (... this script)

=head1 SEE ALSO

=over 4

=item *

L<MooseX::Getopt>

=item *

L<Getopt::Long>

=item *

L<DBICx::Modeler>

=item *

L<DBIx::Class::Schema::Loader>

=item *

L<DBICx::Modeler::Generator>

=item *

L<DBICx::Modeler::Generator::CLI>

=back

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
