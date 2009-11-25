package DBICx::Modeler::Generator::Tree;


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
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator/Tree' => (
    args => {
        class  => bind_value '/DBICx/Modeler/Generator/Class',
        source => bind_value '/DBICx/Modeler/Generator/Tree/source',
        target => bind_value '/DBICx/Modeler/Generator/Tree/target',
    },
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'class' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::ClassLike',
    weak_ref    => 1,
    required    => 1,
);

has 'source' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
    handles     => {
        route_to_source => 'elements',
    },
);

has 'target' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
    handles     => {
        route_to_target => 'elements',
    },
);

has 'model' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
    handles     => {
        route_to_model => 'elements',
    },
);

has 'schema' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
    handles     => {
        route_to_schema => 'elements',
    },
);

has 'source_model' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        route_to_source_model => 'elements',
    },
);

has 'target_model' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        route_to_target_model => 'elements',
    },
);

has 'source_schema' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    init_arg    => undef,
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
    handles     => {
        route_to_source_schema => 'elements',
    },
);

has 'target_schema' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    init_arg    => undef,
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
    handles     => {
        route_to_target_schema => 'elements',
    },
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @args) = @_;

    my $option = $class->$next(@args);

    delete $option->{source}
        unless defined $option->{source};
    delete $option->{target}
        unless defined $option->{target};

    return $option;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_source {
    return [qw(source lib)];
}

sub _build_target {
    return [qw(lib)];
}

sub _build_model {
    my $self = shift;

    return $self->class->route_to_model;
}

sub _build_schema {
    my $self = shift;

    return $self->class->route_to_schema;
}

sub _build_source_model {
    my $self = shift;

    return [
        $self->route_to_source,
        $self->route_to_model,
    ];
}

sub _build_target_model {
    my $self = shift;

    return [
        $self->route_to_target,
        $self->route_to_model,
    ];
}

sub _build_source_schema {
    my $self = shift;

    return [
        $self->route_to_source,
        $self->route_to_schema,
    ];
}

sub _build_target_schema {
    my $self = shift;

    return [
        $self->route_to_target,
        $self->route_to_schema,
    ];
}


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    DBICx::Modeler::Generator::TreeLike
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

DBICx::Modeler::Generator::Tree -

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=cut
