package DBICx::Modeler::Generator::Model;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;
use MooseX::Orochi;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Text::MicroTemplate::Extended;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator/Model' => (
    args => {
        base => bind_value '/DBICx/Modeler/Generator/Model/base',
    },
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'base' => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @args) = @_;

    my $args = $class->$next(@args);

    delete $args->{base}
        unless defined $args->{base};

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_base {
    return 'Base';
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub make_models {
    my ($self, $class, $path) = @_;

    mkdir $path->target_models->stringify
        unless -f $path->target_models->stringify;

    my $template = $self->_get_template($path);

    foreach my $schema_file ( $path->target_schemata->children ) {
        my $table_module = $schema_file->basename;
        my $template_name
            = $self->_get_template_name
                ($class, $path, $table_module, $schema_file);

        $template->template_args({
            stash => {
                package => $class->get_fully_qualified_class_name(
                    $class->model,
                    $class->get_class_name_from_path_string($table_module),
                ),
                code    => q{},
            }
        });
        $self->_dump_models_with_template
            ($template, $path, $table_module, $template_name);
    }

    return;
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _get_template {
    my ($self, $path) = @_;

    return Text::MicroTemplate::Extended->new(
        include_path    => [
            $path->source_models->stringify,
        ],
        extension       => $path->extension,
    );
}

sub _get_template_name {
    my ($self, $class, $path, $table_module, $schema_file) = @_;

    return -f $path->source_models->file($table_module)
        ? $class->get_class_name_from_path_string($schema_file->basename)
        : $self->base;
}

sub _dump_models_with_template {
    my ($self, $template, $path, $table_module, $template_name) = @_;

    my $handle = $path->target_models->file($table_module)->openw;
    $handle->print($template->render($template_name));
    $handle->close;

    return;
}


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    DBICx::Modeler::Generator::ModelLike
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

DBICx::Modeler::Generator::Model -

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=head1 METHODS

=head2 Generator

=head3 C<< $self->make_models($class, $path) >>

Loads and generates model modules.

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
