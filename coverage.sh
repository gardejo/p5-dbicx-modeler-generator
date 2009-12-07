# for Unix, Linux, etc.
export HARNESS_PERL_SWITCHES=-MDevel::Cover=+ignore,inc,examples,perl/site/lib,perl/lib,t/,xt/

rm -rf cover_db
# make realclean

# perl Makefile.PL
# make manifest

# fixme: how we set 'also_private' option of Pod::Coverage here?

prove -l xt/supplement.t t
cover
firevox cover_db/coverage.html &
