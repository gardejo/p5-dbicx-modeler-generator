# for Unix, Linux, etc.
set HARNESS_PERL_SWITCHES=-MDevel::Cover=+ignore,inc,examples,perl/site/lib,perl/lib,t/,xt/

rm -rf cover_db
# make realclean

# perl Makefile.PL
# make manifest

# fixme: how we set 'also_private' option of Pod::Coverage here?

prove -l xt/supplement.t t
cover
open cover_db/coverage.html
