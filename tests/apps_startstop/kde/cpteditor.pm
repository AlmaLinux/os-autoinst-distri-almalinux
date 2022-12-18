use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that Control Print Theme Editor starts.

sub run {
    my $self = shift;
    menu_launch_type 'printthemeeditor';
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
