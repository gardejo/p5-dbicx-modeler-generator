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

my $generator = DBICx::Modeler::Generator::CLI->new_with_options->generator;
$generator->deploy_database;
$generator->update_schemata;
$generator->update_models;


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

    $ perl -Ilib examples/src/sbin/maintain_models.pl   \
           -a MyApp                                     \
           -r examples                                  \
           -d SQLite

    # or

    $ perl -Ilib examples/src/sbin/maintain_models.pl   \
           --application=MyApp                          \
           --root=examples                              \
           --driver=SQLite

    # or

    $ perl -Ilib examples/src/sbin/maintain_models.pl   \
           -a MyApp                                     \
           -r examples                                  \
           -d MySQL                                     \
           -u mysql_user                                \
           -w foobar                                    \
           -l /Path/script_extension=_mysql.sql

    # or

    $ perl -Ilib examples/src/sbin/maintain_models.pl   \
           --application=MyApp                          \
           --root=examples                              \
           --driver=MySQL                               \
           --username=mysql_user                        \
           --password=foobar                            \
           --host=hostname                              \
           --port=3306                                  \
           --literal /Path/script_extension=_mysql.sql

    # or

    $ perl -Ilib examples/src/sbin/maintain_models.pl   \
           --configfile=examples/src/myapp.yml

=head1 DESCRIPTION

This script provides a simple interface to L<DBICx::Modeler::Generator>.

=head2 Directory tree of the example

    example/
        myapp.db                    (... generating target)
        lib/
            MyApp/                  (... generating target)
                Schema.pm
                Model/
                    *.pm
                Schema/
                    *.pm
        src/
            myapp.yml               (... configuration file)
            myapp.sql               (... SQLite source)
            myapp_mysql.sql         (... MySQL source)
            lib/
                MyApp/
                    Model/          (... model sources)
                        *.pm
                    Schema/         (... schema sources)
                        *.pm
            sbin/
                maintain_models.pl  (... this script)

=head1 SEE ALSO

=over 4

=item *

L<MooseX::Getopt>

=item *

L<Getopt::Long>

=item *

L<MooseX::SimpleConfig>

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

=item MORIYA Masaki, alias Gardejo

C<< <moriya at cpan dot org> >>,
L<http://gardejo.org/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009-2010 MORIYA Masaki, alias Gardejo

This script is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
