package DBICx::Modeler::Generator::Model;


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

use File::Find::Rule;
use List::MoreUtils qw(uniq);
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

    my $extension = $self->path->module_extension;
    my $template  = $self->_get_template($extension);

    foreach my $target_module ( $self->_get_target_modules($extension) ) {
        my $template_name
            = $self->_get_template_name($target_module, $extension);

        $template->template_args({
            stash => {
                package => $self->class->get_fully_qualified_class_name(
                    $self->class->model,
                    $self->class->get_class_name_from_path_string
                        ($target_module),
                ),
            }
        });
        $self->_dump_models_with_template
            ($template, $target_module, $template_name, $extension);
    }

    return;
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _get_template {
    my ($self, $extension) = @_;

    return Text::MicroTemplate::Extended->new(
        include_path => [
            $self->path->source_models->stringify,
        ],
        extension    => $extension,
    );
}

sub _get_target_modules {
    my ($self, $extension) = @_;

    my @schema_modules = map {
        $_->basename
    } ($self->path->target_schemata->children);

    my $base_file = $self->class->base_part . $extension;
    my $rule = File::Find::Rule->new
                               ->relative
                               ->file
                               ->name('*' . $extension);
    my @model_modules = grep {
        $_ ne $base_file;
    } $rule->in($self->path->source_models->stringify);
    # $self->path->source_models->children does not find recursively

    return uniq @schema_modules, @model_modules;
}

sub _get_template_name {
    my ($self, $target_module, $extension) = @_;

    return -f $self->path->source_models->file($target_module)
        ? $self->_remove_extension($target_module, $extension)
        : $self->class->base_part;
}

sub _remove_extension {
    my ($self, $target_module, $extension) = @_;

    # It is not need that
    # $target_module =~ s{ \. pm \z }{}xms;
    # for modules from schemata
    $target_module =~ s{ $extension \z }{}xms;  # for modules from models

    return $target_module;
}

sub _dump_models_with_template {
    my ($self, $template, $target_module, $template_name) = @_;

    my $target_model_path = $self->path->target_models->file($target_module);
    $target_model_path->parent->mkpath;
    my $handle = $target_model_path->openw;
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

    use DBICx::Modeler::Generator::Model;

=head1 DESCRIPTION

This class is an implement class for
L<DBICx::Modeler::Generator::ModelLike|DBICx::Modeler::Generator::ModelLike>.

=head1 METHODS

=head2 Generator

=head3 C<< $self->make_models() >>

Loads and generates model modules.

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. Gardejo)

C<< <moriya at ermitejo dot com> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by MORIYA Masaki (a.k.a. Gardejo),
L<http://ttt.ermitejo.com>.

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
