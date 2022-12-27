use base "installedtest";
use strict;
use testapi;

sub run {
    my $self = shift;
    # switch to tty and login as root
    $self->root_console(tty => 3);

    assert_screen "root_console";
    # check that there is a root partition and that it has
    # the correct size -> 11G
    assert_script_run "lsblk | grep root | grep '11G'";
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
