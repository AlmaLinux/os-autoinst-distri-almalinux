use base "installedtest";
use strict;
use testapi;
use utils;

# View and change file permissions.

sub run {
    my $self = shift;

    #  Enter the Documents directory to get to the test data.
    assert_and_click("nautilus_directory_documents");

    #  Rigth click onto a file to open context menu.
    assert_and_click("nautilus_test_file", button => "right");
    wait_still_screen(2);

    # Click on the Properties menu item
    assert_and_click("nautilus_context_properties");
    wait_still_screen(2);

    # Check that the Properties window has appeared and close it.
    assert_screen("nautilus_properties_check");
    send_key("esc");

    # Ensure the file is selected and pane is active (or else
    # shortcut may not work).
    assert_and_click("nautilus_test_file");

    # Send a key combination to open the Properties again.
    send_key("ctrl-i");

    # Check that the Properties window has appeared again.
    assert_screen("nautilus_properties_check");

    # Click on the Permissions tab
    assert_and_click("nautilus_select_permissions");

    # Check that the owner can read and write the file
    assert_screen("nautilus_owner_permissions");

    # Check that others cannot do anything.
    assert_screen("nautilus_others_permissions");

    # Set the permission for others to None
    assert_and_click("nautilus_permissions_read_only");

    # Click on Read Only to select it.
    assert_and_click("nautilus_permissions_set_none");

    # Close the Properties
    send_key("esc");

    # Go into the root console and verify the operation in the background.
    $self->root_console(tty => 3);

    # Check that the permissions have been changed.
    validate_script_output("ls -l /home/test/Documents/markdown.md", sub { m/-rw-r-----/ });

}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;



