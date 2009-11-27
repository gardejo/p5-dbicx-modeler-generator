#! /usr/local/bin/perl


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use FindBin;
use Orochi;
use Readonly;


# ****************************************************************
# package grobal constant(s)
# ****************************************************************

Readonly my $Base_Registory => '/DBICx/Modeler/Generator';
Readonly my %Literal => (
    '/Class/application'        => 'MyApp',
    '/Driver/password'          => 'foobar',
    '/Driver/username'          => 'mysql_user',
    '/Path/root'                => $FindBin::Bin . '/../../',
    '/Path/script_extension'    => '_mysql.sql',
    # using default values...
    # '/Class/base_part'          => 'Base',
    # '/Class/model_part'         => 'Model',
    # '/Class/schema_part'        => 'Schema',
    # '/Driver/bin'               => 'mysql',
    # '/Driver/dbd'               => 'mysql',
    # '/Driver/dbname'            => 'myapp',
    # '/Driver/dsn'               => 'dbi:mysql:dbname=myapp;host=localhost',
    # '/Driver/host'              => 'localhost',
    # '/Driver/port'              => undef, # (3306)
    # '/Path/creation_script'     => $FindBin::Bin . '/../' . 'myapp.sql',
    # '/Path/module_extension'    => '.pm',
    # '/Schema/components'        => [qw(UTF8Columns)],
    # '/Schema/is_debug'          => 1,
    # '/Tree/application'         => 'myapp',
    # '/Tree/library'             => [qw(lib)],
    # '/Tree/source'              => [qw(src)],
    # '/Tree/target'              => [qw()],
);

Readonly my @Classes => qw(
    DBICx::Modeler::Generator
    DBICx::Modeler::Generator::Class
    DBICx::Modeler::Generator::Driver::MySQL
    DBICx::Modeler::Generator::Model
    DBICx::Modeler::Generator::Path
    DBICx::Modeler::Generator::Schema
    DBICx::Modeler::Generator::Tree
);


# ****************************************************************
# mainroutine
# ****************************************************************

_update();


# ****************************************************************
# subroutine(s)
# ****************************************************************

sub _update {
    my $container = Orochi->new;

    _initialize($container);

    my $generator = $container->get('/DBICx/Modeler/Generator');

    $generator->make_database;
    $generator->update_schemata;
    $generator->update_models;

    return;
}

sub _initialize {
    my $container = shift;

    while (my ($registory, $literal) = each %Literal) {
        $container->inject_literal($Base_Registory . $registory => $literal);
    }

    foreach my $class (@Classes) {
        $container->inject_class($class);
    }
    # $container->inject_namespace('DBICx::Modeler::Generator');

    return;
}


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

maintain_models_mysql - Maintainer of schema and model modules with MySQL

=head1 SYNOPSIS

    $ perl src\sbin\maintain_models.pl

=head1 DESCRIPTION

blah blah blah

    path/
        to/
            base/
                lib/
                    MyApp/
                        Model/
                            *.pm
                        Schema/
                            *.pm
                src/
                    myapp.sql
                    lib/
                        MyApp/
                            Model/
                                *.pm
                            Schema/
                                *.pm
                    sbin/
                        maintain_models_mysql.pl

=head1 TO DO

=over 4

=item *

L<MooseX::GetOpt>

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
