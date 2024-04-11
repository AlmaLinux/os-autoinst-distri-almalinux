use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    if (not(check_screen "root_console", 0)) {
        $self->root_console(tty => 4);
    }
    assert_screen "root_console";
    # for aarch64 non-english tests
    console_loadkeys_us;
    # this test shows if the system is booted with efi
    assert_script_run '[ -d /sys/firmware/efi/ ]';
    # check if Secure Boot is working
    validate_script_output('mokutil --sb-state', qr/SecureBoot enabled/, title => 'Secure Boot check', fail_message => 'Secure Boot is not working.') if get_var('ARCH') eq 'x86_64';
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
