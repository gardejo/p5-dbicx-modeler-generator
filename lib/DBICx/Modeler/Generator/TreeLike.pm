package DBICx::Modeler::Generator::TreeLike;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose::Role;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# interface(s)
# ****************************************************************

# Note: route_to_library, route_to_model, route_to_schema are internal methods
requires qw(
    application             source                  target
                            route_to_source         route_to_target
    library                 source_library          target_library
                            route_to_source_library route_to_target_library
    model                   source_model            target_model
                            route_to_source_model   route_to_target_model
    schema                  source_schema           target_schema
                            route_to_source_schema  route_to_target_schema
);


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

DBICx::Modeler::Generator::TreeLike - Tree interface to DBICx::Modeler::Generator

=head1 SYNOPSIS

    package DBICx::Modeler::Generator::Tree;

    use Moose;

    with qw(DBICx::Modeler::Generator::TreeLike);

=head1 DESCRIPTION

This role is a tree interface
to L<DBICx::Modeler::Generator|DBICx::Modeler::Generator>.

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
