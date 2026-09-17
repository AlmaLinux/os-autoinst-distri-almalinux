use base "installedtest";
use strict;
use testapi;
use utils;

# This sets the KDE desktop background to plain black, to avoid
# needle match problems caused by transparency.

sub run {
    my $self = shift;
    solidify_wallpaper;
    # get rid of unwanted notifications that interfere with tests
    click_unwanted_notifications;
    # The installed KDE session autostarts Plasma's welcome centre, which
    # opens a browser on community.kde.org and keeps the focus. Every later
    # test rolls back to the snapshot this module leaves behind, so that
    # window would be in front for all of them: menu_launch_type would type
    # the application name into the browser instead of the launcher, and
    # the <app>_runs needles would be looking at a web page. Close it here.
    unless (check_screen "workspace", 5) {
        send_key 'alt-f4';
        wait_still_screen 3;
        # a browser holding more than one tab asks before closing
        if (check_screen "firefox_close_tabs", 5) {
            click_lastmatch;
            wait_still_screen 3;
        }
        send_key_until_needlematch("workspace", 'alt-f4', 4, 3);
    }
    if (get_version_major() < 9) {
        # Switch to console, Live does not have abrt package installed, 
        # so install before testing 
        $self->root_console(tty => 3);
        # Perform git test
        check_and_install_software("abrt-desktop akregator ark");
        # Exit the terminal
        desktop_vt;
    }
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}


1;

# vim: set sw=4 et:
