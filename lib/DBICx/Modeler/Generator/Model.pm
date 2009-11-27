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
        class => bind_value '/DBICx/Modeler/Generator/Class',
        path  => bind_value '/DBICx/Modeler/Generator/Path',
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

has 'path' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::PathLike',
    required    => 1,
);


# ****************************************************************
# public method(s)
# ****************************************************************

sub make_models {
    my $self = shift;

    $self->path->target_models->mkpath;

    my $template = $self->_get_template;

    foreach my $schema_file ( $self->path->target_schemata->children ) {
        my $table_module = $schema_file->basename;
        my $template_name
            = $self->_get_template_name($table_module, $schema_file);

        $template->template_args({
            stash => {
                package => $self->class->get_fully_qualified_class_name(
                    $self->class->model,
                    $self->class->get_class_name_from_path_string($table_module),
                ),
                code    => q{},
            }
        });
        $self->_dump_models_with_template
            ($template, $table_module, $template_name);
    }

    return;
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _get_template {
    my $self = shift;

    return Text::MicroTemplate::Extended->new(
        include_path => [
            $self->path->source_models->stringify,
        ],
        extension    => $self->path->module_extension,
    );
}

sub _get_template_name {
    my ($self, $table_module, $schema_file) = @_;

    return -f $self->path->source_models->file($table_module)
        ? $self->class->get_class_name_from_path_string($schema_file->basename)
        : $self->class->base_part;
}

sub _dump_models_with_template {
    my ($self, $template, $table_module, $template_name) = @_;

    my $handle = $self->path->target_models->file($table_module)->openw;
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

DBICx::Modeler::Generator::Model - Implement class for DBICx::Modeler::Generator::ModelLike

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=head1 METHODS

=head2 Generator

=head3 C<< $self->make_models() >>

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
