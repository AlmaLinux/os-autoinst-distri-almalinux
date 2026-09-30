use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Log File Viewer starts.

sub run {
    my $self = shift;
    # Start the application through the desktop's run dialog
    desktop_run_command('mate-system-log');
    # mate-system-log goes through usermode (consolehelper), which asks
    # for the root password before starting it. That query window has no
    # entry in the panel's window list. Run Unprivileged starts it as the
    # session user - which is all this test needs to know, and does not
    # tie the test to the root password.
    assert_and_click 'mate_systemlog_query', timeout => 60;
    # Check that it is started
    assert_screen 'systemlog_runs', timeout => 60;
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
