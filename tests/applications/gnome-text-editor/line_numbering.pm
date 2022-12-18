use base "installedtest";
use strict;
use testapi;
use utils;

# This part tests that we can do line numbering,
# line navigation, line highlighting and show side and bottom panels.

sub run {
    my $self = shift;

    # Switches on line numbering.
    assert_and_click "gte_settings_button";
    wait_still_screen(3);
    assert_and_click "gte_display_line_numbers";
    assert_screen "gte_lines_numbered";

    # Highlights the current line.
    # Use the menu to switch on highlighting.
    assert_and_click("gnome_burger_menu");
    assert_and_click("gte_preferences_submenu");
    assert_and_click("gte_toggle_line_highlight");
    # Dismiss the menu
    assert_and_click("gte_preferences_off");
    # Assert that it worked.
    assert_screen "gte_line_highlighted";

    # Displays the right margin.
    assert_and_click "gte_settings_button";
    assert_and_click "gte_display_margin";
    assert_screen "gte_margin_displayed";

    # Display the side panel.
    assert_and_click("gnome_burger_menu");
    assert_and_click("gte_preferences_submenu");
    assert_and_click("gte_toggle_side_panel");
    assert_and_click("gte_preferences_off");
    assert_screen "gte_side_panel_on";

    # Display the grid.
    assert_and_click("gnome_burger_menu");
    assert_and_click("gte_preferences_submenu");
    assert_and_click("gte_toggle_grid");
    assert_and_click("gte_preferences_off");
    assert_screen "gte_grid_on";
}


sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
