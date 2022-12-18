use base "installedtest";
use strict;
use testapi;
use utils;

# This script will test if Maps can plan some routes.

sub run {
    my $location = shift;
    my $softfail = 0;

    # Click on the route planning button.
    assert_and_click("maps_button_route");
    wait_still_screen(2);

    # Type in the starting point and confirm in the selector.
    type_very_safely("Land's End");
    assert_and_click("maps_select_landsend");

    # Type in the end point and confirm in the selector.
    type_very_safely("John O'Groats");
    assert_and_click("maps_select_johngroats");

    # Select walking
    assert_and_click("maps_route_type_walk");
    assert_screen("maps_route_walk_shown", timeout => 90);

    # Select biking
    assert_and_click("maps_route_type_bike");
    assert_screen("maps_route_bike_shown", timeout => 90);

    # Select car
    assert_and_click("maps_route_type_car");
    assert_screen("maps_route_car_shown", timeout => 90);
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:

