use base "installedtest";
use strict;
use testapi;
use utils;

# Display all screens of Keyboard shortcuts.

sub run {
    my $self = shift;

    assert_and_click("gnome_burger_menu");
    wait_still_screen(2);

    assert_and_click("nautilus_menu_shortcuts");
    wait_still_screen(2);

    assert_screen("nautilus_shortcuts_first");

    send_key("right");
    send_key("ret");
    wait_still_screen(2);

    assert_screen("nautilus_shortcuts_second");

    send_key("right");
    send_key("ret");
    wait_still_screen(2);

    assert_screen("nautilus_shortcuts_third");
}

sub test_flags {
    # Rollback to the previous state to make space for other parts.
    return {always_rollback => 1};
}

1;


