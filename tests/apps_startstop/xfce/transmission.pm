use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Transmission starts.

sub run {
    my $self = shift;
    # Start the application through the desktop's run dialog
    desktop_run_command('transmission-gtk');
    # Check that it is started
    assert_screen 'transmission_runs', timeout => 60;
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
