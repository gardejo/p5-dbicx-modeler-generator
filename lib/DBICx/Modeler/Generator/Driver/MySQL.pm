package DBICx::Modeler::Generator::Driver::MySQL;


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
    DBICx::Modeler::Generator::Driver::Base
);


# ****************************************************************
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator/Driver' => (
    args => {
        bin      => bind_value '/DBICx/Modeler/Generator/Driver/bin',
        database => bind_value '/DBICx/Modeler/Generator/Driver/database',
        dbd      => bind_value '/DBICx/Modeler/Generator/Driver/dbd',
        dsn      => bind_value '/DBICx/Modeler/Generator/Driver/dsn',
        host     => bind_value '/DBICx/Modeler/Generator/Driver/host',
        password => bind_value '/DBICx/Modeler/Generator/Driver/password',
        port     => bind_value '/DBICx/Modeler/Generator/Driver/port',
        username => bind_value '/DBICx/Modeler/Generator/Driver/username',
        path     => bind_value '/DBICx/Modeler/Generator/Path',
        tree     => bind_value '/DBICx/Modeler/Generator/Tree',
    },
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_bin {
    return 'mysql';
}

sub _build_dbd {
    return 'mysql';
}

sub _build_command {
    my $self = shift;

    my $command = $self->bin;
    $command .= sprintf ' --user=%s', $self->username
        if defined $self->username;
    $command .= sprintf ' --password=%s', $self->password
        if defined $self->password;
    $command .= sprintf ' < "%s"', $self->path->creation_script->stringify;

    return $command;
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

DBICx::Modeler::Generator::Driver::MySQL - Concrete implement class with MySQL for DBICx::Modeler::Generator::DriverLike

=head1 SYNOPSIS

    use DBICx::Modeler::Generator::Driver::MySQL;

=head1 DESCRIPTION

This class is a concrete implement class with MySQL for
L<DBICx::Modeler::Generator::DriverLike|DBICx::Modeler::Generator::DriverLike>.

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
