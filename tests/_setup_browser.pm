use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    if (not(check_screen "root_console", 0)) {
        $self->root_console(tty => 3);
    }
    # set up appropriate repositories
    repo_setup();
    assert_script_run "dnf repolist --all";
    my $extraparams = '--nodocs --setopt install_weak_deps=false ';

    my @major_version = split(/\./, get_var('VERSION'));

    if (get_var("FLAVOR") =~ /minimal[-iso]?/) {
        if ($major_version[0] >= 10) {
            # AlmaLinux 10 dropped Xorg server entirely (no base-x group,
            # no xorg-x11-server-Xorg, no startx). Use gnome-kiosk: a minimal
            # Wayland compositor that runs a single app fullscreen and
            # renders to TTY via KMS/DRM, which the openQA VGA capture sees.
            assert_script_run "dnf ${extraparams} -y install gnome-kiosk dbus-daemon", 600;
        } else {
            assert_script_run "dnf ${extraparams} -y groupinstall 'base-x'", 420;
        }
    }
    # libglvnd-egl present on EL10 too (in AppStream)
    assert_script_run "dnf ${extraparams} -y install libglvnd-egl", 180;
    # try to avoid random weird font selection happening
    assert_script_run "dnf ${extraparams} -y install dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts", 180;
    # dbus-glib was dropped in EL10. Firefox 140 no longer needs it.
    if ($major_version[0] < 10) {
        assert_script_run "dnf ${extraparams} -y install dbus-glib", 180;
    }
    assert_script_run "dnf ${extraparams} -y install firefox", 180;
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:
