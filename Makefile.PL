# ****************************************************************
# subroutine(s)
# ****************************************************************

sub author_requires {
    warn 'You need to install Module::Install::AuthorRequires '
       . 'to install modules author requires';

    return;
}

sub recursive_author_tests {
    return;
}


# ****************************************************************
# main routine
# ****************************************************************

use inc::Module::Install 0.95;

# ================================================================
# gathering meta information
# ================================================================
# individual gathering
author(
    'MORIYA Masaki, alias Gardejo <moriya at cpan dot org>'
);
resources(
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
all_from(
    'lib/DBICx/Modeler/Generator.pm'
);

no_index directory => (
    'examples',
#   'extlib',
);

# ================================================================
# general dependency(-ies)
# ================================================================
requires(
    'Class::Unload'                     => '0',
    'DBICx::Modeler'                    => '0.005',
        # to avoid clone problem
    'DBIx::Class::Schema::Loader'       => '0',
    'File::Find::Rule'                  => '0',
    'List::MoreUtils'                   => '0',
        # was included by Moose
        # (but Kwalitee scorer blames implicit prerequirement)
    'Module::Load'                      => '0',
    'Moose'                             => '0.89_01',
        # for Moose::Meta::Attribute::Native
#   'MooseX::Orochi'                    => '0',
        # was included by Orochi
    'MooseX::Types::Path::Class'        => '0',
    'Orochi'                            => '0',
    'Text::MicroTemplate::Extended'     => '0',
    'namespace::clean'                  => '0.08',
        # cf. MooseX-Types-DateTime
);

# ================================================================
# optional dependency(-ies)
# ================================================================
features(
    'Support MySQL driver' => [
        -default => 0,
        recommends(
            'DBD::mysql'                        => '0',
        ),
    ],
    'Support SQLite driver' => [
        -default => 0,
        recommends(
            'DBD::SQLite'                       => '0',
        ),
    ],
    'Support SQLite driver with foreign keys' => [
        -default => 0,
        recommends(
            'DBD::SQLite'                       => '1.26_06',
        ),
    ],
    'Support Getopt interface' => [
        -default => 0,
        recommends(
            'MooseX::Getopt'                    => '0',
            'MooseX::SimpleConfig'              => '0',
        ),
    ],
);

# ================================================================
# build dependency(-ies)
# ================================================================
build_requires(
);

# ================================================================
# test dependency(-ies)
# ================================================================
test_requires(
    'Test::Class'                       => '0.34',
    'Test::Exception'                   => '0.27',
        # cf. MooseX-Types-DateTime
#   'Test::Moose'                       => '0',
        # was included by Moose
    'Test::More'                        => '0',
    'Test::Requires'                    => '0',
    'Test::Warn'                        => '0',
);

# ================================================================
# install dependency(-ies)
# ================================================================
install_requires(
);

# ================================================================
# author dependency(-ies) : Module::Install::AuthorRequires
# ================================================================
author_requires(
    'Module::Install::AuthorTests'      => '0',
    'Perl::Critic'                      => '0.094',
    'Test::CPAN::Meta'                  => '0.12',
#   'Test::Kwalitee'                    => '0',
        # is always die (but xt/kwalitee.t need it)
    'Test::NoTabs'                      => '0',
    'Test::Perl::Critic'                => '0',
    'Test::Pod'                         => '1.40',
    'Test::Pod::Coverage'               => '1.08',
    'Test::Synopsis'                    => '0.06',
    'Test::UseAllModules'               => '0',
);

# ================================================================
# test(s)
# ================================================================
tests(
    't/*.t'
);
recursive_author_tests(
    'xt'
);

# ================================================================
# including
# ================================================================
auto_include_deps();
    # 'auto_include' grabs only immediate dependencies

# ================================================================
# installation
# ================================================================
# auto_install();
    # 'auto_install' is deprecated

# ================================================================
# writter
# ================================================================
WriteAll();
