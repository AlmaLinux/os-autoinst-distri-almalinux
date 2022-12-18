use base "installedtest";
use strict;
use testapi;
use utils;

# This will set up the environment for the Maps test.
# We only need to start Maps, make it full screen and
# save the status.

sub run {
    my $self = shift;
    # Start the application
    menu_launch_type("Maps");
    # Check it has started, or we got the permission prompt
    assert_screen ['apps_run_maps', 'grant_access'];
    if (match_has_tag 'grant_access') {
        click_lastmatch;
        assert_screen 'apps_run_maps';
    }
    # Fullsize the window.
    send_key("super-up");

    # Find a location on the map.

    # If the Delete button is visible, click on it to delete the search bar
    # and start a new search. If it is not visible, then press Ctrl-F
    # to start the first search.
    if (check_screen("maps_button_delete_bar")) {
        click_lastmatch();
    }
    else {
        send_key("ctrl-f");
    }
    sleep(1);
    # Type in the first location
    type_very_safely("brno");
    # Wait a little bit for the window to settle.
    wait_still_screen(2);
    # Click on the location
    assert_and_click("maps_select_brno");
    # Let's not do any checks (they are done elsewhere),
    # just let the screen settle and hit Esc to remove
    # the infobox.
    wait_still_screen(5);
    # Dismis the info box (empty or full)
    send_key("esc");
    # Check that Map is shown with the correct location
    assert_screen("maps_found_brno", timeout => 90);
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:

