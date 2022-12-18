use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Help Center starts.

sub run {
    my $self = shift;

    # Start the application
    menu_launch_type 'help';
    # Check that it is started
    assert_screen 'help_runs', timeout => 60;
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
