use base "installedtest";
use strict;
use testapi;
use utils;

# Open another instance of Nautilus.

sub run {
    my $self = shift;

    #  Enter the Documents directory to get to the test data.
    assert_and_click("nautilus_directory_documents");

    #  Click on the Burger menu to open it
    assert_and_click("gnome_burger_menu");
    wait_still_screen(2);

    # Click on the new instance icon to create a new instance of Nautilus.
    assert_and_click("nautilus_menu_new_instance");
    wait_still_screen(2);

    # Hit the Meta key to switch to the activities mode for further check.
    send_key("super");
    wait_still_screen(2);

    # Confirm that two Nautilus windows exist in the view.
    assert_screen("nautilus_instances_check");

}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;



