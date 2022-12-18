use base "installedtest";
use strict;
use testapi;
use utils;

# This script will test if Maps can show the About dialog.

sub run {
    my $location = shift;
    my $softfail = 0;

    # Go to menu and click on About.
    assert_and_click("gnome_burger_menu");
    assert_and_click("maps_menu_about");
    wait_still_screen(2);

    # Check that the About dialog is shown.
    assert_screen("maps_about_shown");

    # Check that you can visit application webpages
    assert_and_click("maps_link_website");
    assert_screen("maps_website_opened");

    # Close the web browser
    send_key("alt-f4");

    # Check that you can add a new issue
    assert_and_click("maps_link_issue");
    assert_screen("maps_issues_opened");

    # Close the web browser
    send_key("alt-f4");

    # Check that credits are shown.
    assert_and_click("maps_button_credits");
    assert_screen("maps_credits_shown");
    send_key("esc");

    # Check that legal info is shown.
    assert_and_click("maps_button_legal");
    assert_screen("maps_legal_shown");
    send_key("esc");
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:

