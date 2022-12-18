use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests that Shortcuts can be shown.

sub run {
    my $self = shift;
    # wait for snapshot restore to settle
    sleep 5;

    # Open Shortcuts.
    send_key("ctrl-?");

    # Assert the screen and move to next one
    assert_screen "gte_shortcuts_one";
    assert_and_click "gte_shortcuts_go_two";

    # Assert the screen and move to next one
    assert_screen "gte_shortcuts_two";
}


sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
