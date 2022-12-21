use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    if (not(check_screen "root_console", 0)) {
        $self->root_console(tty => 3);
    }
    # check / is xfs, as it should be on server
    assert_script_run 'findmnt -M / -o FSTYPE | grep xfs';
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
