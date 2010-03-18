package Test::DBICx::Modeler::Generator::Manual;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Orochi;


# ****************************************************************
# test(s)
# ****************************************************************

sub _get_generator {
    my $self = shift;

    $self->{container} = Orochi->new;

    $self->_inject_literals;
    $self->_inject_classes;

    $self->{generator} = $self->{container}->get('/DBICx/Modeler/Generator');

    return;
}

sub _inject_literals {
    my $self = shift;

    my %literal = (
        '/Class/application' => 'MyApp',
        '/Path/root'         => 'examples',
        $self->_get_special_literals,
    );

    while (my ($registry, $value) = each %literal) {
        $self->{container}->inject_literal
            ('/DBICx/Modeler/Generator' . $registry => $value);
    }

    return;
}

sub _inject_classes {
    my $self = shift;

    foreach my $class ($self->_get_injecting_classes) {
        $self->{container}->inject_class($class);
    }

    return;
}

sub _get_injecting_classes {
    my $self = shift;

    return (
        qw(
            DBICx::Modeler::Generator
            DBICx::Modeler::Generator::Class
            DBICx::Modeler::Generator::Model
            DBICx::Modeler::Generator::Path
            DBICx::Modeler::Generator::Schema
            DBICx::Modeler::Generator::Tree
        ), $self->_get_driver_class
    );
}


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

Test::DBICx::Modeler::Generator::Manual - Base class of Test::DBICx::Modeler::Generator::Manual::*

=head1 SYNOPSIS

    package Test::DBICx::Modeler::Generator::Manual::SQLite;

    use base qw(
        Test::DBICx::Modeler::Generator::Manual
        Test::DBICx::Modeler::Generator::SQLite
    );

=head1 DESCRIPTION

This class is a base class of C<Test::DBICx::Modeler::Generator::Manual::*>.

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
