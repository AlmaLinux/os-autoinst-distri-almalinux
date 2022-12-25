use base "installedtest";
use strict;
use testapi;
use utils;

# This script will test if Maps shows the keyboard shortcuts dialogue.

sub run {
    my $location = shift;

    # Go to menu and click on Shortcuts.
    assert_and_click("gnome_burger_menu");
    assert_and_click("maps_menu_shortcuts");
    wait_still_screen(2);

    # Check that Shortcuts have been shown.
    assert_screen("maps_shortcuts_shown");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:

