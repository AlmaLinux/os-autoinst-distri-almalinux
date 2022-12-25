use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that QtDbusViewer starts.

sub run {
    my $self = shift;

#    if (get_version_major() < 9) {
        # Switch to console, Live does not have abrt package installed, 
        # so install before testing 
        $self->root_console(tty => 3);
        # Perform git test
        check_and_install_software("qt5-qdbusviewer");
        # Exit the terminal
        desktop_vt;

        menu_launch_type 'dbusviewer';
        # Check that it is started
        assert_screen 'dbusviewer_runs', timeout => 60;
        # Close the application
        quit_with_shortcut();
#    }
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
