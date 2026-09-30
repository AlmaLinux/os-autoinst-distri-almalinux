use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that the Settings Editor starts.

sub run {
    my $self = shift;
    # Start the application through the desktop's run dialog
    desktop_run_command('xfce4-settings-editor');
    # Check that it is started
    assert_screen 'settingseditor_runs', timeout => 60;
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
