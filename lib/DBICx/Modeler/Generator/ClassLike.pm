package DBICx::Modeler::Generator::ClassLike;


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

requires qw(
    application
    base_part   model_part      schema_part
                model           schema
                route_to_model  route_to_schema
    reload_class
    get_class_name_from_path_string
    get_fully_qualified_class_name
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

DBICx::Modeler::Generator::ClassLike - Class interface to DBICx::Modeler::Generator

=head1 SYNOPSIS

    package DBICx::Modeler::Generator::Class;

    use Moose;

    with qw(DBICx::Modeler::Generator::ClassLike);

=head1 DESCRIPTION

This role is a class interface
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
