@REM for MS Windows
@echo off

setlocal
set HARNESS_PERL_SWITCHES=-MDevel::Cover=+ignore,inc,examples,perl/site/lib,perl/lib,t/,xt/

rd /s /q cover_db 2>nul
REM dmake realclean

REM perl Makefile.PL
REM dmake manifest

REM fixme: how we set 'also_private' option of Pod::Coverage here?

prove -l xt\supplement.t t && cover && start cover_db/coverage.html
