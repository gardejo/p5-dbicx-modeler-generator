package DBICx::Modeler::Generator::Driver::MySQL::Test;


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

use Moose;
use MooseX::Orochi;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# base class(es)
# ****************************************************************

extends qw(
    DBICx::Modeler::Generator::Driver::MySQL
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_command {
    my $self = shift;

    return $self->bin . ' --unknown_option_foo_bar_42';
}


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    DBICx::Modeler::Generator::DriverLike
);


# ****************************************************************
# compile-time process(es)
# ****************************************************************

__PACKAGE__->meta->make_immutable;


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

DBICx::Modeler::Generator::Driver::MySQL::Test - Concrete implement class with MySQL for DBICx::Modeler::Generator::DriverLike

=head1 SYNOPSIS

    use DBICx::Modeler::Generator::Driver::MySQL::Test;

=head1 DESCRIPTION

This class is a concrete implement class with MySQL for
L<DBICx::Modeler::Generator::DriverLike|DBICx::Modeler::Generator::DriverLike>.

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
