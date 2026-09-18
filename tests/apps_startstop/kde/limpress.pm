use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that LibreOffice Impress starts.

sub run {
    my $self = shift;
    # Start the application
    menu_launch_type 'libreoffice impress';
    # Check that it is started
    assert_screen 'limpress_runs', timeout => 60;
    # Close the template chooser, then the application. Escape, not
    # alt-f4: the chooser is modal, and alt-f4 left both it and the main
    # window standing, so quit_with_shortcut never got back to a bare
    # desktop. Fedora does the same here.
    send_key 'esc';
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
