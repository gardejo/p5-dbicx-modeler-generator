package Test::DBICx::Modeler::Generator;


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

use DBICx::Modeler;
use FindBin;
use Module::Load;
use Path::Class;
use Test::Exception;
use Test::Moose;
use Test::More;
use Test::Warn;


# ****************************************************************
# test(s)
# ****************************************************************

sub startup : Test(startup) {
    my $self = shift;

    $self->_set_environment;
    $self->_connect_database;
    $self->_get_generator;

    return;
}

sub _set_environment {
    my $self = shift;

    $self->{examples}
        = dir($FindBin::Bin)->parent->subdir('examples')->cleanup;
    $self->{has_means}
        = $self->_has_means;
    $self->{has_authority}
        = $self->_has_authority;
    $self->{target_library}
        = $self->{examples}->subdir(qw(lib))->relative;
    $self->{generated_library}
        = $self->{target_library}->subdir('MyApp');
    $self->{target_models}
        = $self->{target_library}->subdir(qw(MyApp Model));
    $self->{target_schemata}
        = $self->{target_library}->subdir(qw(MyApp Schema));
    $self->{target_model}
        = $self->{target_library}->subdir(qw(MyApp))->file('Model.pm');
    $self->{target_schema}
        = $self->{target_library}->subdir(qw(MyApp))->file('Schema.pm');

    return;
}

sub _has_authority {
    my $self = shift;

    return -w $self->{examples}->stringify;
}

sub shutdown : Test(shutdown => no_plan) {
    my $self = shift;

    if ($self->{has_tables}) {
        if ($self->_can_support_foreign_keys) {
            $self->_test_generated_models;
        }
        $self->_remove_generated_database;
        $self->_disconnect_database;
    }
    $self->_clean_up_database;
    $self->_remove_generated_modules;

    return;
}

sub _remove_generated_modules {
    my $self = shift;

    $self->{generated_library}->rmtree
        if $self->{has_authority};

    return;
}

sub test_generator : Tests(no_plan) {
    my $self = shift;

    isa_ok $self->{generator}, 'DBICx::Modeler::Generator';

    return;
}

sub test_class : Tests(no_plan) {
    my $self = shift;

    my $class = $self->{generator}->class;
    isa_ok $class, 'DBICx::Modeler::Generator::Class';
    does_ok $class, 'DBICx::Modeler::Generator::ClassLike';

    is $class->application, 'MyApp'
        => 'class: application ok';
    is $class->base_part, 'Base'
        => 'class: base_part ok';
    is $class->model_part, 'Model'
        => 'class: model_part ok';
    is $class->schema_part, 'Schema'
        => 'class: schema_part ok';
    is $class->model, 'MyApp::Model'
        => 'class: model ok';
    is $class->schema, 'MyApp::Schema'
        => 'class: schema ok';
    is_deeply $class->route_to_model, [qw(MyApp Model)]
        => 'class: route_to_model ok';
    is_deeply $class->route_to_schema, [qw(MyApp Schema)]
        => 'class: route_to_schema ok';

    return;
}

sub test_path : Tests(no_plan) {
    my $self = shift;

    my $path = $self->{generator}->path;
    isa_ok $path, 'DBICx::Modeler::Generator::Path';
    does_ok $path, 'DBICx::Modeler::Generator::PathLike';

    is $path->root->stringify,
        $self->{examples}->relative->stringify
            => 'path: root ok';

    my $source_library = $self->{examples}->subdir(qw(src lib))->relative;
    is $path->source_library->stringify,
        $source_library->stringify
            => 'path: source_library ok';

    is $path->target_library->stringify,
        $self->{target_library}->stringify
            => 'path: target_library ok';

    my $source_models = $source_library->subdir(qw(MyApp Model));
    is $path->source_models->stringify,
        $source_models->stringify
            => 'path: source_models ok';
    my $source_schemata = $source_library->subdir(qw(MyApp Schema));
    is $path->source_schemata->stringify,
        $source_schemata->stringify
            => 'path: source_schemata ok';

    is $path->target_models->stringify,
        $self->{target_models}->stringify
            => 'path: target_models ok';
    is $path->target_schemata->stringify,
        $self->{target_schemata}->stringify
            => 'path: target_schemata ok';

    my $source_model = $source_library->subdir(qw(MyApp))->file('Model.pm');
    is $path->source_model->stringify,
        $source_model->stringify
            => 'path: source_model ok';
    my $source_schema = $source_library->subdir(qw(MyApp))->file('Schema.pm');
    is $path->source_schema->stringify,
        $source_schema->stringify
            => 'path: source_schema ok';
    is $path->target_model->stringify,
        $self->{target_model}->stringify
            => 'path: target_model ok';
    is $path->target_schema->stringify,
        $self->{target_schema}->stringify
            => 'path: target_schema ok';

    $self->_test_path_of_creation_script($path, $source_library);

    return;
}

sub test_schema : Tests(no_plan) {
    my $self = shift;

    my $schema = $self->{generator}->schema;
    isa_ok $schema, 'DBICx::Modeler::Generator::Schema';
    does_ok $schema, 'DBICx::Modeler::Generator::SchemaLike';

    is_deeply $schema->components, []
        => 'schema: components ok';
    ok ! $schema->is_debug
        => 'schema: is_debug ok';

    return;
}

sub test_tree : Tests(no_plan) {
    my $self = shift;

    my $tree = $self->{container}->get('/DBICx/Modeler/Generator/Tree');
    isa_ok $tree, 'DBICx::Modeler::Generator::Tree';
    does_ok $tree, 'DBICx::Modeler::Generator::TreeLike';

    is_deeply $tree->source, [qw(src)]
        => 'tree: source ok';
    is_deeply $tree->target, [qw()]
        => 'tree: target ok';
    is_deeply $tree->library, [qw(lib)]
        => 'tree: library ok';
    is_deeply $tree->source_library, [qw(src lib)]
        => 'tree: source_library ok';
    is_deeply $tree->target_library, [qw(lib)]
        => 'tree: target_library ok';
    is_deeply $tree->model, [qw(MyApp Model)]
        => 'tree: model ok';
    is_deeply $tree->source_model, [qw(src lib MyApp Model)]
        => 'tree: source_model ok';
    is_deeply $tree->target_model, [qw(lib MyApp Model)]
        => 'tree: target_model ok';
    is_deeply $tree->schema, [qw(MyApp Schema)]
        => 'tree: schema ok';
    is_deeply $tree->source_schema, [qw(src lib MyApp Schema)]
        => 'tree: source_schema ok';
    is_deeply $tree->target_schema, [qw(lib MyApp Schema)]
        => 'tree: target_schema ok';

    return;
}

sub test_as_blackbox : Tests(no_plan) {
    my $self = shift;

    SKIP: {
        skip "You have no means to operate a database "
           . "via command line interface"
            unless $self->{has_means};
        skip "You have no authority to make the database"
            unless $self->{has_authority};
        skip "could not connect to the database"
            unless $self->{dbh};
        skip "'myapp' database already exists"
            if $self->_exists_database;
        $self->{has_tables} = 1;

        warning_is {
            lives_ok {
                $self->{generator}->deploy_database;
            } 'no exception to deploy_database';
        } undef, 'no warning to deploy_database';
        ok $self->_exists_database
            => 'database exists';

        # note: test should ignore result of warning_is only
        # TODO: {
        #     local $TODO = 'Test::Warn ignore that STDERR was hijacked';
        #     warning_is {
                lives_ok {
                    $self->{generator}->update_schemata;
                } 'no exception to update_schemata';
        #     } undef, 'no warning to update_schemata';
        # };
        $self->_test_existence_of_schemata;
        $self->_test_meta_information_of_schema_modules;

        warning_is{
            lives_ok {
                $self->{generator}->update_models;
            } 'no exception to update_models';
        } undef, 'no warning to update_models';
        $self->_test_existence_of_models;
        $self->_test_meta_information_of_model_modules;
    };

    return;
}

sub _test_existence_of_schemata {
    my $self = shift;

    ok -f $self->{target_schema}->stringify
        => 'schema module was generated: examples/lib/MyApp/Schema.pm';
    ok -d $self->{target_schemata}->stringify
        => 'schema directory was generated: examples/lib/MyApp/Schema';
    ok -f $self->{target_schemata}->file('Artist.pm')->stringify
        => 'schema module was generated: examples/MyApp/Schema/Artist.pm';
    ok -f $self->{target_schemata}->file('Cd.pm')->stringify
        => 'schema module was generated: examples/lib/MyApp/Schema/Cd.pm';
    ok -f $self->{target_schemata}->file('Track.pm')->stringify
        => 'schema module was generated: examples/lib/MyApp/Schema/Track.pm';

    return;
}

sub _test_meta_information_of_schema_modules {
    my $self = shift;

    unshift @INC, $self->{target_library}->stringify;

    use_ok 'MyApp::Schema';
    isa_ok 'MyApp::Schema', 'DBIx::Class::Schema';

    foreach my $class (qw(
        MyApp::Schema::Artist
        MyApp::Schema::Cd
        MyApp::Schema::Track
    )) {
        use_ok $class;
        isa_ok $class, 'DBIx::Class';
    }

    can_ok 'MyApp::Schema::Artist', 'birthday';
    can_ok 'MyApp::Schema::Track', 'recording_time';

    shift @INC;

    return;
}

sub _test_existence_of_models {
    my $self = shift;

    # note: MyApp::Model was not generated by DBICx::Modeler::Generator
    ok -d $self->{target_models}->stringify
        => 'model directory was generated: examples/lib/MyApp/Model';
    ok -f $self->{target_models}->file('Artist.pm')->stringify
        => 'model module was generated: examples/lib/MyApp/Model/Artist.pm';
    ok -d $self->{target_models}->subdir('Artist')->stringify
        => 'model sub directory was generated: examples/lib/MyApp/Model/Artist';
    ok -f $self->{target_models}->subdir('Artist')->file('Rock.pm')->stringify
        => 'model module was generated: examples/MyApp/Model/Artist/Rock.pm';
    ok -f $self->{target_models}->file('Cd.pm')->stringify
        => 'model module was generated: examples/lib/MyApp/Model/Cd.pm';
    ok -f $self->{target_models}->file('Track.pm')->stringify
        => 'model module was generated: examples/lib/MyApp/Model/Track.pm';

    return;
}

sub _test_meta_information_of_model_modules {
    my $self = shift;

    unshift @INC, $self->{target_library}->stringify;

    foreach my $class (qw(
        MyApp::Model::Artist
        MyApp::Model::Artist::Rock
        MyApp::Model::Cd
        MyApp::Model::Track
    )) {
        use_ok $class;
        load $class;
        does_ok $class, 'DBICx::Modeler::Does::Model';
    }

    isa_ok 'MyApp::Model::Artist::Rock', 'MyApp::Model::Artist';

    can_ok 'MyApp::Model::Artist::Rock', 'dance';
    can_ok 'MyApp::Model::Cd', 'price';
    can_ok 'MyApp::Model::Cd', 'play';
    # instead of code below:
    # ok $class->meta->has_method($method) => "$class has method '$method'";

    shift @INC;

    return;
}

sub _test_generated_models {
    my $self = shift;

    unshift @INC, $self->{target_library}->stringify;

    load 'MyApp';

    $self->_reconnect_database;

    my $modeler = MyApp->modeler($self->{connect_info});
    isa_ok $modeler, 'DBICx::Modeler';

    my ($artist, $cd, $track);
    warning_is {
        lives_ok {
            $artist = $modeler->create( Artist => {
                name             => 'Foo',
                insert_date_time => '0000-00-00 00:00:00',
            } );
        } 'no exception to artist creation';
    } undef, 'no warning to artist creation';
    warning_is {
        lives_ok {
            $cd = $artist->create_related( cds => {
                title            => 'Bar',
                insert_date_time => '0000-00-00 00:00:00',
            } );
        } 'no exception to cd creation';
    } undef, 'no warning to cd creation';
    warning_is {
        lives_ok {
            $track = $cd->create_related( tracks => {
                title            => 'Baz',
                insert_date_time => '0000-00-00 00:00:00',
            } );
        } 'no exception to track creation';
    } undef, 'no warning to track creation';

    shift @INC;

    return;
}


# ****************************************************************
# return trule
# ****************************************************************

1;
__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

Test::DBICx::Modeler::Generator - Tests for DBICx::Modeler::Generator

=head1 SYNOPSIS

    package Test::DBICx::Modeler::Generator::Manual;

    use base qw(
        Test::DBICx::Modeler::Generator
    );

=head1 DESCRIPTION

This class is a base class of C<Test::DBICx::Modeler::Generator::*>.

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
