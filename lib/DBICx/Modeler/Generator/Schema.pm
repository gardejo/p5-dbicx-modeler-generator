package DBICx::Modeler::Generator::Schema;


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
        driver     => bind_value '/DBICx/Modeler/Generator/Driver',
        path       => bind_value '/DBICx/Modeler/Generator/Path',
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

has 'driver' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::DriverLike',
    required    => 1,
);

has 'path' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::PathLike',
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

    foreach my $attribute (qw(
        components is_debug
    )) {
        delete $args->{$attribute}
            unless defined $args->{$attribute};
    }

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_components {
    return [];
}

sub _build_is_debug {
    return 0;
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub make_schemata {
    my $self = shift;

    # keep make_schema_at()'s mouth shut! (for Perl 5.8+)
    # cf. http://d.hatena.ne.jp/ktat/20060829/1156853692
    # cf. http://d.hatena.ne.jp/ktat/20090607/1244332749
    my $stderr = q{};
    local *STDERR;
    open STDERR, '>', \$stderr
        or die $!;  # note: can not cover this true branch

    make_schema_at(
        $self->class->schema,
        {
            components            => $self->components,
            dump_directory        => $self->path->target_library,
            really_erase_my_files => 1,
            debug                 => $self->is_debug,
        },
        [
            $self->driver->dsn,
            $self->driver->username,
            $self->driver->password,
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

DBICx::Modeler::Generator::Schema - Implement class for DBICx::Modeler::Generator::SchemaLike

=head1 SYNOPSIS

    use DBICx::Modeler::Generator::Schema;

=head1 DESCRIPTION

This class is an implement class for
L<DBICx::Modeler::Generator::SchemaLike|DBICx::Modeler::Generator::SchemaLike>.

=head1 METHODS

=head2 Generator

=head3 C<< $self->make_schemata() >>

Loads and generates schema modules.

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
