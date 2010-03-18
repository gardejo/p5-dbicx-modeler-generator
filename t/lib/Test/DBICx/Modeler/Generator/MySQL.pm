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

use DBI;
use Path::Class;
use Test::Moose;
use Test::More;
use Test::Requires {
    'DBD::mysql'   => 0,
    # 'Test::mysqld' => 0,
};


# ****************************************************************
# test(s)
# ****************************************************************

sub _has_means {
    ! system('mysql --version');
}

sub _get_driver_class {
    return 'DBICx::Modeler::Generator::Driver::MySQL';
}

sub _get_special_literals {
    my $self = shift;

    $self->_set_host_and_port('localhost', 3306);

    return (
        '/Driver/host'           => $self->{host},
        '/Driver/password'       => 'foobar',
        '/Driver/port'           => $self->{port},
        '/Driver/username'       => 'mysql_user',
        '/Path/script_extension' => '_mysql.sql',
    );
}

sub _set_host_and_port {
    my ($self, $host, $port) = @_;

    $self->{host} = $host;
    $self->{port} = $port;

    return;
}

sub _connect_database {
    my ($self, $database) = @_;

    # fixme: use Test::mysqld
    # or
    # fixme: store the running status of mysql daemon and run mysql daemon
    my $dsn = 'dbi:mysql:';
    $dsn .= 'database=myapp'
        if defined $database;
    $self->{connect_info} = [
        $dsn,
        'mysql_user',
        'foobar',
        {
            PrintWarn  => 0,
            PrintError => 0,
        },
    ];
    my $dbh = DBI->connect(@{ $self->{connect_info} });
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
    does_ok $driver, 'DBICx::Modeler::Generator::DriverLike';

    is $driver->bin, 'mysql'
        => 'driver: bin ok';
    is $driver->database, 'myapp'
        => 'driver: database ok';
    is $driver->dbd, 'mysql'
        => 'driver: dbd ok';
    my $dsn = 'dbi:mysql:database=myapp';
    $dsn .= ';host=' . $self->{host}
        if defined $self->{host};
    $dsn .= ';port=' . $self->{port}
        if defined $self->{port};
    is $driver->dsn, $dsn
        => 'driver: dsn ok';
    is_deeply [$driver->host], [$self->{host}]
        => 'driver: host ok';
    is $driver->username, 'mysql_user'
        => 'driver: username ok';
    is $driver->password, 'foobar'
        => 'driver: password ok';
    is_deeply [$driver->port], [$self->{port}]
        => 'driver: port ok';
    my $script = file('examples/src/myapp_mysql.sql')->stringify;
    is $driver->command,
        qq{mysql --user=mysql_user --password=foobar < "$script"}
            => 'driver: command ok';

    return;
}

sub _exists_database {
    my $self = shift;

    return scalar $self->{dbh}->tables(undef, 'myapp');
}

sub _remove_generated_database {
    my $self = shift;

    $self->{dbh}->do(q{DROP DATABASE IF EXISTS myapp})
        or $self->BAILOUT($self->{dbh}->errstr);

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
    $self->_connect_database('myapp');

    return;
}

sub _can_support_foreign_keys {
    return 1;
}

sub _clean_up_database {
    my $self = shift;

    # fixme: shutdown mysql daemon if it was ran at connect_database()

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

Test::DBICx::Modeler::Generator::MySQL - Tests for DBICx::Modeler::Generator::Driver::MySQL

=head1 SYNOPSIS

    package Test::DBICx::Modeler::Generator::Manual::MySQL;

    use base qw(
        Test::DBICx::Modeler::Generator::Manual
        Test::DBICx::Modeler::Generator::MySQL
    );

=head1 DESCRIPTION

This class is a base class of C<Test::DBICx::Modeler::Generator::*::MySQL>.

=head1 USER ACCOUNT

This test suite hard-codes the user account to connect MySQL daemon below:

    GRANT
        SELECT,INSERT,UPDATE,DELETE,DROP,CREATE,INDEX
        ON myapp.*
        TO 'mysql_user'@'localhost' IDENTIFIED BY 'foobar';

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
