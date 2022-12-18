use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Kmail starts.

sub run {
    my $self = shift;

    # Start the application
    menu_launch_type 'kmail';
    # Cancel Kmail data wizard
    assert_and_click 'kde_cancel_button', timeout => 60;
    # Sometimes, the Kmail window is shown over the settings window.
    # If that is the case, assert that Kmail is running and exit.
    unless (check_screen("kmail_runs")) {
        if (check_screen("kde_cancel_button", 1)) {
            click_lastmatch;
        }
        assert_screen("kmail_runs");
    }
    else {
        assert_screen("kmail_runs");
    }
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
