# for Unix, Linux, etc.
set HARNESS_PERL_SWITCHES=-MDevel::Cover=+ignore,inc,perl/site/lib,perl/lib,t/,xt/

rm -rf cover_db
make realclean

perl Makefile.PL
make manifest

prove -l
cover
open cover_db/coverage.html
