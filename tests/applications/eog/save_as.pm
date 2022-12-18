use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests if the application can save the image as a different file.

sub run {
    my $self = shift;
    sleep 2;
    assert_screen("eog_image_default");

    # Shift-ctrl-S to save a file as a new file.
    send_key("shift-ctrl-s");
    wait_still_screen(3);

    # Type the new name, this should be possible without any intervention.
    type_very_safely("new_image");
    # Hit enter to confirm
    send_key("ret");
    wait_still_screen("2");

    # Go to console
    $self->root_console(tty => 3);

    # List the location
    assert_script_run("ls /home/test/Pictures/");

    # Compare the files
    assert_script_run("diff /home/test/Pictures/leaves.jpg /home/test/Pictures/new_image.jpg");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
