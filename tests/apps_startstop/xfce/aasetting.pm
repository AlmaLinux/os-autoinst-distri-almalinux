use base "installedtest";
use strict;
use testapi;
use utils;

# Leaves the desktop empty for the application tests that follow. This
# is the milestone every one of them rolls back to, so anything open here
# would be sitting in front of every application under test.
#
# The live medium stays attached as a CD after the install, and the
# session automounts it at login and opens Thunar on it. That happens late
# and not on every boot, so wait for the desktop to settle before looking,
# then close whatever is open until the panel's window list is empty -
# which is what the workspace needle matches.

sub run {
    my $self = shift;
    wait_still_screen(stilltime => 10, similarity_level => 45);
    unless (check_screen "workspace", 10) {
        send_key_until_needlematch("workspace", 'alt-f4', 4, 3);
    }
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:
