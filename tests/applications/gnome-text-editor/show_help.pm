use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests that Help can be shown.

sub run {
    my $self = shift;

    # Open Help.
    send_key("f1");
    assert_screen "gte_help_shown";

    # Navigate through several screens
    assert_and_click "gte_help_files";
    assert_screen "gte_help_open_file";
    assert_and_click "gte_help_bread_main";
    # Another screen
    assert_and_click "gte_help_search";
    assert_screen("gte_help_search_replace");
    assert_and_click "gte_help_bread_main";
}


sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
