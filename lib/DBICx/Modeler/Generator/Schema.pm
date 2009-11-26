package DBICx::Modeler::Generator::Schema;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;
use MooseX::Orochi;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use DBIx::Class::Schema::Loader qw(make_schema_at);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator/Schema' => (
    args => {
        class      => bind_value '/DBICx/Modeler/Generator/Class',
        path       => bind_value '/DBICx/Modeler/Generator/Path',
        dsn        => bind_value '/DBICx/Modeler/Generator/Schema/dsn',
        username   => bind_value '/DBICx/Modeler/Generator/Schema/username',
        password   => bind_value '/DBICx/Modeler/Generator/Schema/password',
        components => bind_value '/DBICx/Modeler/Generator/Schema/components',
        is_debug   => bind_value '/DBICx/Modeler/Generator/Schema/is_debug',
    },
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'class' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::ClassLike',
    required    => 1,
);

has 'path' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::PathLike',
    required    => 1,
);

has [qw(dsn username password)] => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

has 'components' => (
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
);

has 'is_debug' => (
    is          => 'ro',
    isa         => 'Bool',
    lazy_build  => 1,
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @args) = @_;

    my $args = $class->$next(@args);

    delete $args->{components}
        unless defined $args->{components};
    delete $args->{is_debug}
        unless defined $args->{is_debug};

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_components {
    return [qw(
        UTF8Columns
    )];
}

sub _build_is_debug {
    return 0;
}


# ****************************************************************
# consuming role(s)
# ****************************************************************

sub make_schemata {
    my $self = shift;

    make_schema_at(
        $self->class->schema,
        {
            components              => $self->components,
            dump_directory          => $self->path->target,
            really_erase_my_files   => 1,
            debug                   => $self->is_debug,
        },
        [
            $self->dsn,
            $self->username,
            $self->password,
        ],
    );

    return;
}


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    DBICx::Modeler::Generator::SchemaLike
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

DBICx::Modeler::Generator::Schema -

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=head1 METHODS

=head2 Generator

=head3 C<< $self->make_schemata() >>

Loads and generates schema modules.

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
