use base "installedtest";
use strict;
use testapi;

sub run {
    my $self = shift;
    # switch to tty and login as root
    $self->root_console(tty => 3);

    assert_screen "root_console";
    # check number of partitions
    script_run 'fdisk -l | grep /dev/vda';    # debug
    # AlmaLinux 10.x adds a BIOS Boot partition for BIOS+GPT installs,
    # so partcount is one more than Fedora (which uses MBR for BIOS x86_64).
    my $partcount = 5;
    if (get_var("ARCH") eq "ppc64le") {
        # AL9 ppc64le uses MBR with an extended partition holding /boot,
        # which gives 5 logical partitions = 6 fdisk lines.
        # AL10+ ppc64le uses GPT like x86_64, with 4 primary partitions
        # (PReP boot + / + /boot + swap) = 5 fdisk lines, the default.
        my @maj_ver = split(/\./, get_var("VERSION", ""));
        $partcount = 6 if (($maj_ver[0] // 0) < 10);
    }
    elsif (get_var("ARCH") eq "s390x") {
        # s390x uses Discoverable Partitions Spec layout: vda1=/, vda2=/boot,
        # vda3=swap. No BIOS Boot or PReP partition.
        $partcount = 4;
    }
    validate_script_output 'fdisk -l | grep /dev/vda | wc -l', sub { $_ =~ m/$partcount/ };
    # check mounted partitions are ext4 fs
    # In AlmaLinux 10.x standard auto-partition layout: vda1=BIOS Boot,
    # vda2=/, vda3=/boot, vda4=swap (matches Fedora vda2/vda3 mapping
    # offset by the BIOS Boot partition). On s390x: vda1=/, vda2=/boot.
    script_run 'mount | grep /dev/vda';    # debug
    if (get_var("ARCH") eq "s390x") {
        validate_script_output "mount | grep /dev/vda2", sub { $_ =~ m/on \/boot type ext4/ };
        validate_script_output "mount | grep /dev/vda1", sub { $_ =~ m/on \/ type ext4/ };
    }
    else {
        validate_script_output "mount | grep /dev/vda3", sub { $_ =~ m/on \/boot type ext4/ };
        validate_script_output "mount | grep /dev/vda2", sub { $_ =~ m/on \/ type ext4/ };
    }
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
