use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    # upgrader should be installed on up-to-date system
    my $version = get_var("UP1REL");
    # ok this is dumb but I need to fix it fast and can't think of a
    # better way in a hurry. We want the pre-upgrade release version.
    my $testname = get_var("TEST");
    if (index($testname, "upgrade_2") != -1) {
        $version = get_var("UP2REL");
    }
    setup_workaround_repo $version;
    # disable updates-testing, this is needed for the case of upgrade
    # from branched to rawhide to ensure we don't get packages from
    # updates-testing for anything we do between here and upgrade_run
    disable_updates_repos(both => 0);
    assert_script_run 'dnf -y update --refresh', 1800;
    script_run "reboot", 0;

    # handle bootloader, if requested
    if (get_var("GRUB_POSTINSTALL")) {
        do_bootloader(postinstall => 1, params => get_var("GRUB_POSTINSTALL"), timeout => 120);
    }

    # decrypt if necessary
    if (get_var("ENCRYPT_PASSWORD")) {
        boot_decrypt(120);
    }

    boot_to_login_screen;
    $self->root_console(tty => 3);

    my $update_command = 'dnf -y install dnf-plugin-system-upgrade';
    assert_script_run $update_command, 600;
}


sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
