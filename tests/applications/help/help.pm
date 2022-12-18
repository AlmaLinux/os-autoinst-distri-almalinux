use base "installedtest";
use strict;
use testapi;
use utils;

# This script check that Help can be used on Gnome.

# This subroutine opens a section, checks that its content
# is listed and returns to the main page.
sub visit_section {
    my $section = shift;
    send_key_until_needlematch("help_section_$section", "down", 40, 1);
    click_lastmatch();
    assert_screen("help_section_content_$section");
    assert_and_click("help_breadcrumbs_home");
    assert_screen("help_main_screen");
}

sub run {
    my $self = shift;

    # Run the application
    menu_launch_type("Help");
    assert_screen("help_main_screen", timeout => 60);

    # Let us click on Section to open it and check that there is content inside.
    visit_section("desktop");
    visit_section("networking");
    visit_section("sound");
    visit_section("files");
    visit_section("user");
    visit_section("hardware");
    visit_section("accessibility");
    visit_section("tipstricks");
    visit_section("morehelp");
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:

