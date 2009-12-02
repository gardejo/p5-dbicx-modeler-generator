package Test::DBICx::Modeler::Generator::MySQL;


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

use Path::Class;
use Test::More;
use Test::Requires {
    'DBI'          => 0,
    'DBD::mysql'   => 0,
    # 'Test::mysqld' => 0,
};


# ****************************************************************
# test(s)
# ****************************************************************

sub _get_driver_class {
    return 'DBICx::Modeler::Generator::Driver::MySQL';
}

sub _has_authority {
    return 1;
}

sub _get_special_literals {
    return (
        '/Driver/host'           => 'localhost',
        '/Driver/password'       => 'foobar',
        '/Driver/port'           => 3306,
        '/Driver/username'       => 'mysql_user',
        '/Path/script_extension' => '_mysql.sql',
    );
}

sub _connect_database {
    my $self = shift;

    # fixme: use Test::mysqld
    # or
    # fixme: store the running status of mysql daemon
    # fixme: run mysql daemon

    $self->{dbh} = DBI->connect(
        'dbi:mysql:host=localhost;port=3306',
        'mysql_user',
        'foobar',
    );

    plan skip_all => "could not connect to the MySQL database"
        unless $self->{dbh};
    plan skip_all => "'myapp' database already exists"
        if $self->_exists_database;

    return;
}

sub _test_path_of_creation_script {
    my ($self, $path, $source_library) = @_;

    is $path->module_extension,
        '.pm'
            => 'path: module_extension ok';
    is $path->script_extension,
        '_mysql.sql'
            => 'path: script_extension ok';
    is $path->creation_script->stringify,
        $source_library->parent->file('myapp_mysql.sql')->stringify
            => 'path: creation_script ok';

    return;
}

sub test_driver : Tests(no_plan) {
    my $self = shift;

    my $driver = $self->{generator}->driver;
    isa_ok $driver, 'DBICx::Modeler::Generator::Driver::MySQL';
    ok $driver->meta->does_role('DBICx::Modeler::Generator::DriverLike');

    is $driver->bin, 'mysql'
        => 'driver: bin ok';
    is $driver->dbd, 'mysql'
        => 'driver: dbd ok';
    is $driver->dsn,
        "dbi:mysql:dbname=myapp;host=localhost;port=3306"
            => 'driver: dsn ok';
    is $driver->host, 'localhost'
        => 'driver: host ok';
    is $driver->username, 'mysql_user'
        => 'driver: username ok';
    is $driver->password, 'foobar'
        => 'driver: password ok';
    is $driver->port, 3306
        => 'driver: port ok';
    my $script = file('examples/src/myapp_mysql.sql')->stringify;
    is $driver->command,
        qq{mysql --user=mysql_user --password=foobar < "$script"}
            => 'driver: command ok';

    return;
}

sub _exists_database {
    my $self = shift;

    # fixme: this validation
    return $self->{dbh}->do(q{SHOW DATABASES LIKE 'myapp'}) eq 1;
}

sub _remove_generated_database {
    my $self = shift;

    $self->{dbh}->do(q{DROP DATABASE IF EXISTS myapp});

    return;
}

sub _disconnect_database {
    my $self = shift;

    # fixme: shutdown mysql daemon if it was ran at connect_database()

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

Test::DBICx::Modeler::Generator::MySQL - Tests for DBICx::Modeler::Generator::Driver::MySQL

=head1 SYNOPSIS

    package Test::DBICx::Modeler::Generator::Manual::MySQL;

    use base qw(
        Test::DBICx::Modeler::Generator::Manual
        Test::DBICx::Modeler::Generator::MySQL
    );

=head1 DESCRIPTION

This class is a base class of C<Test::DBICx::Modeler::Generator::*::MySQL>.

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
