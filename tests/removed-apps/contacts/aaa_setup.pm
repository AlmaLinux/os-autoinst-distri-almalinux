use base "installedtest";
use strict;
use testapi;
use utils;

# This script will start the Gnome Contacts application and save the status
# for any subsequent tests.

sub run {
    my $self = shift;

    # Start the Application
    menu_launch_type("contacts");
    assert_screen ["apps_run_contacts", "grant_access"];
    # give access rights if asked
    if (match_has_tag 'grant_access') {
        click_lastmatch;
        assert_screen 'apps_run_contacts';
    }

    # When run for the first time, we need to select
    # the source where to store our contacts.
    # Select Local addressbook and confirm.
    assert_and_click("contacts_select_local_addressbook");
    assert_and_click("gnome_button_done");

    # Make it fill the entire window.
    send_key("super-up");
    wait_still_screen(2);
}

sub test_flags {
    # If this test fails, there is no need to continue.
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:

