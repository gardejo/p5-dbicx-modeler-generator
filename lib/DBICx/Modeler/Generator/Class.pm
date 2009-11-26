package DBICx::Modeler::Generator::Class;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;
use MooseX::Orochi;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Class::Unload;
use Module::Load;


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

has [qw(model_part schema_part)] => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
);

has [qw(model schema)] => (
    is          => 'ro',
    isa         => 'Str',
    init_arg    => undef,
    lazy_build  => 1,
);

has [qw(route_to_model route_to_schema)] => (
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    init_arg    => undef,
    lazy_build  => 1,
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @args) = @_;

    my $args = $class->$next(@args);

    delete $args->{model_part}
        unless defined $args->{model_part};
    delete $args->{schema_part}
        unless defined $args->{schema_part};

    return $args;
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

    return $self->get_fully_qualified_class_name(
        $self->application,
        $self->model_part,
    );
}

sub _build_schema {
    my $self = shift;

    return $self->get_fully_qualified_class_name(
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
# public method(s)
# ****************************************************************

sub reload_class {
    my ($self, $attribute) = @_;

    my $class = $self->$attribute;
    Class::Unload->unload($class);  # unload class of target
    load $class;                    # reload class from source (@INC is added)

    return;
}

sub get_fully_qualified_class_name {
    my $self = shift;

    return join '::', @_;
}

sub get_class_name_from_path_string {
    my ($self, $path_string) = @_;

    my $class_name = $path_string;
    $class_name =~ s{ \.pm \z }{}xms;
    $class_name =~ s{ / }{::}xmsg;

    return $class_name;
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

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

=head1 METHODS

=head2 Loaders

=head3 C<< $self->reload_class($attribute) >>

Reload class which is C<model> or C<class>.

=head2 Utilities

=head3 C<< $self->get_class_name_from_path_string($path_string) >>

Returns a string of class name which corresponds with C<$path_string>.

=head3 C<< $self->get_fully_qualified_class_name(@parts_of_class_name) >>

Returns a string which joined C<@parts_of_class_name> with q<::>.

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
