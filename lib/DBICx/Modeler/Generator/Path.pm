package DBICx::Modeler::Generator::Path;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;
use MooseX::Orochi;
use MooseX::Types::Path::Class qw(File Dir);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator/Path' => (
    args => {
        tree      => bind_value '/DBICx/Modeler/Generator/Tree',
        root      => bind_value '/DBICx/Modeler/Generator/Path/root',
        extension => bind_value '/DBICx/Modeler/Generator/Path/extension',
    },
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'tree' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::TreeLike',
    weak_ref    => 1,
    required    => 1,
);

has 'root' => (
    is          => 'ro',
    isa         => Dir,
    coerce      => 1,
    required    => 1,
);

has [qw(source target)] => (
    is          => 'ro',
    isa         => Dir,
    init_arg    => undef,
    coerce      => 1,
    lazy_build  => 1,
);

has 'extension' => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
);

has [qw(
    source_model    source_schema
    target_model    target_schema
)] => (
    is          => 'ro',
    isa         => File,
    init_arg    => undef,
    lazy_build  => 1,
);

has [qw(
    source_models   source_schemata
    target_models   target_schemata
)] => (
    is          => 'ro',
    isa         => Dir,
    init_arg    => undef,
    lazy_build  => 1,
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @args) = @_;

    my $args = $class->$next(@args);

    delete $args->{extension}
        unless defined $args->{extension};

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_source {
    my $self = shift;

    return $self->root->subdir($self->tree->route_to_source);
}

sub _build_target {
    my $self = shift;

    return $self->root->subdir($self->tree->route_to_target);
}

sub _build_extension {
    return '.pm';
}

sub _build_source_model {
    my $self = shift;

    return $self->_get_relative_file_path($self->tree->route_to_source_model);
}

sub _build_target_model {
    my $self = shift;

    return $self->_get_relative_file_path($self->tree->route_to_target_model);
}

sub _build_source_schema {
    my $self = shift;

    return $self->_get_relative_file_path($self->tree->route_to_source_schema);
}

sub _build_target_schema {
    my $self = shift;

    return $self->_get_relative_file_path($self->tree->route_to_target_schema);
}

sub _build_source_models {
    my $self = shift;

    return $self->root->subdir($self->tree->route_to_source_model);
}

sub _build_target_models {
    my $self = shift;

    return $self->root->subdir($self->tree->route_to_target_model);
}

sub _build_source_schemata {
    my $self = shift;

    return $self->root->subdir($self->tree->route_to_source_schema);
}

sub _build_target_schemata {
    my $self = shift;

    return $self->root->subdir($self->tree->route_to_target_schema);
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub remove_path {
    my ($self, $path) = @_;

    my ($file, $directory) = @$path{qw(file directory)};

    $self->$file->remove;
    $self->$directory->rmtree;

    return;
}

sub add_source_library {
    my $self = shift;

    unshift @INC, $self->source->stringify;

    return;
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _get_relative_file_path {
    my ($self, @routes) = @_;

    return $self->root->file(
        @routes[0 .. $#routes - 1],
        $routes[-1] . $self->extension,
    );
}


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    DBICx::Modeler::Generator::PathLike
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

DBICx::Modeler::Generator::Path -

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=head1 METHODS

=head2 Remover

=head3 C<< $self->remove_path({ file => 'file_attribute', directory => 'directory_attribute'}) >>

Removes file(s) and directory tree.

=head2 Maintainer for library path

=head3 C<< $self->add_source_library >>

Added source directory into library path (which is C<@INC>).

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
