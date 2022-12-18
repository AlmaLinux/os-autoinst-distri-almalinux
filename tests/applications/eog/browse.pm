use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests if the application can navigate through the current folder.

sub run {
    my $self = shift;

    # Go to next picture.
    send_key("right");
    wait_still_screen(2);
    assert_screen("eog_image_next");
    # Go to previous picture
    send_key("left");
    wait_still_screen;
    assert_and_click("eog_image_default");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
