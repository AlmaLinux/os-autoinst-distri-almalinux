use base "installedtest";
use strict;
use testapi;

sub run {
    my $self = shift;
    # switch to tty and login as root
    $self->root_console(tty => 3);

    assert_screen "root_console";
    # mount first partition and check that it's intact
    assert_script_run 'mount /dev/vda1 /mnt';
    validate_script_output 'cat /mnt/testfile', sub { $_ =~ m/Hello, world!/ };
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
