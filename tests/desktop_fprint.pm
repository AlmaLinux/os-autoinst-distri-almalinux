use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    # at this point we have already reached @benzea's step 1:
    # "Login without a (fingerprint) reader"
    my $self = shift;
    my $user = get_var("USER_LOGIN", "test");
    $self->root_console(tty => 6);
    script_run 'dnf -y install socat', 180;
    assert_script_run 'mkdir -p /etc/systemd/system/fprintd.service.d';
    # configure fprintd dummy reader, see
    # https://pagure.io/fedora-qa/os-autoinst-distri-fedora/issue/223#comment-732426
    assert_script_run 'printf \'[Service]\nEnvironment=G_MESSAGES_DEBUG=all\nEnvironment=FP_VIRTUAL_DEVICE=%%t/fprintd-virt\nReadWritePaths=%%t\nDeviceAllow=\' > /etc/systemd/system/fprintd.service.d/dummy.conf';
    # dummy reader needs SELinux permissive
    assert_script_run 'printf "SELINUX=permissive\nSELINUXTYPE=targeted" > /etc/selinux/config';
    # now we reboot and go onto step 2:
    # "Login with a reader, but no enrolled prints"
    type_string "reboot\n";
    # assert_screen "graphical_login", 180;
    if (check_screen "graphical_login", 180) {
        assert_and_click "graphical_login"
    }
    mouse_hide;
    send_key_until_needlematch("graphical_login_input", "ret", 3, 5);
    type_very_safely "weakpassword";
    send_key "ret";
    check_desktop(timeout => 60);
    wait_still_screen 10;
    $self->root_console(tty => 5);
    # now we enroll a fingerprint, we run the enrol process on tty5...
    type_string "fprintd-enroll $user\n";
    sleep 2;
    $self->root_console(tty => 6);
    # ...and do the scans (we need exactly 5) on tty4.
    for my $n (1 .. 5) {
        assert_script_run "echo SCAN $user-finger-1 | socat STDIN UNIX-CONNECT:/run/fprintd-virt";
    }
    # now we will reboot and do step 3:
    # "Login using fingerprint"
    type_string "reboot\n";
    assert_screen "graphical_login", 180;
    $self->root_console(tty => 6);
    # the GDM tty needs to be active when the scan happens, so we will
    # schedule the scan to happen in 20 seconds then go deal with gdm
    type_string "sleep 20; echo SCAN $user-finger-1 | socat STDIN UNIX-CONNECT:/run/fprintd-virt\n";
    send_key "ctrl-alt-f1";
    mouse_hide;
    send_key_until_needlematch("graphical_login_test_user_highlighted", "tab", 3, 5);
    # assert_and_click "graphical_login_test_user_highlighted"
    send_key_until_needlematch("graphical_login_input", "ret", 3, 5);
    # now we check that we see the "or scan fingerprint" message, then
    # just wait for the scan to happen and login to succeed
    assert_screen "graphical_login_fprint";
    check_desktop(timeout => 60);
    $self->root_console(tty => 6);
    # now we will reboot again and do step 4:
    # "Password login after failed fingerprint login"
    type_string "reboot\n";
    assert_screen "graphical_login", 180;
    $self->root_console(tty => 6);
    # we're doing the same as before, but scanning the 'wrong thing'
    # (note finger-2 not finger-1)
    type_string "sleep 20; echo SCAN $user-finger-2 | socat STDIN UNIX-CONNECT:/run/fprintd-virt\n";
    send_key "ctrl-alt-f1";
    mouse_hide;
    if (check_screen "graphical_login", 180) {
        assert_and_click "graphical_login"
    }
    send_key_until_needlematch("graphical_login_input", "ret", 3, 5);
    assert_screen "graphical_login_fprint";
    # unfortunately we cannot assert the 'scan failed' message as it
    # does not appear for long enough, so we just have to sleep
    # another 20 seconds to be sure the scan has happened...
    sleep 20;
    # ...and check we're still at the login prompt, then type password
    assert_screen "graphical_login_input";
    type_very_safely "weakpassword";
    send_key "ret";
    check_desktop(timeout => 60);
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
