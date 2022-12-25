use base "installedtest";
use strict;
use testapi;
use utils;

# This script will check if shortcuts can be shown.

sub run {
    my $self = shift;

    # Wait some time to settle down.
    sleep(5);
    # Go to the menu and click on shortcuts item
    assert_and_click("gnome_burger_menu");
    assert_and_click("contacts_menu_shortcuts");
    # Check that the the correct window has shown.
    assert_screen("contacts_shortcuts_shown");
}

sub test_flags {
    # Rollback after the test.
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:



