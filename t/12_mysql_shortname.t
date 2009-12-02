#!perl

# "Insecure $ENV{PATH} while running with -T switch"
#!perl -T

use lib 'examples/lib';
use lib 't/lib';

use Test::DBICx::Modeler::Generator::CLI::MySQL;

Test::DBICx::Modeler::Generator::CLI::MySQL->interface('shortname');
Test::DBICx::Modeler::Generator::CLI::MySQL->runtests;

1;
