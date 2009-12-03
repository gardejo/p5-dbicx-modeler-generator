package Test::DBICx::Modeler::Generator::CLI::MySQL;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# base class(es)
# ****************************************************************

use base qw(
    Test::DBICx::Modeler::Generator::CLI
    Test::DBICx::Modeler::Generator::MySQL
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Test::More;


# ****************************************************************
# test(s)
# ****************************************************************

sub _argument_values_for_longname {
    my $self = shift;

    $self->_set_host_and_port('localhost', 3306);

    return (
        '--application', 'MyApp',
        '--root',        'examples',
        '--driver',      'MySQL',
        '--host',        $self->{host},
        '--port',        $self->{port},
        '--username',    'mysql_user',
        '--password',    'foobar',
        '--literal',     '/Path/script_extension=_mysql.sql',
    );
}

sub _argument_values_for_shortname {
    my $self = shift;

    $self->_set_host_and_port(undef, undef);    # to improve a variation

    return (
        '-a', 'MyApp',
        '-r', 'examples',
        '-d', 'MySQL',
        '-u', 'mysql_user',
        '-w', 'foobar',
        '-l', '/Path/script_extension=_mysql.sql',
    );
}

sub _argument_values_for_configfile {
    my $self = shift;

    $self->_set_host_and_port('localhost', 3306);

    return (
        '--configfile', 't/mysql.yml',
    );
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

Test::DBICx::Modeler::Generator::CLI::MySQL - Tests for DBICx::Modeler::Generator::Driver::MySQL with a command line interface

=head1 SYNOPSIS

    use Test::DBICx::Modeler::Generator::CLI::MySQL;

    Test::DBICx::Modeler::Generator::CLI::MySQL->runtests;

=head1 DESCRIPTION

This class tests that
using L<DBICx::Modeler::Generator::Driver::MySQL>
with a command line interface.

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
