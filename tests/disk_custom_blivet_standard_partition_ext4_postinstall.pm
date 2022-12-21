use base "installedtest";
use strict;
use testapi;

sub run {
    assert_screen "root_console";
    # check number of partitions
    script_run 'fdisk -l | grep /dev/vda';    # debug
    validate_script_output 'fdisk -l | grep /dev/vda | wc -l', sub { $_ =~ m/4/ };
    # check mounted partitions are ext4 fs
    script_run 'mount | grep /dev/vda';    # debug
    validate_script_output "mount | grep /boot", sub { $_ =~ m/on \/boot type ext4/ };
    validate_script_output "mount | grep /dev/vda3", sub { $_ =~ m/on \/ type ext4/ };
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
