use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    $self->root_console(tty => 3);
    # do repo_setup if it's not been done already - this is for the
    # install_default_update tests
    repo_setup;
    # figure out which packages from the update actually got installed
    # (if any) as part of this test
    advisory_get_installed_packages;
    # figure out if we have a different version of any package from the
    # update installed
    advisory_check_nonmatching_packages;
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
