package Test::DBICx::Modeler::Generator::CLI::SQLite;


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
    Test::DBICx::Modeler::Generator::SQLite
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Test::More;


# ****************************************************************
# test(s)
# ****************************************************************

sub _argument_values_for_longname {
    return (
        '--application', 'MyApp',
        '--root',        'examples',
        '--driver',      'SQLite',
    );
}

sub _argument_values_for_shortname {
    return (
        '-a', 'MyApp',
        '-r', 'examples',
        '-d', 'SQLite',
    );
}

sub _argument_values_for_configfile {
    return (
        '--configfile', 't/sqlite.yml',
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

Test::DBICx::Modeler::Generator::CLI::SQLite - Tests for DBICx::Modeler::Generator::Driver::SQLite with a command line interface

=head1 SYNOPSIS

    use Test::DBICx::Modeler::Generator::CLI::SQLite;

    Test::DBICx::Modeler::Generator::CLI::SQLite->runtests;

=head1 DESCRIPTION

This class tests that
using L<DBICx::Modeler::Generator::Driver::SQLite>
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
