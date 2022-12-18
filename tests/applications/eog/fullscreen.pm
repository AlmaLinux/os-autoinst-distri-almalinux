use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests if the application can be switched to full screen.

sub run {
    my $self = shift;

    # Toggle full screen
    send_key("f11");
    wait_still_screen 2;
    assert_screen("eog_fullscreen_on");

    # Return to normal mode
    send_key("f11");
    wait_still_screen 2;
    assert_screen("eog_image_default");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
