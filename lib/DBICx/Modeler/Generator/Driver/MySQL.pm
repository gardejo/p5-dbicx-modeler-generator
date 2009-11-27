package DBICx::Modeler::Generator::Driver::MySQL;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;
use MooseX::Orochi;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# base class(es)
# ****************************************************************

extends qw(
    DBICx::Modeler::Generator::Driver::Base
);


# ****************************************************************
# dependency injection
# ****************************************************************

bind_constructor '/DBICx/Modeler/Generator/Driver' => (
    args => {
        bin      => bind_value '/DBICx/Modeler/Generator/Driver/bin',
        dbd      => bind_value '/DBICx/Modeler/Generator/Driver/dbd',
        dbname   => bind_value '/DBICx/Modeler/Generator/Driver/dbname',
        dsn      => bind_value '/DBICx/Modeler/Generator/Driver/dsn',
        host     => bind_value '/DBICx/Modeler/Generator/Driver/host',
        password => bind_value '/DBICx/Modeler/Generator/Driver/password',
        port     => bind_value '/DBICx/Modeler/Generator/Driver/port',
        username => bind_value '/DBICx/Modeler/Generator/Driver/username',
        path     => bind_value '/DBICx/Modeler/Generator/Path',
        tree     => bind_value '/DBICx/Modeler/Generator/Tree',
    },
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_bin {
    return 'mysql';
}

sub _build_dbd {
    return 'mysql';
}

sub _build_command {
    my $self = shift;

    my $command = $self->bin;
    $command .= sprintf ' --user=%s', $self->username
        if defined $self->username;
    $command .= sprintf ' --password=%s', $self->password
        if defined $self->password;
    $command .= sprintf ' < "%s"', $self->path->creation_script->stringify;

    return $command;
}


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    DBICx::Modeler::Generator::DriverLike
);


# ****************************************************************
# compile-time process(es)
# ****************************************************************

__PACKAGE__->meta->make_immutable;


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

DBICx::Modeler::Generator::Driver::MySQL - Concrete implement class with MySQL for DBICx::Modeler::Generator::DriverLike

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

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
