use base "anacondatest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    select_rescue_mode;
    # select rescue shell and expect shell prompt
    type_string "3\n";
    send_key "ret";
    assert_screen "root_console", 5;    # should be shell prompt

    # TODO: Remove "-iso" from boot, minimal and dvd flavors.
    # Enable networking on AlmaLinux 8 minimal and dvd ISOs
    $self->enable_network if ((get_var('FLAVOR') =~ /(minimal|dvd)(-iso)?/) && (get_var('VERSION') =~ /8.([3-9]|[1-9][0-9])/));

    assert_script_run "fdisk -l | head -n20";
    assert_script_run "mkdir -p /hd";
    assert_script_run "mount /dev/vdb1 /hd";
    copy_devcdrom_as_isofile('/hd/almalinux_image.iso');
    assert_script_run "umount /hd";
    type_string "exit\n";    # leave rescue mode.
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
