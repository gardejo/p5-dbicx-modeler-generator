use strict;
use warnings;

use File::Find::Rule;
use FindBin;
use Image::Size;
use Path::Class;

my %previous;

my $rule = File::Find::Rule->new;
$rule->file;
$rule->name('*.png');

my $target_directory = $ARGV[0] || $FindBin::Bin;

foreach my $image ($rule->in($target_directory)) {
    my $path = file($image);
    my ($x, $y) = imgsize($path->stringify);
    printf "%-36s - x)%d, y)%d\n", (
        $path->basename,
        $x,
        $y,
    );
    warn "$image differ\n"
        if exists $previous{x}
        && exists $previous{y}
        && ($previous{x} != $x || $previous{y} != $y);
    @previous{qw(x y)} = ($x, $y);
}

__END__

=head1 NAME

confirm_image_size - Confirmation of E/R diagrams which uniform in size

=head1 SYNOPSIS

    $ pwd
    /path/to/root
    $ confirm_image_size.pl doc

=head1 DESCRIPTION

To export an Entity-Relationship Diagram
as "Quad-VGA" (width: 1280px * height: 960px) PNG image
from MySQL Workbench (5.1.18 OSS),
select C<< [File] - [Page Setup] >> menu (open C<< [Page Setup] >> window)
and specify settings below:

=over 4

=item C<< [Paper] >> group

select C<< [A4 (210 mm x 297 mm)] >> item from C<< [Size] >> listbox

=item C<< [Orientation] >> group

turn on C<< [Landscape] >> radio button

=item C<< [Margins] >> group

input C<< [10] >>mm into C<< [Top] >> text box

input C<< [10] >>mm into C<< [Left] >> text box

input C<< [35] >>mm into C<< [Bottom] >> text box

input C<< [12] >>mm into C<< [Right] >> text box 

=back

Note: 1mm corresponds with 5 pixel.

Caveat: In case of direct printing and exporting as a SVG image,
lines of bottom edge and right edge will disapper.

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. Gardejo)

C<< <moriya at ermitejo dot com> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by MORIYA Masaki (a.k.a. Gardejo),
L<http://ttt.ermitejo.com>.

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
