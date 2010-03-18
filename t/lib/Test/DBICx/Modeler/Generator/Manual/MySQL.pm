package Test::DBICx::Modeler::Generator::Manual::MySQL;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# base class(es)
# ****************************************************************

use base qw(
    Test::DBICx::Modeler::Generator::Manual
    Test::DBICx::Modeler::Generator::MySQL
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Test::More;


# ****************************************************************
# test(s)
# ****************************************************************



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

Test::DBICx::Modeler::Generator::Manual::MySQL - Tests for manually using DBICx::Modeler::Generator::Driver::MySQL

=head1 SYNOPSIS

    use Test::DBICx::Modeler::Generator::Manual::MySQL;

    Test::DBICx::Modeler::Generator::Manual::MySQL->runtests;

=head1 DESCRIPTION

This class tests that manually using
L<DBICx::Modeler::Generator::Driver::MySQL|
DBICx::Modeler::Generator::Driver::MySQL>.

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
