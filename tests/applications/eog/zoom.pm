use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests if the application can change the zoom for the displayed picture.

sub run {
    my $self = shift;
    sleep 2;

    # Make the image size 1:1
    send_key("1");
    wait_still_screen(2);
    assert_screen("eog_image_shown_increased");
    # Return to the best fit
    send_key("f");
    assert_and_click("eog_image_default");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
