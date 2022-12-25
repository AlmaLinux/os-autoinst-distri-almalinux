use base "installedtest";
use strict;
use testapi;
use utils;

# This script will test if Maps can search for various locations.

sub search {
    my $location = shift;
    my $softfail = 0;
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
    type_very_safely($location);
    # Wait a little bit for the window to settle.
    wait_still_screen(2);
    # Click on the location
    assert_and_click("maps_select_$location");
    # When a location is found, an infobox is shown with a picture
    # and some details. Sometimes, there is a great lag and it
    # seems to download the info for ages without any success.
    # If this happens, increase the softfail variable which will
    # be returned from the subroutine to track this.
    unless (check_screen("maps_info_$location", timeout => 120)) {
        $softfail++;
    }
    # Dismis the info box (empty or full)
    send_key("esc");
    # Check that Map is shown with the correct location
    assert_screen("maps_found_$location", timeout => 120);
    return $softfail;
}

sub run {
    my $self = shift;
    my $softfailCounter = 0;
    # Let the test settle a bit after it is loaded from the saved image.
    sleep(5);
    # Search for the locations, catch the output of the subroutine to track
    # the softfails - the overall number will be increased each time a softfail
    # is reported from the subroutine.
    my $result = search("vilnius");
    $softfailCounter = $softfailCounter + $result;
    $result = search("denali");
    $softfailCounter = $softfailCounter + $result;
    $result = search("wellington");
    $softfailCounter = $softfailCounter + $result;
    $result = search("poysdorf");
    $softfailCounter = $softfailCounter + $result;
    $result = search("pune");
    $softfailCounter = $softfailCounter + $result;
    # Record soft failure if there was any.
    if ($softfailCounter > 0) {
        record_soft_failure("The information were not loaded into the info box in $softfailCounter times.");
    }
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:

