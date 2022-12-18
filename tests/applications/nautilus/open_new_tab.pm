use base "installedtest";
use strict;
use testapi;
use utils;

# Open a new tab.

sub run {
    my $self = shift;

    #  Enter the Documents directory to get to the test data.
    assert_and_click("nautilus_directory_documents");

    #  Click on the Burger menu to open it
    assert_and_click("gnome_burger_menu");
    wait_still_screen(2);

    # Click on the New tab to start a new tab of Nautilus.
    assert_and_click("nautilus_menu_new_tab");
    wait_still_screen(2);

    # The new tab will open in the same directory, so let us choose
    # another directory to be able to compare in the needle.
    assert_and_click("nautilus_directory_videos");
    wait_still_screen(2);

    # Confirm that two tabs exists with Documents and Video locations.
    assert_screen("nautilus_tabs_check");

}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;



