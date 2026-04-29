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
    # `dnf repoclosure` plugin has buggy rich-dependency handling: it
    # treats `Requires: (X if Y)` as a hard `Requires: X` even when Y is
    # not in the install set. Use libsolv-based `dnf repoquery --unsatisfied`
    # instead, which agrees with what pungi reports for the same compose.
    assert_script_run "dnf repoquery --repofrompath=testdeps,/mnt/iso/Minimal --repo=testdeps --unsatisfied | tee /tmp/repoclosure.out";
    assert_script_run "! test -s /tmp/repoclosure.out";
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
