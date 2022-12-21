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
    # number or partitions  + disk summary line
    # TODO: need better handle of partion number 
    my $partcount = 4;
    my $partname = "vda1";
    my $machine = get_var("MACHINE");
    if ( $machine eq "uefi") {
        $partcount = 5;
        $partname = "vda2"
    }
    validate_script_output 'fdisk -l | grep /dev/vda | wc -l', sub { $_ =~ m/$partcount/ };
    # check mounted partitions are ext4 fs
    script_run 'mount | grep /dev/vda';    # debug, /dev/vda3 is swap partition
    validate_script_output "mount | grep /boot", sub { $_ =~ m/on \/boot type ext4/ };
    validate_script_output "mount | grep /dev/$partname", sub { $_ =~ m/on \/ type ext4/ };
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
