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
    my $class = shift;

    return MyApp::Schema->connect(@_);
}

sub modeler {
    my $self = shift;

    return DBICx::Modeler->new(
        schema    => $self->schema,
        namespace => '+MyApp::Model',
        @_,
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

This class is a sample application for L<DBICx::Modeler::Generator>.

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
