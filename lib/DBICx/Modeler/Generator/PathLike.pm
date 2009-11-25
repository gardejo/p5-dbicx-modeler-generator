package DBICx::Modeler::Generator::PathLike;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose::Role;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# interface(s)
# ****************************************************************

requires qw(
    source      source_model    source_models   source_schema   source_schemata
    target      target_model    target_models   target_schema   target_schemata
    extension
);


# ****************************************************************
# return true
# ****************************************************************

1;
__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

DBICx::Modeler::Generator::PathLike -

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=cut
