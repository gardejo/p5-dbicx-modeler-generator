#!perl

# "Insecure $ENV{PATH} while running with -T switch"
#!perl -T

use lib 'examples/lib';
use lib 't/lib';

use Test::DBICx::Modeler::Generator::Manual::SQLite;

Test::DBICx::Modeler::Generator::Manual::SQLite->runtests;

1;
