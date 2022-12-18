use base "installedtest";
use strict;
use testapi;
use utils;

# Create a new directory.

sub run {
    my $self = shift;

    #  Enter the Documents directory to get to the test data.
    assert_and_click("nautilus_directory_documents");
    wait_still_screen(2);

    #  Click on the Burger menu to open it
    assert_and_click("gnome_kebab_menu");
    wait_still_screen(2);

    # Click on the Create directory icon to create a new directory.
    assert_and_click("nautilus_menu_new_directory");
    wait_still_screen(2);

    # Type in the new name
    type_safely("new_directory");
    send_key("ret");

    # Confirm that the directory has appeared in the tree
    assert_screen("nautilus_new_directory_check");

    # Go into the root console and verify the operation in the background.
    $self->root_console(tty => 3);

    # Check that the directory can be listed.
    assert_script_run("ls /home/test/Documents/new_directory", fail_message => "The expected directory does not exist.");
    # Check that it indeed is a directory and that it is user writable and executable.
    validate_script_output("ls -l /home/test/Documents/ | grep new_directory", sub { m/drwx/ });

}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;



