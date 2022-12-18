use base "installedtest";
use strict;
use testapi;
use utils;

# Test the About dialogue.

sub run {
    my $self = shift;

    # Open the menu by clicking on the Burger icon
    assert_and_click("gnome_burger_menu", button => "left", timeout => 30);
    wait_still_screen 2;

    # In the menu, click on the About item.
    assert_and_click("nautilus_menu_about", button => "left", timeout => 30);

    # Check that the About section has been displayed.
    assert_screen("nautilus_about_show");

    # Click on Credits button to see the second part of the dialogue.
    assert_and_click("gnome_button_credits", button => "left", timeout => 30);

    # Check that Credits are accessible and visible, too.
    assert_screen("nautilus_credits_shown");
}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;


