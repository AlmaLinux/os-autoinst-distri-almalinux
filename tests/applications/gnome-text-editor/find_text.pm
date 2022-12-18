use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests that a piece of test can be found, that highlighting can be removed again,
# that search and replace can be used, that misspelt words can be highlighted, and
# that spelling control can be used to find and replace spelling mistakes.

sub run {
    my $self = shift;
    # Search the text for specific string.
    # At first, Wait 1 second for the test to get ready, as the control character was not properly recognized
    # when the test started immediately after the rollback.
    sleep 1;
    # Invoke the Find dialogue
    send_key "ctrl-f";
    # Type string
    type_very_safely "sweetest";
    # Confirm
    send_key "ret";
    sleep 2;
    send_key "esc";
    # Check that correct word is highlighted.
    assert_screen "gte_found_text";

    # This tests that a highlight can be removed from a search result.
    # Use combo for removing the highlighting.
    send_key "ctrl-end";
    # Check that the highlighting was removed.
    assert_screen "gte_text_added";

    # We will continue to search and replace a piece of text.
    # Open Switch and replace
    send_key "ctrl-h";
    sleep 1;
    # Type string.
    type_very_safely "Gale";
    # Click to get onto the replace line.
    assert_and_click("gte_replace_line");
    # Delete, what is typed there
    send_key("ctrl-a");
    sleep 1;
    send_key("delete");
    # Type replacement string. We purposefully produce a typo.
    type_very_safely "Wiend";
    # Click to find the string
    assert_and_click "gte_find_next_occurence";
    # and replace it.
    assert_and_click "gte_replace_occurence";
    # Get rid of the screen.
    send_key("ctrl-f");
    send_key("esc");
    # Move the cursor away
    send_key("ctrl-end");
    sleep 1;
    # Check that the string was replaced.
    assert_screen "gte_text_replaced";
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
