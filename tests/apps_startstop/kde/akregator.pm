use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Akregator starts.

sub run {
    my $self = shift;
    # Start the application
    menu_launch_type('akregator');
    # Check that it is started
    # Akregator is slow to put up its first window on aarch64: at 60s on
    # 9.9 it was still showing as launching in the task manager, with no
    # window yet. Waiting longer costs nothing when it is quick.
    assert_screen 'akregator_runs', timeout => 120;
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
