use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Photos starts.

sub run {
    my $self = shift;

    # Switch to console
    $self->root_console(tty => 3);
    # Perform git test
    check_and_install_software("gnome-photos");
    # Exit the terminal
    desktop_vt;

    # Start the application
    start_with_launcher('apps_menu_photos');
    # Check that is started
    assert_screen 'apps_run_photos';
    # Register application
    register_application("gnome-photos");
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
