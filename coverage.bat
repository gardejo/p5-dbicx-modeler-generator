REM for MS Windows
@echo off

setlocal
set HARNESS_PERL_SWITCHES=-MDevel::Cover=+ignore,inc,perl/site/lib,perl/lib,t/,xt/

rd /s /q cover_db 2>nul
dmake realclean

perl Makefile.PL
dmake manifest

prove -l && cover && start cover_db/coverage.html
