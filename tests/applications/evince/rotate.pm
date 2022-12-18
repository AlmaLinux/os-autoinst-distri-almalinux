use base "installedtest";
use strict;
use testapi;
use utils;

# This part of the suite tests that Evince can rotate the content.

sub rotate_content {

    # Send the key combo to rotate the content
    send_key("ctrl-right");
}

sub run {
    my $self = shift;

    # Rotate the content once.
    rotate_content();

    # Check that the window content has been rotated.
    assert_screen("evince_content_rotated_once", timeout => 30);

    # Rotate the content again.
    rotate_content();

    # Check that the window content has been rotated.
    assert_screen("evince_content_rotated_twice", timeout => 30);
}

sub test_flags {
    return {always_rollback => 1};
}

1;
