use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Simple Scan starts.

sub run {
    my $self = shift;
    if (get_version_major() < 9) {
        # Start the application
        start_with_launcher('apps_menu_scan');
        # Check that is started
        assert_screen 'apps_run_scan';
        # Register application
        register_application("simple-scan");
        # Close the application
        quit_with_shortcut();
    }
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
