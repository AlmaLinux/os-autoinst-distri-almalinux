use base "installedtest";
use strict;
use testapi;
use utils;

# Move and copy files using the Move/Copy To menu items.

sub run {
    my $self = shift;

    #  Enter the Documents directory to get to the test data.
    assert_and_click("nautilus_directory_documents");

    #  Right click onto a file to select it and open the context menu
    #  for it.
    assert_and_click("nautilus_test_file", button => "right");
    wait_still_screen(2);

    # Click on Copy To
    wait_screen_change { assert_and_click("nautilus_context_copy_to"); };
    wait_still_screen(5);

    # Select a different location to place the file.
    assert_and_click("nautilus_directory_downloads");
    wait_still_screen(2);

    # Click on Select to copy the file into the new location
    assert_and_click("gnome_select_button");

    # Right click on that file again, this time we will move it elsewhere.
    assert_and_click("nautilus_test_file", button => "right");

    # Click on Move to
    wait_screen_change { assert_and_click("nautilus_context_move_to"); };
    wait_still_screen(5);

    # Select a new location for this file
    assert_and_click("nautilus_directory_videos");
    wait_still_screen(2);

    # Click on Select to move the file into the new location.
    assert_and_click("gnome_select_button");

    # Go into the root console and verify the operation in the background.
    $self->root_console(tty => 3);

    # Verify that the new file does not exist in the original location.
    assert_script_run("! ls /home/test/Documents/markdown.md", fail_message => 'The test file has not been deleted from its original location.');
    # And that it now exists in the new locations.
    assert_script_run("ls /home/test/Downloads/markdown.md", fail_message => 'The test file has not been found in the expected location (copy to).', quiet => '0');
    assert_script_run("ls /home/test/Videos/markdown.md", fail_message => 'The test file has not been found in the expected location (move to).', quiet => '0');
}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;



