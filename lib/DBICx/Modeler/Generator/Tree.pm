package DBICx::Modeler::Generator::Tree;


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
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator/Tree' => (
    args => {
        class       => bind_value '/DBICx/Modeler/Generator/Class',
        application => bind_value '/DBICx/Modeler/Generator/Tree/application',
        library     => bind_value '/DBICx/Modeler/Generator/Tree/library',
        source      => bind_value '/DBICx/Modeler/Generator/Tree/source',
        target      => bind_value '/DBICx/Modeler/Generator/Tree/target',
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

has 'application' => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
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

has 'library' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
    handles     => {
        route_to_library => 'elements',
    },
);

has 'source_library' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        route_to_source_library => 'elements',
    },
);

has 'target_library' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        route_to_target_library => 'elements',
    },
);

has 'model' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        route_to_model => 'elements',
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

has 'schema' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        route_to_schema => 'elements',
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

    my $args = $class->$next(@args);

    foreach my $attribute (qw(
        application library source target
    )) {
        delete $args->{$attribute}
            unless defined $args->{$attribute};
    }

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_application {
    my $self = shift;

    my $application = lc $self->class->application;
    $application =~ s{::}{_}xmsg;

    return $application;
}

sub _build_source {
    return [qw(src)];
}

sub _build_target {
    return [qw()];
}

sub _build_library {
    return [qw(lib)];
}

sub _build_source_library {
    my $self = shift;

    return [
        $self->route_to_source,
        $self->route_to_library,
    ];
}

sub _build_target_library {
    my $self = shift;

    return [
        $self->route_to_target,
        $self->route_to_library,
    ];
}

sub _build_model {
    my $self = shift;

    return $self->class->route_to_model;
}

sub _build_source_model {
    my $self = shift;

    return [
        $self->route_to_source_library,
        $self->route_to_model,
    ];
}

sub _build_target_model {
    my $self = shift;

    return [
        $self->route_to_target_library,
        $self->route_to_model,
    ];
}

sub _build_schema {
    my $self = shift;

    return $self->class->route_to_schema;
}

sub _build_source_schema {
    my $self = shift;

    return [
        $self->route_to_source_library,
        $self->route_to_schema,
    ];
}

sub _build_target_schema {
    my $self = shift;

    return [
        $self->route_to_target_library,
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

DBICx::Modeler::Generator::Tree - Implement class for DBICx::Modeler::Generator::TreeLike

=head1 SYNOPSIS

    use DBICx::Modeler::Generator::Tree;

=head1 DESCRIPTION

This class is an implement class for
L<DBICx::Modeler::Generator::TreeLike|DBICx::Modeler::Generator::TreeLike>.

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
