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
        path      => bind_value '/DBICx/Modeler/Generator/Path',
        tree      => bind_value '/DBICx/Modeler/Generator/Tree',
        bin       => bind_value '/DBICx/Modeler/Generator/Driver/bin',
        dbd       => bind_value '/DBICx/Modeler/Generator/Driver/dbd',
        dbname    => bind_value '/DBICx/Modeler/Generator/Driver/dbname',
        dsn       => bind_value '/DBICx/Modeler/Generator/Driver/dsn',
        extension => bind_value '/DBICx/Modeler/Generator/Driver/extension',
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

around _build_dbname => sub {
    my ($next, $self) = @_;

    return $self->path->get_full_path(
        $self->tree->route_to_target,
        $self->$next,
        $self->extension,
    )->stringify;
};

sub _build_command {
    my $self = shift;

    my $command = $self->bin;
    $command .= sprintf ' "%s"', $self->dbname;
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
L<DBICx::Modeler::Generator::DriverLike>.

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
