#!perl

# "Insecure $ENV{PATH} while running with -T switch"
#!perl -T

use lib 'examples/lib';
use lib 't/lib';

use Test::DBICx::Modeler::Generator::CLI::SQLite;

Test::DBICx::Modeler::Generator::CLI::SQLite->interface('longname');
Test::DBICx::Modeler::Generator::CLI::SQLite->runtests;

1;
