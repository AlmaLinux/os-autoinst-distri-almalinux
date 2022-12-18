use base "installedtest";
use strict;
use testapi;
use utils;

# This script will open an existing contact and it edit
# existing contacts.

sub edit_contact {
    my ($name, $number, $email) = @_;
    # The name identifiers are made as hashes of their values,
    # let's hash the input to identify correct needles.
    my $identity = hashed_string($name);
    # Click to select the contact based on the chosen name.
    assert_and_click("contacts_contact_listed_$identity");
    wait_still_screen(2);
    # Check the current values.
    assert_screen("contacts_contact_existing_$identity");
    # Click on the Edit button.
    assert_and_click("gnome_button_edit");
    # Click on the name line to get focus into the window.
    assert_and_click("contacts_name_$identity");
    # Press Tab until the email edit line is reached.
    send_key_until_needlematch("contact_edit_email", "tab", 30, 1);
    # Press Ctrl-A to select everything.
    send_key("ctrl-a");
    # Write a new email.
    type_very_safely($email);
    # Send the TAB key until the edit line for phone is reached.
    send_key_until_needlematch("contacts_edit_phone", "tab", 30, 1);
    # Type the new number.
    type_very_safely($number);
    # Click on the Done button to finish editting.
    assert_and_click("gnome_button_done");
    wait_still_screen(2);
    # Currently (20220801), Contacts add empty contacts when editting
    # them. Let's check if such a contact was created and let us know.
    if (check_screen("contacts_contact_doubled_$identity")) {
        record_soft_failure("Editting the contact created a double entry. This is a known issue.");
        # Click on that doubled contact and delete it, if it looks empty.
        while (check_screen("contacts_contact_listed_$identity")) {
            click_lastmatch();
            if (check_screen("contacts_contact_altered_$identity")) {
                last;
            }
            else {
                assert_and_click("gnome_button_delete");
                record_info("Contact empty", "This contact is empty - deleting it.");
            }
        }
    }
    elsif (check_screen("contacts_unnamed_person")) {
        record_soft_failure("Unnamed Person shown after contact edit: https://gitlab.gnome.org/GNOME/gnome-contacts/-/issues/271");
        assert_and_click("contacts_contact_listed_$identity");
    }
    # Check that the original values are no longer present and die if they are.
    if (check_screen("contacts_contact_existing_$identity")) {
        die("The contact information seem not to have been updated.");
    }
    else {
        # Check that new values are present
        assert_screen("contacts_contact_altered_$identity");
    }
}

sub run {
    my $self = shift;
    # Wait to let everything settle.
    sleep 5;

    # Edit contact for Mary Shelley
    edit_contact("Jane Austen", "789-456-1223", 'jane.austen@sensibility.org');
    edit_contact("Walter Scott", "111-222-3333", 'flying.scottsman@fedoraproject.org');
    edit_contact("John Keats", "333-222-1111", 'keats@romance.co.uk');
}

sub test_flags {
    # If this test fails, there is no need to continue.
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:




