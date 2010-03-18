package DBICx::Modeler::Generator::Driver::SQLite;


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
        bin       => bind_value '/DBICx/Modeler/Generator/Driver/bin',
        database  => bind_value '/DBICx/Modeler/Generator/Driver/database',
        dbd       => bind_value '/DBICx/Modeler/Generator/Driver/dbd',
        dsn       => bind_value '/DBICx/Modeler/Generator/Driver/dsn',
        extension => bind_value '/DBICx/Modeler/Generator/Driver/extension',
        path      => bind_value '/DBICx/Modeler/Generator/Path',
        tree      => bind_value '/DBICx/Modeler/Generator/Tree',
    },
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'extension' => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @args) = @_;

    my $args = $class->$next(@args);

    foreach my $attribute (qw(
        extension
    )) {
        delete $args->{$attribute}
            unless defined $args->{$attribute};
    }

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_bin {
    return 'sqlite3';
}

sub _build_dbd {
    return 'SQLite';
}

sub _build_extension {
    return '.db';
}

around _build_database => sub {
    my ($next, $self) = @_;

    return $self->path->get_full_path(
        $self->tree->route_to_target,
        $self->$next,
        $self->extension,
    )->stringify;
};

override _build_dsn => sub {
    my $self = shift;

    my $dsn = sprintf 'dbi:%s:dbname=%s', (
        $self->dbd,
        $self->database,
    );

    return $dsn;
};

sub _build_command {
    my $self = shift;

    my $command = $self->bin;
    $command .= sprintf ' "%s"', $self->database;
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

DBICx::Modeler::Generator::Driver::SQLite - Concrete implement class with SQLite for DBICx::Modeler::Generator::DriverLike

=head1 SYNOPSIS

    use DBICx::Modeler::Generator::Driver::SQLite;

=head1 DESCRIPTION

This class is a concrete implement class with SQLite for
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
