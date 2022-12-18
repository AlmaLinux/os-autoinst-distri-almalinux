use base "installedtest";
use strict;
use testapi;
use utils;

# This script will test if Maps can toggle a scale information
# in the bottom left corner.

sub run {
    my $location = shift;

    # Zoom in several times and check for zoomed map.
    assert_screen("maps_scale_on");
    # Switch it of
    assert_and_click("maps_button_overlays");
    assert_and_click("maps_switch_scale");
    wait_still_screen(2);
    assert_screen("maps_scale_off");

    # Switch it on again
    assert_and_click("maps_button_overlays");
    assert_and_click("maps_switch_scale");
    wait_still_screen(2);
    assert_screen("maps_scale_on");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:

