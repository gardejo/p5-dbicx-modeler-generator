package DBICx::Modeler::Generator::Driver::Base;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'path' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::PathLike',
    required    => 1,
);

has 'tree' => (
    is          => 'ro',
    does        => 'DBICx::Modeler::Generator::TreeLike',
    required    => 1,
);

has [qw(bin dbd dbname dsn host)] => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
);

has [qw(username password)] => (
    is          => 'ro',
    isa         => 'Str',
);

has 'port' => (
    is          => 'ro',
    isa         => 'Int',
);

has 'command' => (
    is          => 'ro',
    isa         => 'Str',
    init_arg    => undef,
    lazy_build  => 1,
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @args) = @_;

    my $args = $class->$next(@args);

    foreach my $attribute (qw(
        bin dbd dbname dsn host port
    )) {
        delete $args->{$attribute}
            unless defined $args->{$attribute};
    }

    return $args;
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_dbname {
    my $self = shift;

    return $self->tree->application;
}

sub _build_dsn {
    my $self = shift;

    my $dsn = sprintf 'dbi:%s:dbname=%s', (
        $self->dbd,
        $self->dbname,
    );
    $dsn .= sprintf ';host=%s', $self->host
        if defined $self->host;
    $dsn .= sprintf ';port=%s', $self->port
        if defined $self->port;

    return $dsn;
}

sub _build_host {
    return 'localhost';
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub deploy_database {
    my $self = shift;

    system($self->command)
        and confess 'An error occurred during the database creation';

    return;
}


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

DBICx::Modeler::Generator::Driver::Base - Base inmplement class for DBICx::Modeler::Generator::DriverLike

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=head1 METHODS

=head2 Generator

=head3 C<< $self->deploy_database() >>

Deploys database with a creation script.

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
