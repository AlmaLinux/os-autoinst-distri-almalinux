use base "installedtest";
use strict;
use testapi;
use utils;

# This script will check if Help can be obtained.

sub run {
    my $self = shift;

    # Wait some time to settle down.
    sleep(5);
    # Press F1 to obtain the Help window
    send_key("f1");
    wait_still_screen(2);
    # Check various links
    assert_and_click("contacts_help_first_time");
    assert_screen("contacts_help_first_shown");
    assert_and_click("contacts_help_home");
    # Check another link
    assert_and_click("contacts_help_add_contact");
    assert_screen("contacts_help_add_shown");
    assert_and_click("contacts_help_home");
    # Check one more link
    assert_and_click("contacts_help_edit_contact");
    assert_screen("contacts_help_edit_shown");
    assert_and_click("contacts_help_home");
}

sub test_flags {
    # Rollback after the test.
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:



