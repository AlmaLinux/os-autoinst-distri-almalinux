use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Krfb starts.

sub run {
    my $self = shift;

    # Start the application
    menu_launch_type 'krfb';
    # Check that it is started
    assert_and_click 'krfb_runs', timeout => 60;
    # use send_key 'alt-f4', if not working;
    wait_still_screen 2;
    # deal with warning screen
    if (check_screen("krfb_runs", 1)) {
        click_lastmatch;
        wait_still_screen 2;
    }
    
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
