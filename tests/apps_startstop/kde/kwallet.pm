use base "installedtest";
use strict;
use testapi;
use utils;

# This test checks that KDE Wallet starts.

sub run {
    my $self = shift;

    # Start the application
    menu_launch_type 'kwallet';
    # KWalletManager sometimes maps its window but never paints it
    # (blank, without even the menu bar). Resizing makes it repaint, so
    # maximize and restore it to get back to the usual geometry.
    unless (check_screen 'kwallet_runs', 30) {
        record_info('repaint', 'KWalletManager window is not painted, maximizing and restoring it');
        wait_screen_change { send_key 'super-pgup'; };
        wait_still_screen 2;
        wait_screen_change { send_key 'super-pgup'; };
    }
    # Check that it is started
    assert_screen 'kwallet_runs', timeout => 60;
    # Close the application
    quit_with_shortcut();
}

sub test_flags {
    return {always_rollback => 1};
}


1;

# vim: set sw=4 et:
