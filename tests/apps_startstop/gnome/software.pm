use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Software starts.

sub run {
    my $self = shift;

    # Start the application
    start_with_launcher('apps_menu_software');


    # check if a welcome screen appears, if so, click on it
    send_key 'ret' if (check_screen('gnome_software_welcome', 10));
    assert_screen 'desktop_package_tool_update';
    # Register application
    register_application("gnome-software");
    # Close the application
    quit_with_shortcut();

}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
