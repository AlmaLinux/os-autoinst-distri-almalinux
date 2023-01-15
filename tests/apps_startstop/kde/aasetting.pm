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
