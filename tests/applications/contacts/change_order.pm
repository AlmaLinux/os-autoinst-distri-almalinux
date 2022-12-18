use base "installedtest";
use strict;
use testapi;
use utils;

# This script will change the order of contacts and confirm
# that the change ran correctly.

sub run {
    my $self = shift;

    # Wait some time to settle down.
    sleep(5);
    # Move mouse away from the screen.
    mouse_set(1, 1);
    # Check the original ordering of contacts
    assert_screen("contacts_contacts_ordered_name");
    # Open the Menu and click on order item.
    assert_and_click("gnome_burger_menu");
    assert_and_click("contacts_menu_order_surname");
    # Check that the order of contacts changed.
    assert_screen("contacts_contacts_ordered_surname");
    # Repeat the action
    assert_and_click("gnome_burger_menu");
    assert_and_click("contacts_menu_order_name");
    # Check that the contacts' order changed again.
    assert_screen("contacts_contacts_ordered_name");
}

sub test_flags {
    # Rollback after the test.
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:



