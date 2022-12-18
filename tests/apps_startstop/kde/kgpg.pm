use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Kgpg starts.

sub run {
    my $self = shift;

    # Start the application
    menu_launch_type 'kgpg';
    # Deal with the first wizard screen
    assert_and_click 'kde_next', timeout => 60;
    wait_still_screen 2;
    # Deal with the second wizard screen
    assert_and_click 'kde_next';
    wait_still_screen 2;
    # Create configuration file
    assert_and_click 'kgpg_create_config';
    wait_still_screen 2;
    # Click Next
    assert_and_click 'kde_next';
    wait_still_screen 2;
    # Click Finish
    assert_and_click 'kgpg_done';
    wait_still_screen 2;
    # Cancel the keypair creation
    assert_and_click 'kde_cancel_button';
    wait_still_screen 2;
    # Check that it is started
    assert_screen 'kgpg_runs';
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
