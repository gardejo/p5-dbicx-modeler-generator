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
    isa         => 'DBICx::Modeler::Generator::TreeLike',
    weak_ref    => 1,
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

    my $option = $class->$next(@args);

    delete $option->{extension}
        unless defined $option->{extension};

    return $option;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_source {
    $_[0]->root->subdir($_[0]->tree->route_to_source);
}

sub _build_target {
    $_[0]->root->subdir($_[0]->tree->route_to_target);
}

sub _build_extension {
    return '.pm';
}

sub _build_source_model {
    $_[0]->_get_relative_file_path($_[0]->tree->route_to_source_model);
}

sub _build_target_model {
    $_[0]->_get_relative_file_path($_[0]->tree->route_to_target_model);
}

sub _build_source_schema {
    $_[0]->_get_relative_file_path($_[0]->tree->route_to_source_schema);
}

sub _build_target_schema {
    $_[0]->_get_relative_file_path($_[0]->tree->route_to_target_schema);
}

sub _build_source_models {
    $_[0]->root->subdir($_[0]->tree->route_to_source_model);
}

sub _build_target_models {
    $_[0]->root->subdir($_[0]->tree->route_to_target_model);
}

sub _build_source_schemata {
    $_[0]->root->subdir($_[0]->tree->route_to_source_schema);
}

sub _build_target_schemata {
    $_[0]->root->subdir($_[0]->tree->route_to_target_schema);
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

=cut
