package DBICx::Modeler::Generator::PathLike;


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
    root                source_library      target_library
                        source_model        target_model
                        source_models       target_models
                        source_schema       target_schema
                        source_schemata     target_schemata
    creation_script
    module_extension    script_extension
    remove_path
    add_source_library
    get_full_path
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

DBICx::Modeler::Generator::PathLike - Path interface to DBICx::Modeler::Generator

=head1 SYNOPSIS

    use DBICx::Modeler::Generator::Path;

    use Moose;

    with qw(DBICx::Modeler::Generator::PathLike);

=head1 DESCRIPTION

This role is a path interface
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
