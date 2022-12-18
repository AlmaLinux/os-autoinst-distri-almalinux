use base "installedtest";
use strict;
use testapi;
use utils;

# This script will delete contacts.

sub remove_contact {
    my $name = shift;
    # The name identifiers are made as hashes of their values,
    # let's hash the input to identify correct needles.
    my $identity = hashed_string($name);
    assert_and_click("contacts_contact_listed_$identity");
    wait_still_screen(2);
    assert_and_click(["gnome_button_delete", "contacts_contact_remove"]);
    wait_still_screen(2);
}

sub run {
    my $self = shift;
    # Wait to let everything settle.
    sleep 5;
    # One of the contact has always a grey background.
    # Let's click on Charles Dickens to make sure that
    # this one will be greyed out.
    my $identity = hashed_string("Charles Dickens");
    assert_and_click("contacts_contact_listed_$identity");

    # Check that all contacts are in the addressbook.
    assert_screen("contacts_contact_list_full");

    # Remove one of the contacts.
    remove_contact("John Keats");
    # Now assert that the removal was successful by checking
    # the list of contacts
    assert_and_click("contacts_contact_listed_$identity");
    assert_screen("contacts_contact_list_keatsless");

    # Remove more contacts at once.
    remove_contact("Walter Scott");
    remove_contact("Emily Bronte");
    remove_contact("Jane Austen");

    # Assert that the contacts have been successfully removed.
    assert_and_click("contacts_contact_listed_$identity");
    assert_screen("contacts_contact_list_emptied");
}

sub test_flags {
    # If this test fails, there is no need to continue.
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:



