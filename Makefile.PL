#!/usr/bin/perl

use strict;
use warnings;

use inc::Module::Install;

# ================================================================
# gathering meta information
# ================================================================
    # abstract, author, license, name, perl_version, version
    all_from        'lib/DBICx/Modeler/Generator.pm';

    # supplement
    author          'MORIYA Masaki (a.k.a. Gardejo) <moriya@cpan.org>';
    resources (
        repository
            => 'git://github.com/gardejo/p5-dbicx-modeler-generator.git',
        bugtracker
            => 'http://rt.cpan.org/Public/Dist/Display.html?Name='
             . 'DBICx-Modeler-Generator',
        homepage
            => 'http://github.com/gardejo/p5-dbicx-modeler-generator',
    );

    no_index directory => 'examples';
#   no_index directory => 'extlib';

# ================================================================
# build dependency(-ies)
# ================================================================
    build_requires  'Module::Install'               => '0.80';
        # to avoid YAML::Tiny problem
    build_requires  'Module::Load'                  => '0';
        # is in perl 5.009_004

# ================================================================
# general dependency(-ies)
# ================================================================
    requires        'Class::Unload'                 => '0';
    requires        'DBICx::Modeler'                => '0.005';
        # to avoid clone problem
    requires        'DBIx::Class::Schema::Loader'   => '0';
    requires        'File::Find::Rule'              => '0';
#   requires        'List::MoreUtils'               => '0';
        # was included by Moose
    requires        'Module::Load'                  => '0';
    requires        'Moose'                         => '0.89_01';
        # for Moose::Meta::Attribute::Native
#   requires        'MooseX::Orochi'                => '0';
        # was included by Orochi
    requires        'MooseX::Types::Path::Class'    => '0';
    requires        'Orochi'                        => '0';
    requires        'Text::MicroTemplate::Extended' => '0';
    requires        'namespace::clean'              => '0.08';
        # cf. MooseX-Types-DateTime

# ================================================================
# optional dependency(-ies)
# ================================================================
    features (
        'Support MySQL driver' => [
            -default => 0,
            recommends( 'DBD::mysql' => '0' ),
        ],
        'Support SQLite driver' => [
            -default => 0,
            recommends( 'DBD::SQLite' => '0' ),
        ],
        'Support SQLite driver with foreign keys' => [
            -default => 0,
            recommends( 'DBD::SQLite' => '1.26_06' ),
        ],
        'Support Getopt interface' => [
            -default => 0,
            recommends( 'MooseX::Getopt'       => '0' ),
            recommends( 'MooseX::SimpleConfig' => '0' ),
        ],
    );

# ================================================================
# test dependency(-ies)
# ================================================================
#   test_requires   'Perl::Critic'                  => '0.094';
        # for author tests
#   test_requires   'Test::CPAN::Meta'              => '0.12';
        # for author tests
    test_requires   'Test::Class'                   => '0';
    test_requires   'Test::Exception'               => '0.27';
        # cf. MooseX-Types-DateTime
#   test_requires   'Test::Kwalitee'                => '0';
        # for author tests
#   test_requires   'Test::Moose'                   => '0';
        # was included by Moose
    test_requires   'Test::More'                    => '0';
#   test_requires   'Test::mysqld'                  => '0';
#   test_requires   'Test::NoTabs'                  => '0';
        # for author tests
#   test_requires   'Test::Perl::Critic'            => '0';
        # for author tests
#   test_requires   'Test::Pod'                     => '1.40';
        # for author tests
#   test_requires   'Test::Pod::Coverage'           => '1.08';
        # for author tests
    test_requires   'Test::Requires'                => '0';
#   test_requires   'Test::Synopsis'                => '0.06';
        # for author tests
#   test_requires   'Test::UseAllModules'           => '0';
        # for author tests
    test_requires   'Test::Warn'                    => '0';

# ================================================================
# test(s)
# ================================================================
    use_test_base;
    tests           't/*.t';
    author_tests    'xt';

# ================================================================
# installation
# ================================================================
    auto_include;
    auto_install;

# ================================================================
# writter
# ================================================================
    WriteAll;

__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

Makefile.PL - Makefile builder for DBICx-Modeler-Generator

=head1 SYNOPSIS

    $ cpan -t .

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. Gardejo)

C<< <moriya@cpan.org> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by MORIYA Masaki (a.k.a. Gardejo),
L<http://ttt.ermitejo.com>.

This distribution is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
