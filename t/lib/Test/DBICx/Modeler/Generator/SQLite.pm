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
use Test::Moose;
use Test::More;
use Test::Requires {
    'DBD::SQLite' => 0,
};


# ****************************************************************
# class variable(s)
# ****************************************************************

our $With_Foreign_Key = 1;


# ****************************************************************
# accessor(s) of class variable(s)
# ****************************************************************

sub with_foreign_key {
    $With_Foreign_Key = $_[1]
        if scalar @_ == 2;

    return $With_Foreign_Key;
}


# ****************************************************************
# test(s)
# ****************************************************************

sub _has_means {
    ! system('sqlite3 --version');
}

sub _get_driver_class {
    return 'DBICx::Modeler::Generator::Driver::SQLite';
}

sub _get_special_literals {
    my $self = shift;

    $self->_set_script_extension;

    return $self->_can_support_foreign_keys ? (
        '/Path/script_extension' => $self->{script_extension},
    ) : ();
}

sub _set_script_extension {
    my $self = shift;

    $self->{script_extension}
        = $self->_can_support_foreign_keys ? '_sqlite_with_fk.sql'
        :                                    '.sql';

    return;
}

sub _connect_database {
    my $self = shift;

    $self->{db_file} = $self->{examples}->file('myapp.db')->relative;
    $self->{connect_info} = [
        'dbi:SQLite:dbname=' . $self->{db_file}->stringify,
        undef,
        undef,
        {
            PrintWarn  => 0,
            PrintError => 0,
        }
    ];
    my $dbh = DBI->connect(@{ $self->{connect_info} });
    if (defined $dbh) {
        if ($self->_can_support_foreign_keys) {
            $dbh->do('PRAGMA foreign_keys = ON')
                or $self->BAILOUT($dbh->errstr);
        }
        $self->{dbh} = $dbh;
    }

    return;
}

sub _test_path_of_creation_script {
    my ($self, $path, $source_library) = @_;

    is $path->module_extension,
        '.pm'
            => 'path: module_extension ok';
    is $path->script_extension,
        $self->{script_extension}
            => 'path: script_extension ok';
    is $path->creation_script->stringify,
        $source_library->parent->file(
            'myapp' . $self->{script_extension}
        )->stringify
            => 'path: creation_script ok';

    return;
}

sub test_driver : Tests(no_plan) {
    my $self = shift;

    my $driver = $self->{generator}->driver;
    isa_ok $driver, 'DBICx::Modeler::Generator::Driver::SQLite';
    does_ok $driver, 'DBICx::Modeler::Generator::DriverLike';

    is $driver->bin, 'sqlite3'
        => 'driver: bin ok';
    my $database = $self->{db_file}->stringify;
    is file($driver->database)->stringify,
        $database
            => 'driver: database ok';
    is $driver->dbd, 'SQLite'
        => 'driver: dbd ok';
    is $driver->dsn,
        "dbi:SQLite:dbname=$database"
            => 'driver: dsn ok';
    is $driver->extension, '.db'
        => 'driver: extension ok';
    is_deeply [$driver->host], [undef]
        => 'driver: host ok';
    is_deeply [$driver->username], [undef]
        => 'driver: username ok';
    is_deeply [$driver->password], [undef]
        => 'driver: password ok';
    is_deeply [$driver->port], [undef]
        => 'driver: port ok';
    my $script = file(
        'examples/src/myapp' . $self->{script_extension}
    )->stringify;
    is $driver->command,
        qq{sqlite3 "$database" < "$script"}
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

    foreach my $table (qw(track cd artist)) {
        $self->{dbh}->do(sprintf 'DROP TABLE IF EXISTS %s', $table)
            or $self->BAILOUT($self->{dbh}->errstr);
    }

    return;
}

sub _disconnect_database {
    my $self = shift;

    $self->{dbh}->disconnect
        or $self->BAILOUT($self->{dbh}->errstr);
    delete $self->{dbh};

    return;
}

sub _reconnect_database {
    my $self = shift;

    $self->_disconnect_database;
    $self->_connect_database;

    return;
}

sub _can_support_foreign_keys {
    my $self = shift;

    return $self->with_foreign_key
        && DBD::SQLite->VERSION >= 1.26_06;
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

=item MORIYA Masaki (a.k.a. Gardejo)

C<< <moriya at ermitejo dot com> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by MORIYA Masaki (a.k.a. Gardejo),
L<http://ttt.ermitejo.com>.

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
