use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Rhythmbox starts.

sub run {
    my $self = shift;

    # Start the application
    start_with_launcher('apps_menu_rhythmbox');
    # To give the screen a bit of time.
    wait_still_screen(2);
    # On June 15th, 2022, we realized that Rhythmbox tends to
    # crash on fresh installation when run for the first time.
    # When this happens, softfail and try to start it again.
    unless (check_screen("apps_run_rhythmbox")) {
        record_soft_failure("Rhythmbox probably crashed when launched for the first time.");
        start_with_launcher('apps_menu_rhythmbox');
    }
    # Check that application has started.
    assert_screen 'apps_run_rhythmbox';
    # Register application
    register_application("rhythmbox");
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
