use base "installedtest";
use strict;
use testapi;
use utils;

# This script will download the test data for evince, start the application,
# and set a milestone as a starting point for the other EoG tests.

sub run {
    my $self = shift;
    # Switch to console
    $self->root_console(tty => 3);
    # Perform git test
    check_and_install_git();
    # Download the test data
    download_testdata();
    # Exit the terminal
    desktop_vt;

    # Start the application
    menu_launch_type("image viewer");
    # Check that is started
    assert_screen 'apps_run_imageviewer';

    # Fullsize the EoG window.
    send_key("super-up");

    # Open the test file to create a starting point for the other EoG tests.
    send_key("ctrl-o");

    if (get_var("CANNED") && !check_screen("gnome_dirs_pictures")) {
        # open the Pictures folder.
        assert_and_click("gnome_dirs_pictures", button => "left", timeout => 30);
    }

    # Select the image.jpg file.
    assert_and_click("eog_file_select_jpg", button => "left", timeout => 30);

    # Hit enter to open it.
    send_key("ret");

    # Check that the file has been successfully opened.
    assert_screen("eog_image_default");
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:
