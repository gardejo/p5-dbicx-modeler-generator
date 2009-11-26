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
    author          'MORIYA Masaki (a.k.a. "Gardejo") <moriya@cpan.org>';
    resources (
        repository
            => 'git://github.com/gardejo/p5-dbicx-modeler-generator.git',
        bugtracker
            => 'http://github.com/gardejo/p5-dbicx-modeler-generator/issues',
        homepage
            => 'http://github.com/gardejo/p5-dbicx-modeler-generator',
    );

    no_index directory => 'examples';
#   no_index directory => 'extlib';

# ================================================================
# general dependency(-ies)
# ================================================================
    requires        'Class::Unload'                 => '0';
    requires        'DBIx::Class::Schema::Loader'   => '0';
    requires        'DBICx::Modeler'                => '0.005';
        # to avoid clone problem
    requires        'Module::Load'                  => '0';
    requires        'Moose'                         => '0.89_01';
        # for Moose::Meta::Attribute::Native
    requires        'MooseX::Orochi'                => '0';
    requires        'MooseX::Types::Path::Class'    => '0';
    requires        'Orochi'                        => '0';
#   requires        'Text::MicroTemplate'           => '0';
    requires        'Text::MicroTemplate::Extended' => '0';
    requires        'namespace::clean'              => '0.08';
        # cf. MooseX-Types-DateTime

# ================================================================
# test dependency(-ies)
# ================================================================
    test_requires   'Test::Class'                   => '0';
    test_requires   'Test::Exception'               => '0.27';
        # cf. MooseX-Types-DateTime
    test_requires   'Test::More'                    => '0';
    test_requires   'Test::Warn'                    => '0';

# ================================================================
# build dependency(-ies)
# ================================================================
    build_requires  'Module::Install'               => '0.80';
        # to avoid YAML::Tiny problem
    build_requires  'Module::Load'                  => '0';
        # is in perl 5.009_004

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

=item MORIYA Masaki (a.k.a. "Gardejo")

C<< <moriya@cpan.org> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by MORIYA Masaki (a.k.a. "Gardejo"),
L<http://ttt.ermitejo.com>.

This library is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl> and L<perlartistic>.

=cut
