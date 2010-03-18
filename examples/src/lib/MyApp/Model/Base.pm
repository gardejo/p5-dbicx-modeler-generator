package <?= $stash->{package} ?>;

use DBICx::Modeler::Model;
<? block code => '' ?>
1;

__END__

=pod

=head1 NAME

<?= $stash->{package} ?> -

=head1 SYNOPSIS

    use <?= $stash->{package} ?>

=head1 DESCRIPTION

This class is a L<DBICx::Modeler|DBICx::Modeler> model.

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
