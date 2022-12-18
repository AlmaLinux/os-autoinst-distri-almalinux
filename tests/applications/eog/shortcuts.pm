use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests if the application can show the shortcuts.

sub run {
    my $self = shift;
    sleep 2;

    # Open the shortcuts
    send_key("ctrl-?");
    wait_still_screen(3);
    assert_screen("eog_shortcuts_shown");
    # Try another screen
    send_key("right");
    send_key("ret");
    wait_still_screen(3);
    assert_screen("eog_shortcuts_alt_shown");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
