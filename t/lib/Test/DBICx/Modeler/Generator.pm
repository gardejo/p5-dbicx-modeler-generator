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

use FindBin;
use Module::Load;
use Path::Class;
use Test::Exception;
use Test::More;


# ****************************************************************
# test(s)
# ****************************************************************

sub startup : Test(startup) {
    my $self = shift;

    $self->_set_environment;
    $self->_connect_database;

    return;
}

sub _set_environment {
    my $self = shift;

    $self->{examples}
        = dir($FindBin::Bin)->parent->subdir('examples')->cleanup;
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

sub teardown : Test(shutdown) {
    my $self = shift;

    $self->_disconnect_database;
    $self->_remove_generated_database;
    $self->_remove_generated_modules;

    return;
}

sub _remove_generated_modules {
    my $self = shift;

    eval {
        $self->{generated_library}->rmtree;
    } if $self->{has_authority};

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
    ok $class->meta->does_role('DBICx::Modeler::Generator::ClassLike');

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
        => 'class: model ok';
    is_deeply $class->route_to_schema, [qw(MyApp Schema)]
        => 'class: schema ok';

    return;
}

sub test_path : Tests(no_plan) {
    my $self = shift;

    my $path = $self->{generator}->path;
    isa_ok $path, 'DBICx::Modeler::Generator::Path';
    ok $path->meta->does_role('DBICx::Modeler::Generator::PathLike');

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
    ok $schema->meta->does_role('DBICx::Modeler::Generator::SchemaLike');

    is_deeply $schema->components, [qw(UTF8Columns)]
        => 'schema: components ok';
    isnt $schema->is_debug
        => 'schema: is_debug ok';

    return;
}

sub test_tree : Tests(no_plan) {
    my $self = shift;

    my $tree = $self->{container}->get('/DBICx/Modeler/Generator/Tree');
    isa_ok $tree, 'DBICx::Modeler::Generator::Tree';
    ok $tree->meta->does_role('DBICx::Modeler::Generator::TreeLike');

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
        skip "You have no authority to make database", 4
            unless $self->{has_authority};

        lives_ok {
            $self->{generator}->deploy_database;
        } 'deploy_database: ok';
        ok $self->_exists_database
            => 'database file exists';

        lives_ok {
            $self->{generator}->update_schemata;
        } 'update_schemata: ok';
        $self->_test_existence_of_schemata;
        $self->_test_meta_information_of_schema_modules;

        lives_ok {
            $self->{generator}->update_models;
        } 'update_models: ok';
        $self->_test_existence_of_models;
        $self->_test_meta_information_of_model_modules
    };

    return;
}

sub _test_existence_of_schemata {
    my $self = shift;

    ok -f $self->{target_schema}->stringify
        => 'generated: MyApp::Schema';
    ok -d $self->{target_schemata}->stringify
        => 'generated: MyApp::Schema::*';
    ok -f $self->{target_schemata}->file('Artist.pm')->stringify
        => 'generated: MyApp::Schema::Artist';
    ok -f $self->{target_schemata}->file('Cd.pm')->stringify
        => 'generated: MyApp::Schema::Cd';
    ok -f $self->{target_schemata}->file('Track.pm')->stringify
        => 'generated: MyApp::Schema::Track';

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
        => 'generated: MyApp::Model::*';
    ok -f $self->{target_models}->file('Artist.pm')->stringify
        => 'generated: MyApp::Model::Artist';
    ok -d $self->{target_models}->subdir('Artist')->stringify
        => 'generated: MyApp::Model::Artist::*';
    ok -f $self->{target_models}->subdir('Artist')->file('Rock.pm')->stringify
        => 'generated: MyApp::Model::Artist::Rock';
    ok -f $self->{target_models}->file('Cd.pm')->stringify
        => 'generated: MyApp::Model::Cd';
    ok -f $self->{target_models}->file('Track.pm')->stringify
        => 'generated: MyApp::Model::Track';

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
        ok $class->meta->does_role('DBICx::Modeler::Does::Model')
            => "$class does 'DBICx::Modeler::Does::Model' role";
    }

    isa_ok 'MyApp::Model::Artist::Rock', 'MyApp::Model::Artist';

    ok MyApp::Model::Artist::Rock->meta->has_method('dance')
        => "MyApp::Model::Artist::Rock has method 'dance'";
    ok MyApp::Model::Cd->meta->has_attribute('price')
        => "MyApp::Model::Cd has attribute 'price'";
    ok MyApp::Model::Cd->meta->has_method('play')
        => "MyApp::Model::Cd has method 'play'";

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

=head1 TO DO

=over 4

=item *

Using L<Test::Moose> to test meta information.

=back

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
