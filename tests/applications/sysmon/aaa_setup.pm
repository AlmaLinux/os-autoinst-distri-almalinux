use base "installedtest";
use strict;
use testapi;
use utils;

# This script opens the System Monitor application and saves the milestone
# to make it ready for further testing.

sub run {
    my $self = shift;

    # Start the Application
    menu_launch_type("system monitor");
    assert_screen("systemmonitor_runs");

    # Make it fill the entire window.
    send_key("super-up");
    wait_still_screen(2);
}

sub test_flags {
    # If this test fails, there is no need to continue.
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:
