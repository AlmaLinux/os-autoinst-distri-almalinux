use base "installedtest";
use strict;
use testapi;
use utils;

# Delete a file.

sub run {
    my $self = shift;

    #  Enter the Documents directory to get to the test data.
    assert_and_click("nautilus_directory_documents");

    #  Click onto a file to select it.
    assert_and_click("nautilus_test_file");

    # Press the keyboard shortcut to delete the file and wait until file disappears
    send_key("delete");
    wait_still_screen(1);

    # Now, find the confirmation and click on Undo to return the operation.
    assert_and_click("nautilus_delete_undo");

    # Check that the file is still in its location.
    assert_and_click("nautilus_test_file");
    wait_still_screen(2);

    # Delete the file again and this time, let time pass for the confirmation dialogue
    # to disappear.
    send_key("delete");
    sleep(10);

    # Select another file and delete it.
    assert_and_click("nautilus_test_file_another");
    wait_still_screen(2);
    send_key("delete");
    sleep(10);

    # Navigate to the Wastebin and check that the file appeared there.
    assert_and_click("nautilus_select_wastebin");

    # Confirm that Wastebin is active
    assert_screen("nautilus_confirm_wastebin");

    # Check that the files are now located here.
    assert_screen("nautilus_test_file");
    assert_screen("nautilus_test_file_another");

    # Select the first file and restore it from the Bin.
    assert_and_click("nautilus_test_file", button => "right");
    wait_still_screen(2);
    assert_and_click("nautilus_restore_content");

    # Go to the Documents again and check that the file reappeared there.
    assert_and_click("nautilus_directory_documents");
    wait_still_screen(2);
    assert_screen("nautilus_test_file");

    # Go into the root console and verify the operation in the background.
    $self->root_console(tty => 3);

    # Verify that the first file still exists in the location as it was restored from the bin.
    assert_script_run("ls /home/test/Documents/markdown.md", timeout => '60', fail_message => 'The file has not been found in the location.', quiet => '0');

    # Verify that the next file has been deleted from the original location
    assert_script_run("! ls /home/test/Documents/konkurz.md");
}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;



