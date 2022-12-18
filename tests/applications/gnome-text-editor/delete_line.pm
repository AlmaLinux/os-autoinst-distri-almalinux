use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests that a line of text can be deleted
# and the deletion reverted.

sub run {
    my $self = shift;
    #  Click on a word on the line.
    assert_and_click("gte_line_word", clicktime => 0.3);
    wait_still_screen(2);
    # Delete the line
    send_key("home");
    sleep 1;
    send_key("shift-end");
    sleep 1;
    send_key("delete");
    sleep 1;
    # Move cursor out of the way.
    send_key("ctrl-end");
    # Check that the line was deleted.
    assert_screen "gte_line_deleted";

    # Use combo to revert the action.
    send_key "ctrl-z";
    sleep 1;
    # Move cursor out of the way.
    send_key "ctrl-end";
    # Check that the line was re-added.
    assert_screen "gte_text_added";
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
