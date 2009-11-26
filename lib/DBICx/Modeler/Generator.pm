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
use MooseX::Types::Path::Class qw(Dir);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Class::Unload;
use DBIx::Class::Schema::Loader qw(make_schema_at);
use Module::Load;
use Text::MicroTemplate::Extended;


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
        tree        => bind_value '/DBICx/Modeler/Generator/Tree',
        path        => bind_value '/DBICx/Modeler/Generator/Path',
        dsn         => bind_value '/DBICx/Modeler/Generator/dsn',
        username    => bind_value '/DBICx/Modeler/Generator/username',
        password    => bind_value '/DBICx/Modeler/Generator/password',
        components  => bind_value '/DBICx/Modeler/Generator/components',
        is_debug    => bind_value '/DBICx/Modeler/Generator/is_debug',
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

has 'path' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::PathLike',
    required    => 1,
);

has [qw(dsn username password)] => (
    is          => 'ro',
    isa         => 'Str',
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

    delete $args->{components}
        unless defined $args->{components};
    delete $args->{is_debug}
        unless defined $args->{is_debug};

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_components {
    return [qw(
        UTF8Columns
    )];
}

sub _build_is_debug {
    return 0;
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub update_models {
    my $self = shift;

    $self->_remove_models;
    $self->_create_models;
    # $self->_modify_models;

    return;
}

sub update_schemata {
    my $self = shift;

    $self->_remove_schemata;
    $self->_create_schemata;
    $self->_modify_schemata;

    return;
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _remove_models {
    my $self = shift;

    $self->path->target_model->remove;
    $self->path->target_models->rmtree;

    return;
}

sub _create_models {
    my $self = shift;

    $self->_make_models;

    return;
}

=for comment

sub _modify_models {
    my $self = shift;

    $self->_reload_model_class;
    $self->_make_models;

    return;
}

=cut

sub _remove_schemata {
    my $self = shift;

    $self->path->target_schema->remove;
    $self->path->target_schemata->rmtree;

    return;
}

sub _create_schemata {
    my $self = shift;

    $self->_make_schemata;

    return;
}

sub _modify_schemata {
    my $self = shift;

    $self->_reload_schema_class;
    $self->_make_schemata;

    return;
}

sub _reload_model_class {
    my $self = shift;

    $self->_reload_class($self->class->model);

    return;
}

sub _reload_schema_class {
    my $self = shift;

    $self->_reload_class($self->class->schema);

    return;
}

sub _reload_class {
    my ($self, $class) = @_;

    Class::Unload->unload($class);  # unload class of target
    $self->_add_source_library;
    load $class;                    # reload class from source (@INC is added)

    return;
}

sub _add_source_library {
    my $self = shift;

    unshift @INC, $self->path->source->stringify;

    return;
}

sub _make_schemata {
    my $self = shift;

    make_schema_at(
        $self->class->schema,
        {
            components              => $self->components,
            dump_directory          => $self->path->target,
            really_erase_my_files   => 1,
            debug                   => $self->is_debug,
        },
        [
            $self->dsn,
            $self->username,
            $self->password,
        ],
    );

    return;
}

sub _make_models {
    my $self = shift;

    mkdir $self->path->target_models->stringify
        unless -f $self->path->target_models->stringify;

    my $template = Text::MicroTemplate::Extended->new(
        include_path    => [
            $self->path->source_models->stringify,
        ],
        extension       => $self->path->extension,
    );

    foreach my $schema_file ( $self->path->target_schemata->children) {
        my $module = $schema_file->basename;
        ( my $class = $module ) =~ s{\.pm}{};

        ( my $template_name = $schema_file->basename ) =~ s{\.pm}{};
        if ( ! -f $self->path->source_models->file($module) ) {
            $template_name = 'Base';
        }

        $template->template_args({
            stash => {
                package => $self->class->model . '::' . $class,
                code    => q{},
            }
        });

        my $handle = $self->path->target_models->file($module)->openw;
        $handle->print($template->render($template_name));
        $handle->close;
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

=head3 C<< /DBICx/Modeler/Generator/dsn >>

It is a data source name which used by database connection.

=over 4

=item Type

C<< Str >>

=item Example

C<< dbi:mysql:dbname=myapp:host=localhost >>

=back

=head3 C<< /DBICx/Modeler/Generator/username >>

It is a username which used by database connection.

=over 4

=item Type

C<< Str >>

=item Eexample

C<< mysql_user >>

=back

=head3 C<< /DBICx/Modeler/Generator/password >>

It is a password which used by database connection.

=over 4

=item Type

C<< Str >>

=item Example

C<< foobar >>

=back

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

=head3 C<< /DBICx/Modeler/Generator/Tree >>

It is a concrete class
complies with L<DBICx::Modeler::Generator::TreeLike> role.

This distribution contains a concrete class
which named L<DBICx::Modeler::Generator::Tree> for common usage.

=head2 OPTIONAL DEPENDENCIES

=head3 C<< /DBICx/Modeler/Generator/components >>

=over 4

=item Type

C<< ArrayRef[Str] >>

=item Default

C<< [qw(UTF8Columns)] >>

=back

=head3 C<< /DBICx/Modeler/Generator/is_debug >>

=over 4

=item Type

C<< Bool >>

=item Default

C<< 0 >> (false)

=back

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

=head3 C<< /DBICx/Modeler/Generator/Path/extension >>

=over 4

=item Type

C<< Str >>

=item Default

C<< .pm >>

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
