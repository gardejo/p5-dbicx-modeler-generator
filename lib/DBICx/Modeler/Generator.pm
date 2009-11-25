package DBICx::Modeler::Generator;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;
use MooseX::Orochi;
use MooseX::Types::Path::Class qw(
    Dir
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Class::Unload;
use DBIx::Class::Schema::Loader qw(
    make_schema_at
);
use Module::Load;
use Text::MicroTemplate::Extended;


# ****************************************************************
# namespace clearer
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator' => (
    args => {
        class    => bind_value '/DBICx/Modeler/Generator/Class',
        tree     => bind_value '/DBICx/Modeler/Generator/Tree',
        path     => bind_value '/DBICx/Modeler/Generator/Path',
        dsn      => bind_value '/DBICx/Modeler/Generator/dsn',
        username => bind_value '/DBICx/Modeler/Generator/username',
        password => bind_value '/DBICx/Modeler/Generator/password',
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

    # $self->_reload_class($self->class->model, $self->class->route_to_model);
    $self->_reload_class($self->class->model);

    return;
}

sub _reload_schema_class {
    my $self = shift;

    # $self->_reload_class($self->class->schema, $self->class->route_to_schema);
    $self->_reload_class($self->class->schema);

    return;
}

sub _reload_class {
    my ($self, $class) = @_;
    # my ($self, $class, $route_to_class) = @_;

    # unload class of target
    # $self->_unload_class($class, $route_to_class);
    Class::Unload->unload($class);

    # reload class from source
    $self->_add_source_library;
    load $class;

    return;
}

=for comment

sub _unload_class {
    my ($self, $class, $route_to_class) = @_;

    # $route_to_class ||= [ split '::', $class ];

    # unload class of target
    # http://d.hatena.ne.jp/perlcodesample/20091101/1246274997
    {
        no strict 'refs';

        # delete @ISA
        @{ join '::', @$route_to_class, 'ISA' } = ();

        # delete symbol table of class
        %{ $class } = ();

        # delete class from upper namespace
        delete ${
            join '::', @$route_to_class[0 .. $#{$route_to_class} - 1], q{}
        }{
            join '::', $route_to_class->[-1], q{}
        };

        # delete loaded information
        delete $INC{ (join '/', @$route_to_class ) . $self->path->extension };
    }

    return;
}

=cut

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
            components              => [qw(
                UTF8Columns
            )],
            dump_directory          => $self->path->target,
            really_erase_my_files   => 1,
            debug                   => 1,
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
            stash   => {
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

DBICx::Modeler::Generator -

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=cut
