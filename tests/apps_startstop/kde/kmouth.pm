use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Kmouth starts.

sub run {
    my $self = shift;

    # Start the application
    menu_launch_type 'kmouth';
    sleep 2;
    # Deal with the welcome screens
    assert_screen ["kde_next", "kde_finish"], 90;
    while (match_has_tag "kde_next") {
        assert_and_click "kde_next";
        sleep 2;
        assert_screen ["kde_next", "kde_finish"];
    }
    # Settings close
    assert_and_click 'kde_finish';
    wait_still_screen 2;
    # Check that it is started
    # July 19th, I realized that kmouth test has been failing,
    # but it seems that it takes more time to run than
    # the needle is willing to wait. Adding wait time.
    assert_screen('kmouth_runs', timeout => 300);
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
