use inc::Module::Install 0.95;
use Module::Install::AuthorRequires;
use Module::Install::AuthorTests;

# ================================================================
# gathering meta information
# ================================================================
    # individual gathering
    author          'MORIYA Masaki, alias Gardejo <moriya at cpan dot org>';
    resources (
        repository
            => 'git://github.com/gardejo/p5-dbicx-modeler-generator.git',
        # (implicit assignment)
        # bugtracker
        #     => 'http://rt.cpan.org/Public/Dist/Display.html?Name='
        #      . 'DBICx-Modeler-Generator',
        homepage
            => 'http://github.com/gardejo/p5-dbicx-modeler-generator',
    );

    # the rest of information
    # abstract, author, license, name, perl_version(5.008_001), version
    all_from        'lib/DBICx/Modeler/Generator.pm';

    no_index directory => 'examples';
#   no_index directory => 'extlib';

# ================================================================
# build dependency(-ies)
# ================================================================
#   build_requires  'Module::Install'                   => '0.80';
        # to avoid YAML::Tiny problem
#   build_requires  'Module::Load'                      => '0';
        # is in perl 5.009_004

# ================================================================
# general dependency(-ies)
# ================================================================
    requires        'Class::Unload'                     => '0';
    requires        'DBICx::Modeler'                    => '0.005';
        # to avoid clone problem
    requires        'DBIx::Class::Schema::Loader'       => '0';
    requires        'File::Find::Rule'                  => '0';
    requires        'List::MoreUtils'                   => '0';
        # was included by Moose
        # (but Kwalitee scorer blames implicit prerequirement)
    requires        'Module::Load'                      => '0';
    requires        'Moose'                             => '0.89_01';
        # for Moose::Meta::Attribute::Native
#   requires        'MooseX::Orochi'                    => '0';
        # was included by Orochi
    requires        'MooseX::Types::Path::Class'        => '0';
    requires        'Orochi'                            => '0';
    requires        'Text::MicroTemplate::Extended'     => '0';
    requires        'namespace::clean'                  => '0.08';
        # cf. MooseX-Types-DateTime

# ================================================================
# optional dependency(-ies)
# ================================================================
    features (
        'Support MySQL driver' => [
            -default => 0,
            recommends( 'DBD::mysql'                        => '0' ),
        ],
        'Support SQLite driver' => [
            -default => 0,
            recommends( 'DBD::SQLite'                       => '0' ),
        ],
        'Support SQLite driver with foreign keys' => [
            -default => 0,
            recommends( 'DBD::SQLite'                       => '1.26_06' ),
        ],
        'Support Getopt interface' => [
            -default => 0,
            recommends( 'MooseX::Getopt'                    => '0' ),
            recommends( 'MooseX::SimpleConfig'              => '0' ),
        ],
    );

# ================================================================
# test dependency(-ies)
# ================================================================
    test_requires   'Test::Class'                       => '0.34';
        # to avoid Devel::Symdump
    test_requires   'Test::Exception'                   => '0.27';
        # cf. MooseX-Types-DateTime
#   test_requires   'Test::Moose'                       => '0';
        # was included by Moose
    test_requires   'Test::More'                        => '0';
    test_requires   'Test::Requires'                    => '0';
    test_requires   'Test::Warn'                        => '0';

# ================================================================
# author dependency(-ies)
# ================================================================
    author_requires 'Perl::Critic'                      => '0.094';
    author_requires 'Test::CPAN::Meta'                  => '0.12';
#   author_requires 'Test::Kwalitee'                    => '0';
        # always die (but xt/kwalitee.t need it)
    author_requires 'Test::NoTabs'                      => '0';
    author_requires 'Test::Perl::Critic'                => '0';
    author_requires 'Test::Pod'                         => '1.40';
    author_requires 'Test::Pod::Coverage'               => '1.08';
    author_requires 'Test::Synopsis'                    => '0.06';
    author_requires 'Test::UseAllModules'               => '0';

# ================================================================
# test(s)
# ================================================================
    tests                   't/*.t';
    recursive_author_tests  'xt';

# ================================================================
# including
# ================================================================
    auto_include_deps;
    # 'auto_include' grabs only immediate dependencies

# ================================================================
# installation
# ================================================================
#   auto_install;
    # 'auto_install' is deprecated

# ================================================================
# writter
# ================================================================
    WriteAll;
