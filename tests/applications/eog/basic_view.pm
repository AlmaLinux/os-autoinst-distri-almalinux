use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests if the application basic layout shows basic info.

sub run {
    my $self = shift;

    # Check that the picture name is shown
    assert_screen "eog_picture_name";

    # Check that the Side panel is visible, try to make it visible if it is not.
    if (!check_screen("eog_side_panel")) {
        send_key("f9");
        wait_still_screen(2);
    }
    assert_screen("eog_side_panel");

    # Check that info on side panel is correct
    assert_screen("eog_img_info");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
