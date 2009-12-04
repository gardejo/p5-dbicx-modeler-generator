package DBICx::Modeler::Generator::CLI;


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


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Orochi;


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    MooseX::Getopt
    MooseX::SimpleConfig
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'application' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
    cmd_aliases => [qw(a)],
);

has 'driver' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
    cmd_aliases => [qw(d)],
);

has 'root' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
    cmd_aliases => [qw(r)],
);

has 'username' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Str',
    cmd_aliases => [qw(u)],
);

has 'password' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Str',
    cmd_aliases => [qw(w)],
);

has 'host' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Str',
    cmd_aliases => [qw(h)],
);

has 'port' => (
    traits      => [qw(
        Getopt
    )],
    is          => 'ro',
    isa         => 'Int',
    cmd_aliases => [qw(p)],
);

has 'literal' => (
    traits      => [qw(
        Getopt
        Hash
    )],
    is          => 'ro',
    isa         => 'HashRef[Str]',
    lazy_build  => 1,
    handles     => {
        literal_pairs => 'kv',
        set_literal   => 'set',
    },
    cmd_aliases => [qw(l)],
);

has 'base_registory' => (
    traits      => [qw(
        NoGetopt
    )],
    is          => 'ro',
    isa         => 'Str',
    init_arg    => undef,
    lazy_build  => 1,
);

has 'classes' => (
    traits      => [qw(
        Array
        NoGetopt
    )],
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
        # not 'ArrayRef[ClassName]' because classes have not been loaded yet
    init_arg    => undef,
    lazy_build  => 1,
    handles     => {
        all_classes => 'elements',
    },
);

has 'container' => (
    traits      => [qw(
        NoGetopt
    )],
    is          => 'ro',
    isa         => 'Orochi',
    init_arg    => undef,
    lazy_build  => 1,
);

has 'generator' => (
    traits      => [qw(
        NoGetopt
    )],
    is          => 'ro',
    isa         => 'Object',    # DBICx::Modeler::Generator
    init_arg    => undef,
    lazy_build  => 1,
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_base_registory {
    return '/DBICx/Modeler/Generator';
}

sub _build_classes {
    my $self = shift;

    return [
        qw(
            DBICx::Modeler::Generator
            DBICx::Modeler::Generator::Class
            DBICx::Modeler::Generator::Model
            DBICx::Modeler::Generator::Path
            DBICx::Modeler::Generator::Schema
            DBICx::Modeler::Generator::Tree
        ),
        'DBICx::Modeler::Generator::Driver::' . $self->driver,
    ];
}

sub _build_container {
    return Orochi->new;
}

sub _build_literal {
    return {};
}

sub _build_generator {
    my $self = shift;

    return $self->container->get($self->base_registory);
}


# ****************************************************************
# hook(s) on construction
# ****************************************************************

sub BUILD {
    my $self = shift;

    $self->_inject_literals;
    $self->_inject_classes;

    return;
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _inject_literals {
    my $self = shift;

    $self->set_literal(
        '/Class/application' => $self->application,
        '/Path/root'         => $self->root,
    );
    foreach my $driver_attribute (qw(username password host port)) {
        $self->set_literal
            ('/Driver/' . $driver_attribute => $self->$driver_attribute)
                if defined $self->$driver_attribute;
    }

    foreach my $pair ($self->literal_pairs) {
        $self->container->inject_literal
            ($self->base_registory . $pair->[0] => $pair->[1]);
    }

    return;
}

sub _inject_classes {
    my $self = shift;

    foreach my $class ($self->all_classes) {
        $self->container->inject_class($class);
    }

    return;
}


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

DBICx::Modeler::Generator::CLI - Command line interface to DBICx::Modeler::Generator

=head1 SYNOPSIS

    use strict;
    use warnings;

    use DBICx::Modeler::Generator::CLI;

    my $generator = DBICx::Modeler::Generator::CLI->new_with_options->generator;

    $generator->deploy_database;
    $generator->update_schemata;
    $generator->update_models;

=head1 DESCRIPTION

This module wraps the interface to L<DBICx::Modeler::Generator>
with L<MooseX::Getopt> and L<MooseX::SimpleConfig>.

See C</examples/src/sbin/maintain_models.pl> of this distribution
for further detail.

=head1 SEE ALSO

=over 4

=item *

L<MooseX::Getopt>

=item *

L<Getopt::Long>

=item *

L<MooseX::SimpleConfig>

=item *

L<DBICx::Modeler>

=item *

L<DBIx::Class::Schema::Loader>

=item *

L<DBICx::Modeler::Generator>

=back

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. "Gardejo")

C<< <moriya at ermitejo dot com> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by MORIYA Masaki (a.k.a. "Gardejo"),
L<http://ttt.ermitejo.com>.

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl> and L<perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
