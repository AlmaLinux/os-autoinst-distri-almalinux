use base "installedtest";
use strict;
use testapi;
use utils;

# Copy a file.

sub run {
    my $self = shift;

    #  Enter the Documents directory to get to the test data.
    assert_and_click("nautilus_directory_documents");

    #  Click onto a file to select it.
    assert_and_click("nautilus_test_file");
    wait_still_screen(2);

    # Press the keyboard shortcut to copy the file
    send_key("ctrl-c");

    # Select a different location to place the file.
    assert_and_click("nautilus_directory_downloads");
    wait_still_screen(2);

    # Assert that we have entered the correct directory.
    assert_screen("nautilus_directory_reached_downloads");

    # Put the file in the new location
    send_key("ctrl-v");

    # Check that the file has appeared.
    assert_screen("nautilus_test_file");

    # Go into the root console and verify the operation in the background.
    $self->root_console(tty => 3);

    # Verify that the new file exists in original location.
    assert_script_run("ls /home/test/Documents/markdown.md", timeout => '60', fail_message => 'The test file was incorrectly removed from the old location.', quiet => '0');
    # And also in the new location.
    assert_script_run("ls /home/test/Downloads/markdown.md", timeout => '60', fail_message => 'The test file has not been found in the new location.', quiet => '0');

}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;



