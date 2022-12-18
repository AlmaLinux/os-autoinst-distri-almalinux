use base "installedtest";
use strict;
use testapi;
use utils;

# This test tests if Terminal starts.

sub run {
    my $self = shift;
    # open the application
    menu_launch_type "terminal";
    assert_screen "apps_run_terminal";

    # Register application
    register_application("gnome-terminal");

    # Close the application
    quit_with_shortcut();
}

# If this test fails, the others will probably start failing too,
# so there is no need to continue.
# Also, when subsequent tests fail, the suite will revert to this state for further testing.
sub test_flags {
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:
