package DBICx::Modeler::Generator::Path;


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
        class
            => bind_value '/DBICx/Modeler/Generator/Class',
        creation_script
            => bind_value '/DBICx/Modeler/Generator/Path/creation_script',
        module_extension
            => bind_value '/DBICx/Modeler/Generator/Path/module_extension',
        script_extension
            => bind_value '/DBICx/Modeler/Generator/Path/script_extension',
        root
            => bind_value '/DBICx/Modeler/Generator/Path/root',
        tree
            => bind_value '/DBICx/Modeler/Generator/Tree',
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

has 'tree' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::TreeLike',
    required    => 1,
);

has 'root' => (
    is          => 'ro',
    isa         => Dir,
    coerce      => 1,
    required    => 1,
);

has [qw(source_library target_library)] => (
    is          => 'ro',
    isa         => Dir,
    init_arg    => undef,
    coerce      => 1,
    lazy_build  => 1,
);

has [qw(
    source_model source_schema
    target_model target_schema
)] => (
    is          => 'ro',
    isa         => File,
    init_arg    => undef,
    lazy_build  => 1,
);

has [qw(
    source_models source_schemata
    target_models target_schemata
)] => (
    is          => 'ro',
    isa         => Dir,
    init_arg    => undef,
    lazy_build  => 1,
);

has 'creation_script' => (
    is          => 'ro',
    isa         => File,
    coerce      => 1,
    lazy_build  => 1,
);

has [qw(module_extension script_extension)] => (
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
        module_extension script_extension creation_script
    )) {
        delete $args->{$attribute}
            unless defined $args->{$attribute};
    }

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_source_library {
    my $self = shift;

    return $self->root->subdir($self->tree->route_to_source_library);
}

sub _build_target_library {
    my $self = shift;

    return $self->root->subdir($self->tree->route_to_target_library);
}

sub _build_creation_script {
    my $self = shift;

    return $self->get_full_path(
        $self->tree->route_to_source,
        $self->tree->application,
        $self->script_extension,
    );
}

sub _build_module_extension {
    return '.pm';
}

sub _build_script_extension {
    return '.sql';
}

sub _build_source_model {
    my $self = shift;

    return $self->get_full_path(
        $self->tree->route_to_source_model,
        $self->module_extension,
    );
}

sub _build_target_model {
    my $self = shift;

    return $self->get_full_path(
        $self->tree->route_to_target_model,
        $self->module_extension,
    );
}

sub _build_source_schema {
    my $self = shift;

    return $self->get_full_path(
        $self->tree->route_to_source_schema,
        $self->module_extension,
    );
}

sub _build_target_schema {
    my $self = shift;

    return $self->get_full_path(
        $self->tree->route_to_target_schema,
        $self->module_extension,
    );
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
    my ($self, $path_attribute) = @_;

    my ($file, $directory) = @$path_attribute{qw(file directory)};

    $self->$file->remove;
    $self->$directory->rmtree;

    return;
}

sub add_source_library {
    my $self = shift;

    unshift @INC, $self->source_library->stringify;

    return;
}

sub get_full_path {
    my ($self, @routes) = @_;

    confess 'Could not get full path with @routes because: '
          . '@routes should have 2 (for basename, extension) or more elements.'
        if scalar @routes < 2;
    my $file = join q{}, splice(@routes, -2, 2);    # basename.extension

    return $self->root->file(@routes, $file);
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

DBICx::Modeler::Generator::Path - Implement class for DBICx::Modeler::Generator::PathLike

=head1 SYNOPSIS

    use DBICx::Modeler::Generator::Path;

=head1 DESCRIPTION

This class is an implement class for
L<DBICx::Modeler::Generator::PathLike|DBICx::Modeler::Generator::PathLike>.

=head1 METHODS

=head2 Remover

=head3 C<< $self->remove_path({ file => $file_attribute, directory => $directory_attribute }) >>

Removes file and directory tree.

=head2 Utilities

=head3 C<< $full_path = $self->get_full_path(@directories, $file, $extension) >>

Returns L<Path::Class::File|Path::Class::File> object
which corresponds with specified arguments.

=head3 C<< $self->add_source_library() >>

Added source directory into library path (which is C<@INC>).

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
