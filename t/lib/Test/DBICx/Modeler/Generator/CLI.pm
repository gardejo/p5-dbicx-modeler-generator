package Test::DBICx::Modeler::Generator::CLI;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Test::Requires {
    'MooseX::Getopt'       => 0,
    'MooseX::SimpleConfig' => 0,
};


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use DBICx::Modeler::Generator::CLI;


# ****************************************************************
# class variable(s)
# ****************************************************************

our $Interface;


# ****************************************************************
# accessor(s) of class variable(s)
# ****************************************************************

sub interface {
    $Interface = $_[1]
        if scalar @_ == 2;

    return $Interface;
}


# ****************************************************************
# test(s)
# ****************************************************************

sub _get_generator {
    my $self = shift;

    local @ARGV = $self->_get_argument_values;
    my $application = DBICx::Modeler::Generator::CLI->new_with_options;

    $self->{container} = $application->container;
    $self->{generator} = $application->generator;

    return;
}

sub _get_argument_values {
    my $self = shift;

    my $interface = $self->interface;

    return   $interface eq 'longname'   ? $self->_argument_values_for_longname
           : $interface eq 'shortname'  ? $self->_argument_values_for_shortname
           : $interface eq 'configfile' ? $self->_argument_values_for_configfile
           :                              ();
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

Test::DBICx::Modeler::Generator::CLI - Tests for using DBICx::Modeler::Generator with a command line interface

=head1 SYNOPSIS

    package Test::DBICx::Modeler::Generator::CLI::SQLite;

    use base qw(
        Test::DBICx::Modeler::Generator::CLI
        Test::DBICx::Modeler::Generator::SQLite
    );

=head1 DESCRIPTION

This class is a base class of C<Test::DBICx::Modeler::Generator::CLI::*>.

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
