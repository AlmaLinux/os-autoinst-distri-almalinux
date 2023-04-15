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
    # use --enablerepo=fedora for Modular compose testing (we need to
    # create and use a non-Modular repo to get some packages which
    # aren't in Modular Server composes)
    # TODO: fedora repo not required, work with defaults
    assert_script_run "dnf repolist --all";
    my $extraparams = '--nodocs --setopt install_weak_deps=false ';
    # $extraparams = '--enablerepo=fedora' if (get_var("MODULAR"));
    # install a desktop and firefox so we can actually try it
    # GUI already installed
    #
    if (get_var("FLAVOR") =~ /minimal[-iso]?/) {
      assert_script_run "dnf ${extraparams} -y groupinstall 'base-x'", 420;
    }
    # FIXME: this should probably be in base-x...X seems to fail without
    assert_script_run "dnf ${extraparams} -y install libglvnd-egl", 180;
    # try to avoid random weird font selection happening
    assert_script_run "dnf ${extraparams} -y install dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts", 180;
    # since firefox-85.0-2, firefox doesn't seem to run without this
    assert_script_run "dnf ${extraparams} -y install dbus-glib", 180;
    assert_script_run "dnf ${extraparams} -y install firefox", 180;
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:
