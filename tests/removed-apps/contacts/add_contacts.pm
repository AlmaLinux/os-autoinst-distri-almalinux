use base "installedtest";
use strict;
use testapi;
use utils;

# This script will add contacts and upload an image,
# so that other tests could modify or delete them.

# We will be adding several contacts, so let us
# create a subroutine to handle the process.

sub add_contact {
    my ($name, $number, $email, $emailtype) = @_;
    # Click the plus button to add a contact
    assert_and_click("gnome_add_button_plus");
    # Add the name
    assert_and_click("contacts_entry_add_name");
    type_very_safely($name);
    # Press TAB to move further.
    send_key("tab");
    # Add email
    type_very_safely($email);
    # Press TAB to move to another widget setting the label.
    send_key("tab");
    # Open the pull down menu using the Enter key.
    send_key("ret");
    # Click on the selected type
    assert_and_click("contacts_label_$emailtype");
    # Ensure we're on the phone number entry field.
    assert_and_click("contacts_entry_add_phone");
    type_very_safely($number);
    # Use the Add button to add into the contacts.
    assert_and_click("gnome_add_button");
    my $identifier = hashed_string($name);
    assert_screen("contacts_contact_added_$identifier");
}

sub run {
    my $self = shift;
    # Wait to let everything settle.
    sleep 5;
    add_contact("Charles Dickens", "555-0702-1812", 'c.dickens@victorian.co.uk', "work");
    add_contact("Emily Bronte", "444-3006-1818", 'e.bronte@wuthering-heights.com', "home");
    add_contact("Walter Scott", "333-1508-1771", 'scottie@waverly.co.uk', "personal");
    add_contact("Jane Austen", "777-1612-1775", 'jane.austen@darcyhome.org', "home");
    add_contact("Mary Shelley", "888-3008-1800", 'mary.s@frankenstein.de', "work");
    add_contact("John Keats", "999-3110-1795", 'john@keats.edu', "personal");
}

sub test_flags {
    # If this test fails, there is no need to continue.
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:

