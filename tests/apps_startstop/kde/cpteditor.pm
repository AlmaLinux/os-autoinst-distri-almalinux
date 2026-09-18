use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Control Print Theme Editor starts.

sub run {
    my $self = shift;
    # Kickoff searches the name shown in the menu, not the binary:
    # this application is listed as "Contact Print Theme Editor".
    menu_launch_type 'Contact Print Theme';
    # Check that it is started
    assert_screen 'cpteditor_runs', timeout => 60;
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
