use base "installedtest";
use strict;
use testapi;
use utils;

# This script will test if Maps can zoom in and out.

sub run {
    my $location = shift;
    my $softfail = 0;

    # Zoom in several times and check for zoomed map.
    assert_and_click("maps_button_zoom_in");
    foreach (my @counter = (1 .. 4)) {
        click_lastmatch();
    }
    assert_screen("maps_map_zoomed", timeout => 60);


    # Zoom out several times and check for zoomed out map.
    assert_and_click("maps_button_zoom_out");
    foreach (my @counter = (1 .. 4)) {
        click_lastmatch();
    }
    assert_screen("maps_found_brno");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:

