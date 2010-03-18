package Test::DBICx::Modeler::Generator::Supplement;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# base class(es)
# ****************************************************************

use base qw(
    Test::Class
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use FindBin;
use Module::Load;
use Orochi;
use Path::Class;
use Test::Exception;
use Test::More;
use Test::Requires {
    'DBD::mysql' => 0,
};


# ****************************************************************
# test(s)
# ****************************************************************

sub startup : Test(startup) {
    my $self = shift;

    $self->{examples}
        = file($FindBin::Bin)->parent->subdir('examples')->relative->cleanup;

    return;
}

sub setup : Test(setup) {
    my $self = shift;

    $self->{container} = Orochi->new;
    $self->{container}->inject_literal
        ('/DBICx/Modeler/Generator/Class/application' => 'Foo::Bar');
    $self->{container}->inject_literal
        ('/DBICx/Modeler/Generator/Path/root' => 'examples');

    return;
}

sub _inject_dependencies {
    my ($self, $driver) = @_;

    $driver ||= 'SQLite';

    foreach my $class (
        qw(
            DBICx::Modeler::Generator::Class
            DBICx::Modeler::Generator::Path
            DBICx::Modeler::Generator::Tree
        ),
        'DBICx::Modeler::Generator::Driver::' . $driver
    ) {
        $self->{container}->inject_class($class);
    }

    return;
}

sub test_get_full_path : Test(no_plan) {
    my $self = shift;

    $self->_inject_dependencies;
    $self->{path}
        = $self->{container}->get('/DBICx/Modeler/Generator/Path');

    throws_ok {
        $self->{path}->get_full_path();
    } qr{Could not get full path} => 'exception to get_full_path';

    return;
}

sub test_supplements_of_mysql_command : Test(no_plan) {
    my $self = shift;

    $self->_inject_dependencies('MySQL');
    $self->{driver}
        = $self->{container}->get('/DBICx/Modeler/Generator/Driver');
    my $command = sprintf 'mysql < "%s"',
        $self->{examples}->subdir('src')->file('foo_bar.sql')->stringify;
    is $self->{driver}->command, $command
        => 'driver: command ok (without username and password)';

    return;
}

sub test_supplements_of_mysql_deploy_database : Test(no_plan) {
    my $self = shift;

    $self->_inject_dependencies('MySQL::Test');
    $self->{driver}
        = $self->{container}->get('/DBICx/Modeler/Generator/Driver');

    # my $driver_class = ref $self->{driver};
    # $driver_class->meta->make_mutable;
    # $driver_class->meta->add_override_method_modifier('_build_command', sub {
    #     return 'mysql --unknown_option_foo_bar_42';
    # });
    # $driver_class->meta->make_immutable;

    dies_ok {
        $self->{driver}->deploy_database;
    } 'exception to deploy_database (without a command string)';

    return;
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

Test::DBICx::Modeler::Generator::Supplement - Supplemental tests for DBICx::Modeler::Generator

=head1 SYNOPSIS

    use Test::DBICx::Modeler::Generator::Supplement;

    Test::DBICx::Modeler::Generator::Supplement->runtests;

=head1 DESCRIPTION

This class provides supplemental tests for C<DBICx::Modeler::Generator>.

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
