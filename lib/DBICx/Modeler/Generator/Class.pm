package DBICx::Modeler::Generator::Class;


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

bind_constructor '/DBICx/Modeler/Generator/Class' => (
    args => {
        application => bind_value '/DBICx/Modeler/Generator/Class/application',
        model_part  => bind_value '/DBICx/Modeler/Generator/Class/model_part',
        schema_part => bind_value '/DBICx/Modeler/Generator/Class/schema_part',
    },
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'application' => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

has 'model_part' => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
);

has 'schema_part' => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
);

has [qw(model schema)] => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
);

has [qw(route_to_model route_to_schema)] => (
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @args) = @_;

    my $option = $class->$next(@args);

    delete $option->{model_part}
        unless defined $option->{model_part};
    delete $option->{schema_part}
        unless defined $option->{schema_part};

    return $option;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_model_part {
    return 'Model';
}

sub _build_schema_part {
    return 'Schema';
}

sub _build_model {
    my $self = shift;

    return $self->_side_name(
        $self->application,
        $self->model_part,
    );
}

sub _build_schema {
    my $self = shift;

    return $self->_side_name(
        $self->application,
        $self->schema_part,
    );
}

sub _build_route_to_model {
    my $self = shift;

    return $self->_split_classname($self->model);
}

sub _build_route_to_schema {
    my $self = shift;

    return $self->_split_classname($self->schema);
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _side_name {
    my $self = shift;

    return join '::', @_;
}

sub _split_classname {
    my ($self, $classname) = @_;

    return [
        split '::', $classname
    ];
}


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    DBICx::Modeler::Generator::ClassLike
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

DBICx::Modeler::Generator::Class -

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=cut
