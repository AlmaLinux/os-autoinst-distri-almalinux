use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that KCharselect starts.

sub run {
    my $self = shift;

    # Start the application
    menu_launch_type 'kcharselect';
    # Check that it is started
    assert_screen 'kcharselect_runs', timeout => 60;
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
