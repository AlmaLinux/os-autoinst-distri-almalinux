use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that the MATE Control Center starts.

sub run {
    my $self = shift;
    # Start the application through the desktop's run dialog
    desktop_run_command('mate-control-center');
    # Check that it is started
    assert_screen 'controlcenter_runs', timeout => 60;
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
