use base "installedtest";
use strict;
use testapi;
use utils;

# Rename a file.

sub run {
    my $self = shift;

    #  Enter the Documents directory to get to the test data.
    assert_and_click("nautilus_directory_documents");

    #  Click onto a file to select it.
    assert_and_click("nautilus_test_file");

    # Press the keyboard shortcut to rename the file
    send_key("f2");

    # Check that a rename dialogue has been displayed.
    assert_screen("nautilus_rename_dialogue");

    # Type a new name and confirm it.
    type_very_safely("renamed");
    send_key("ret");

    # Check that the file has been renamed.
    assert_screen("nautilus_rename_check");

    # Go into the root console and verify the operation in the background.
    $self->root_console(tty => 3);

    # Verify that the new file exists in the location.
    assert_script_run("ls /home/test/Documents/renamed.md", timeout => '60', fail_message => 'The renamed file has not been found in the location.', quiet => '0');

}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;



