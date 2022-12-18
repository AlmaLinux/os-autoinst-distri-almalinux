use base "installedtest";
use strict;
use testapi;
use utils;

# Display Help.

sub run {
    my $self = shift;

    # Open help.
    send_key("f1");
    wait_still_screen 2;

    # Check that Help has been shown.
    assert_screen("nautilus_help_shown");

    # Open one of the topics.
    assert_and_click("nautilus_help_browse_files");

    # Check that a correct topic has been opened.
    assert_screen("nautilus_browse_shown");

    # Find a subtopic and open it links
    assert_and_click("nautilus_help_search_file");

    # Check that it opened
    assert_screen("nautilus_search_file_shown");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

