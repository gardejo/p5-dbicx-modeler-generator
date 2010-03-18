package DBICx::Modeler::Generator::Class;


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
        base_part   => bind_value '/DBICx/Modeler/Generator/Class/base_part',
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

has [qw(base_part model_part schema_part)] => (
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

    foreach my $attribute (qw(
        base_part model_part schema_part
    )) {
        delete $args->{$attribute}
            unless defined $args->{$attribute};
    }

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_base_part {
    return 'Base';
}

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

    return $self->_split_class_name($self->model);
}

sub _build_route_to_schema {
    my $self = shift;

    return $self->_split_class_name($self->schema);
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

sub _split_class_name {
    my ($self, $class_name) = @_;

    return [
        split '::', $class_name
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

DBICx::Modeler::Generator::Class - Implement class for DBICx::Modeler::Generator::ClassLike

=head1 SYNOPSIS

    use DBICx::Modeler::Generator::Class;

=head1 DESCRIPTION

This class is an implement class for
L<DBICx::Modeler::Generator::ClassLike|DBICx::Modeler::Generator::ClassLike>.

=head1 METHODS

=head2 Loader

=head3 C<< $self->reload_class($attribute) >>

Reload class which is C<model> or C<class>.

=head2 Utilities

=head3 C<< $class_name = $self->get_class_name_from_path_string($path_string) >>

Returns a string of class name which corresponds with C<$path_string>.

=head3 C<< $class_name = $self->get_fully_qualified_class_name(@parts_of_class_name) >>

Returns a string which joined C<@parts_of_class_name> with joint string C<::>.

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
