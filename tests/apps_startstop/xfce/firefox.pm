use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Firefox starts.

sub run {
    my $self = shift;
    # Start the application through the desktop's run dialog
    desktop_run_command('firefox');
    # Check that it is started; the firefox needle predates these tests
    assert_screen 'firefox', timeout => 60;
    # Close the application
    send_key 'alt-f4';
    wait_still_screen 2;
    # deal with warning screen
    if (check_screen("firefox_close_tabs", 1)) {
        click_lastmatch;
    }
    wait_still_screen 2;
    assert_screen 'workspace';
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
