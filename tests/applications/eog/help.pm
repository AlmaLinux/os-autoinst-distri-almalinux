use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests if the application can show help.

sub run {
    my $self = shift;
    sleep 2;

    # Open the shortcuts
    send_key("f1");
    wait_still_screen(3);
    assert_screen("eog_help_shown");
    # Try another screen
    assert_and_click("eog_help_image_zoom");
    wait_still_screen(2);
    assert_screen("eog_help_zoom_shown");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
