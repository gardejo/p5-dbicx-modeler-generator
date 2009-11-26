package DBICx::Modeler::Generator;


# ****************************************************************
# perl dependency
# ****************************************************************

use 5.008_001;


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
# class constant(s)
# ****************************************************************

our $VERSION = "0.00";


# ****************************************************************
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator' => (
    args => {
        class       => bind_value '/DBICx/Modeler/Generator/Class',
        model       => bind_value '/DBICx/Modeler/Generator/Model',
        path        => bind_value '/DBICx/Modeler/Generator/Path',
        schema      => bind_value '/DBICx/Modeler/Generator/Schema',
    },
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'class' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::ClassLike',
    required    => 1,
    handles     => {
        _reload_model_class  => [ reload_class => 'model'  ],
        _reload_schema_class => [ reload_class => 'schema' ],
    },
);

has 'model' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::ModelLike',
    required    => 1,
    handles     => {
        _make_models => 'make_models',
    },
);

has 'path' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::PathLike',
    required    => 1,
    handles     => {
        _remove_models      => [ remove_path => {
            file      => 'target_model',
            directory => 'target_models',
        } ],
        _remove_schemata    => [ remove_path => {
            file      => 'target_schema',
            directory => 'target_schemata',
        } ],
        _add_source_library => 'add_source_library',
    },
);

has 'schema' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::SchemaLike',
    required    => 1,
    handles     => {
        _make_schemata => 'make_schemata',
    },
);


# ****************************************************************
# public method(s)
# ****************************************************************

sub update_models {
    my $self = shift;

    $self->_remove_models;

    $self->_make_models;

    # $self->_add_source_library;
    # $self->_reload_model_class;
    # $self->_make_models;

    return;
}

sub update_schemata {
    my $self = shift;

    $self->_remove_schemata;

    $self->_make_schemata;

    $self->_add_source_library;
    $self->_reload_schema_class;
    $self->_make_schemata;

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

DBICx::Modeler::Generator - Dynamic definition of a DBICx::Modeler model

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

This module provides dynamic definition of a L<DBICx::Modeler> model.

=head1 METHODS

=head2 Services

=head3 C<< $self->update_models() >>

Updates modules of models.

=head3 C<< $self->update_schemata() >>

Updates modules of schemata.

=head1 DEPENDENCY INJECTION

This module using L<MooseX::Orochi> and L<Orochi> for dependency injection.

See C</examples/source/sbin/maintain_models.mysql.pl> in this distribution
for further datail.

=head2 MANDATORY DEPENDENCIES

=head3 C<< /DBICx/Modeler/Generator/Class >>

It is a concrete class
which complies with L<DBICx::Modeler::Generator::ClassLike> role.

This distribution contains a concrete class
which named L<DBICx::Modeler::Generator::Class> for common usage.

=head3 C<< /DBICx/Modeler/Generator/Class/application >>

It is a class name of the application root.

=over 4

=item Type

C<< Str >>

=item Example

C<< MyApp >>

=back

=head3 C<< /DBICx/Modeler/Generator/Model >>

It is a concrete class
complies with L<DBICx::Modeler::Generator::ModelLike> role.

This distribution contains a concrete class
which named L<DBICx::Modeler::Generator::Model> for common usage.

=head3 C<< /DBICx/Modeler/Generator/Path >>

It is a concrete class
complies with L<DBICx::Modeler::Generator::PathLike> role.

This distribution contains a concrete class
which named L<DBICx::Modeler::Generator::Path> for common usage.

=head3 C<< /DBICx/Modeler/Generator/Path/root >>

It is a directory path of the application root.

=over 4

=item Type

C<< Path::Class::Dir >> (can coerce with L<MooseX::Types::Path::Class>)

=item Example

C<< /path/to/root >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema >>

It is a concrete class
complies with L<DBICx::Modeler::Generator::SchemaLike> role.

This distribution contains a concrete class
which named L<DBICx::Modeler::Generator::Schema> for common usage.

=head3 C<< /DBICx/Modeler/Generator/Schema/dsn >>

It is a data source name which used by database connection.

=over 4

=item Type

C<< Str >>

=item Example

C<< dbi:mysql:dbname=myapp:host=localhost >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema/username >>

It is a username which used by database connection.

=over 4

=item Type

C<< Str >>

=item Eexample

C<< mysql_user >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema/password >>

It is a password which used by database connection.

=over 4

=item Type

C<< Str >>

=item Example

C<< foobar >>

=back

=head3 C<< /DBICx/Modeler/Generator/Tree >>

It is a concrete class
complies with L<DBICx::Modeler::Generator::TreeLike> role.

This distribution contains a concrete class
which named L<DBICx::Modeler::Generator::Tree> for common usage.

=head2 OPTIONAL DEPENDENCIES

=head3 C<< /DBICx/Modeler/Generator/Class/model_part >>

=over 4

=item Type

C<< Str >>

=item Default

C<< Model >>

=back

=head3 C<< /DBICx/Modeler/Generator/Class/schema_part >>

=over 4

=item Type

C<< Str >>

=item Default

C<< Schema >>

=back

=head3 C<< /DBICx/Modeler/Generator/Model/base >>

=over 4

=item Type

C<< Str >>

=item Default

C<< Base >>

=back

=head3 C<< /DBICx/Modeler/Generator/Path/extension >>

=over 4

=item Type

C<< Str >>

=item Default

C<< .pm >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema/components >>

=over 4

=item Type

C<< ArrayRef[Str] >>

=item Default

C<< [qw(UTF8Columns)] >>

=back

=head3 C<< /DBICx/Modeler/Generator/Schema/is_debug >>

=over 4

=item Type

C<< Bool >>

=item Default

C<< 0 >> (false)

=back

=head3 C<< /DBICx/Modeler/Generator/Tree/source >>

=over 4

=item Type

C<< ArrayRef[Str] >>

=item Default

C<< [qw(source lib)] >>

=back

=head3 C<< /DBICx/Modeler/Generator/Tree/target >>

=over 4

=item Type

C<< ArrayRef[Str] >>

=item Default

C<< [qw(lib)] >>

=back

=head1 SEE ALSO

=over 4

=item * L<DBICx::Modeler>

=item * L<DBIx::Class::Schema::Loader>

=item * L<DBIx::Class>

=back

=head1 INCOMPATIBILITIES

None reported.

=head1 TO DO

=over 4

=item * Using L<MooseX::Getopt>

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head2 Making suggestions and reporting bugs

Please report any found bugs, feature requests, and ideas for improvements
to L<http://github.com/gardejo/p5-dbicx-modeler-generator/issues>.
I will be notified, and then you'll automatically be notified of progress
on your bugs/requests as I make changes.

When reporting bugs, if possible,
please add as small a sample as you can make of the code
that produces the bug.
And of course, suggestions and patches are welcome.

=head1 SUPPORT

You can find documentation for this module with the C<perldoc> command.

    perldoc DBICx::Modeler::Generator

=head1 VERSION CONTROL

This module is maintained using git.
You can get the latest version from
L<git://github.com/gardejo/p5-dbicx-modeler-generator.git>.

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
