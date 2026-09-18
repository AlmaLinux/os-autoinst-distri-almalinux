use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    check_desktop;
    # KDE opens the Plasma welcome window over the desktop at first login
    # of the installed system, and it sits squarely on top of the wallpaper
    # this test exists to look at. apps_startstop closes it the same way
    # before taking its milestone snapshot. Guarded by the needle so a
    # desktop without it is never sent a stray alt-f4.
    if (get_var("DESKTOP", "") eq "kde") {
        for (1 .. 4) {
            last unless check_screen("kde_welcome", 5);
            send_key "alt-f4";
            wait_still_screen 3;
        }
    }
    # If we want to check that there is a correct background used, as a part
    # of self identification test, we will do it here. For now we don't do
    # this for Rawhide as Rawhide doesn't have its own backgrounds and we
    # don't have any requirement for what background Rawhide uses.
    my $version = get_var('VERSION');
    my $rawrel = get_var('RAWREL');
    assert_screen "${version}_background" if ($version ne "Rawhide" && $version ne $rawrel);
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
