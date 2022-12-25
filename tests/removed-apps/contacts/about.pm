use base "installedtest";
use strict;
use testapi;
use utils;

# This script will start the Gnome Contacts application and save the status
# for any subsequent tests.

sub run {
    my $self = shift;

    # Wait some time to settle down.
    sleep(5);
    # Open the menu and click on item.
    assert_and_click("gnome_burger_menu");
    assert_and_click("contacts_menu_about");
    # Check that the About window has appeared.
    assert_screen("contacts_about_shown");
    # Click on Credits to move to credits and check we
    # have moved.
    assert_and_click("gnome_button_credits");
    assert_screen("contacts_credits_shown");
}

sub test_flags {
    # Rollback after the test.
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:



