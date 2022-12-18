use base "installedtest";
use strict;
use testapi;
use utils;

# Move a file.

sub run {
    my $self = shift;

    #  Enter the Documents directory to get to the test data.
    assert_and_click("nautilus_directory_documents");

    #  Click onto a file to select it.
    assert_and_click("nautilus_test_file");
    wait_still_screen(2);

    # Press the keyboard shortcut to cut the file
    send_key("ctrl-x");

    # Select a different location to place the file.
    assert_and_click("nautilus_directory_downloads");
    wait_still_screen(2);

    # Check that we have entered the Downloads directory
    assert_screen("nautilus_directory_reached_downloads");

    # Put the file in the new location
    send_key("ctrl-v");

    # Check that the file has appeared.
    assert_screen("nautilus_test_file");

    # Go into the root console and verify the operation in the background.
    $self->root_console(tty => 3);

    # Verify that the new file does not exist in the original location.
    assert_script_run("! ls /home/test/Documents/markdown.md", fail_message => 'The test file still exists in the original location, but it should have been removed.');
    # And that it exists in the new location.
    assert_script_run("ls /home/test/Downloads/markdown.md", fail_message => 'The test file has not been found in the expected location when it should have been copied there.', quiet => '0');

}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;



