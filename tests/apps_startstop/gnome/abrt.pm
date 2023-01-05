use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that ABRT starts.

sub run {
    my $self = shift;

    if (get_version_major() < 9) {
         # Switch to console, Live does not have abrt package installed, 
        # so install before testing 
        $self->root_console(tty => 3);
        # Perform git test
        check_and_install_software("gnome-abrt");
        # Exit the terminal
        desktop_vt;

        start_with_launcher('apps_menu_abrt', 'apps_menu_utilities');
        # Check that it is started
        assert_screen 'apps_run_abrt';
        # Register application
        register_application('gnome-abrt');
        # Close the application
        quit_with_shortcut();
    }
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
