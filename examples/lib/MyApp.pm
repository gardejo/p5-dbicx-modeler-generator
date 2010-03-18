package MyApp;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use DBICx::Modeler;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use MyApp::Schema;


# ****************************************************************
# public method(s)
# ****************************************************************

sub schema {
    my ($class, $dsn, $username, $password, $option) = @_;

    $option ||= {};
    %$option = %$option, (
        # cf. "Don't use DBIx::Class::UTF8Columns",
        # http://perl-users.jp/articles/advent-calendar/2009/hacker/04.html
        # sqlite_unicode    => 1,                     # DBD::SQLite
        # unicode           => 1,                     # DBD::SQLite <1.26
        # mysql_enable_utf8 => 1,                     # DBD::mysql
        # on_connect_do     => ['SET NAMES utf8'],    # DBD::mysql
    );

    return MyApp::Schema->connect($dsn, $username, $password, $option);
}

sub modeler {
    my ($self, $schema_or_connect_info, @options) = @_;

    return DBICx::Modeler->new(
        schema    => (
            ref $schema_or_connect_info eq 'ARRAY'
                ? $self->schema(@$schema_or_connect_info)
                : $schema_or_connect_info
        ),
        namespace => '+MyApp::Model',
        @options,
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

MyApp - Sample application for DBICx::Modeler::Generator

=head1 SYNOPSIS

    use MyApp;

=head1 DESCRIPTION

This class is a sample application for
L<DBICx::Modeler::Generator|DBICx::Modeler::Generator>.

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
