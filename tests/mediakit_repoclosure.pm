use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    # create a mount point for the ISO
    assert_script_run "mkdir -p /mnt/iso";
    # mount the ISO there
    assert_script_run "mount /dev/cdrom /mnt/iso";
    # List files
    script_run "ls -al /mnt/iso";
    script_run "ls -al /mnt/iso/Minimal";
    # run the check
    assert_script_run "dnf repoclosure --repofrompath testdeps,/mnt/iso/Minimal --repo testdeps";
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
