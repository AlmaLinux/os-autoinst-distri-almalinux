use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that ABRT starts.

sub run {
    my $self = shift;
    if (get_version_major() < 9) {
        # Start the application
        menu_launch_type('abrt');
        assert_screen 'abrt_runs';
        # Close the application
        quit_with_shortcut();
    }
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
