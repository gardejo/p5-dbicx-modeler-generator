package Test::DBICx::Modeler::Generator::SQLite;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# base class(es)
# ****************************************************************

use base qw(
    Test::DBICx::Modeler::Generator
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use DBI;
use List::MoreUtils qw(all apply uniq);
use Path::Class;
use Test::More;
use Test::Requires {
    'DBD::SQLite' => 0,
};


# ****************************************************************
# test(s)
# ****************************************************************

sub _get_driver_class {
    return 'DBICx::Modeler::Generator::Driver::SQLite';
}

sub _get_special_literals {
    return (
        # '/Path/script_extension' => '.sql',
    );
}

sub _connect_database {
    my $self = shift;

    $self->{db_file} = $self->{examples}->file('myapp.db')->relative;
    my $dbh = DBI->connect(
        'dbi:SQLite:dbname=' . $self->{db_file}->stringify,
        undef,
        undef,
        {
            PrintError => 0,
        }
    );
    $self->{dbh} = $dbh
        if defined $dbh;

    return;
}

sub _test_path_of_creation_script {
    my ($self, $path, $source_library) = @_;

    is $path->module_extension,
        '.pm'
            => 'path: module_extension ok';
    is $path->script_extension,
        '.sql'
            => 'path: script_extension ok';
    is $path->creation_script->stringify,
        $source_library->parent->file('myapp.sql')->stringify
            => 'path: creation_script ok';

    return;
}

sub test_driver : Tests(no_plan) {
    my $self = shift;

    my $driver = $self->{generator}->driver;
    isa_ok $driver, 'DBICx::Modeler::Generator::Driver::SQLite';
    ok $driver->meta->does_role('DBICx::Modeler::Generator::DriverLike');

    is $driver->extension, '.db'
        => 'driver: extension ok';
    is $driver->bin, 'sqlite3'
        => 'driver: bin ok';
    is $driver->dbd, 'SQLite'
        => 'driver: dbd ok';
    my $dbname = $self->{db_file}->stringify;
    is file($driver->dbname)->stringify,
        $dbname
            => 'driver: dbname ok';
    is $driver->dsn,
        "dbi:SQLite:dbname=$dbname;host=localhost"
            => 'driver: dsn ok';
    is $driver->host, 'localhost'
        => 'driver: host ok';
    is_deeply [$driver->username], [undef]
        => 'driver: username ok';
    is_deeply [$driver->password], [undef]
        => 'driver: password ok';
    is_deeply [$driver->port], [undef]
        => 'driver: port ok';
    my $script = file('examples/src/myapp.sql')->stringify;
    is $driver->command,
        qq{sqlite3 "$dbname" < "$script"}
            => 'driver: command ok';

    return;
}

sub _exists_database {
    my $self = shift;

    my %table;
    @table{
        apply {
            s{
                \A
                "main" \.
                "(.+?)"
                \z
            }{$1}xms;
        } uniq (
            $self->{dbh}->tables(undef, 'main')
        )
    } = ();

    return all {
        exists $table{$_};
    } qw(artist cd track);
}

sub _remove_generated_database {
    my $self = shift;

    foreach my $table (qw(artist cd track)) {
        $self->{dbh}->do(sprintf 'DROP TABLE IF EXISTS %s', $table)
            or die $self->{dbh}->errstr;
    }

    return;
}

sub _disconnect_database {
    my $self = shift;

    $self->{dbh}->disconnect
        or warn $self->{dbh}->errstr;
    delete $self->{dbh};

    return;
}

sub _clean_up_database {
    my $self = shift;

    # fixme: could not access to the file because an other process uses it
    # $self->{db_file}->remove
    #     or die $!;
    $self->{db_file}->remove;

    return;
}


# ****************************************************************
# return trule
# ****************************************************************

1;
__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

Test::DBICx::Modeler::Generator::SQLite - Tests for DBICx::Modeler::Generator::Driver::SQLite

=head1 SYNOPSIS

    package Test::DBICx::Modeler::Generator::Manual::SQLite;

    use base qw(
        Test::DBICx::Modeler::Generator::Manual
        Test::DBICx::Modeler::Generator::SQLite
    );

=head1 DESCRIPTION

This class is a base class of C<Test::DBICx::Modeler::Generator::*::SQLite>.

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
