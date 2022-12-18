use base "installedtest";
use strict;
use testapi;
use utils;

# This script will download the test files, start Nautilus,
# stretch it all over the screen and upload the status to
# set a milestone as a starting point for the other Nautilus tests.

sub run {
    my $self = shift;
    # Switch to console
    $self->root_console(tty => 3);
    # Perform git test
    check_and_install_git();
    # Download the test data
    download_testdata();

    enter_cmd("touch /home/test/Documents/.invisible.txt");
    enter_cmd("chown test:test /home/test/Documents/.invisible.txt");
    enter_cmd("rm -f /home/test/*reference*");

    # Exit the terminal
    desktop_vt;

    # Start the application
    menu_launch_type("nautilus");
    # Check that is started
    assert_screen 'apps_run_files';
    wait_still_screen("2");

    # Fullsize the Nautilus window.
    wait_screen_change { send_key("super-up"); };

    # Click to change the Directory view to listings.
    assert_and_click("nautilus_toggle_view", timeout => '30', button => 'left', mousehide => '1');

    # This will test the common directory structure. The structure is always created when a user is created, so let's see if it has been created correctly.
    assert_screen("nautilus_available_directories");
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:



