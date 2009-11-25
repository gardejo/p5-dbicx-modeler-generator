#!/usr/bin/perl

use strict;
use warnings;

use inc::Module::Install;

my $application_root_module
    = 'lib/DBICx/Modeler/Generator.pm';

# ================================================================
# meta information
# ================================================================
# abstract, author, license, name, perl_version, version
all_from        $application_root_module;
perl_version    5.008_001;
version         "0.00";

# supplement
author          'MORIYA Masaki (a.k.a. "Gardejo") <moriya@cpan.org>';
resources (
    repository
        => 'git://github.com/gardejo/p5-dbicx-modeler-generator.git',
    bugtracker
        => undef,
    homepage
        => 'http://github.com/gardejo/p5-dbicx-modeler-generator',
);
# no_index directory => 'examples';
# no_index directory => 'extlib';

# ================================================================
# build dependencies
# ================================================================
build_requires  'Module::Install'       => '0.80'; # YAML::Tiny problem
build_requires  'Module::Load'          => '0';    # > perl 5.009_004

# ================================================================
# general dependencies
# ================================================================
  requires      'List::MoreUtils'       => '0';
  requires      'Memoize'               => '0';
  requires      'Moose'                 => '0.41';
  requires      'Sub::Name'             => '0';
  requires      'namespace::clean'      => '0.08'; # cf. MX-Types-DateTime

# ================================================================
# dependencies for tests
# ================================================================
  test_requires 'Test::Class'           => '0';    # without intention
  test_requires 'Test::Exception'       => '0.27'; # cf. MX-Types-DateTime
  test_requires 'Test::More'            => '0';    # without intention
  test_requires 'Test::Warn'            => '0';    # without intention

# ================================================================
# tests
# ================================================================
use_test_base;
  tests         't/*.t';
  author_tests  'xt';

# ================================================================
# installation
# ================================================================
auto_include;
auto_install;

# ================================================================
# META.yml writter
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
