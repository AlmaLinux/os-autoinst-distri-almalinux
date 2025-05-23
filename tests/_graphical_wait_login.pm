use base "installedtest";
use strict;
use testapi;
use utils;

sub _enter_password {
    my $password = shift;
    if (get_var("SWITCHED_LAYOUT")) {
        # see _do_install_and_reboot; when layout is switched
        # user password is doubled to contain both US and native
        # chars
        desktop_switch_layout 'ascii';
        type_very_safely $password;
        desktop_switch_layout 'native';
        type_very_safely $password;
    }
    else {
        type_very_safely $password;
    }
    send_key "ret";
}

sub run {
    my $self = shift;
    my $password = get_var("USER_PASSWORD", "weakpassword");
    my $version = get_var("VERSION");
    my $desktop = get_var("DESKTOP");
    # If KICKSTART is set, then the wait_time needs to consider the
    # install time. if UPGRADE, we have to wait for the entire upgrade
    # unless ENCRYPT_PASSWORD is set (in which case the postinstall
    # test does the waiting)
    my $wait_time = 400;
    $wait_time = 720 if ($desktop eq 'kde');
    $wait_time = 1800 if (get_var("KICKSTART"));
    $wait_time = 6000 if (get_var("UPGRADE") && !get_var("ENCRYPT_PASSWORD"));

    # handle bootloader, if requested
    if (get_var("GRUB_POSTINSTALL")) {
        do_bootloader(postinstall => 1, params => get_var("GRUB_POSTINSTALL"), timeout => $wait_time);
        $wait_time = 400;
    }

    # Handle pre-login initial setup if we're doing INSTALL_NO_USER
    if (get_var("INSTALL_NO_USER") && !get_var("_SETUP_DONE")) {
        if ($desktop eq 'gnome') {
            gnome_initial_setup(prelogin => 1, timeout => $wait_time);
        }
        else {
            anaconda_create_user(timeout => $wait_time);
            # wait out animation
            wait_still_screen 3;
            if (get_var('LIVE')) {
                unless (get_var("HDD_1") && !(get_var("PARTITIONING") eq "custom_resize_lvm")) {
                    mouse_hide;
                    # assert_screen "gdm_initial_setup_license", 120;
                    assert_and_click "gdm_initial_setup_license";
                    # Make sure the card has fully lifted until clicking on the buttons
                    wait_still_screen 5, 30;
                    assert_and_click "gdm_initial_setup_licence_accept";
                    assert_and_click "gdm_spoke_done";
                    # As well as coming back
                    wait_still_screen 5, 30;
                    assert_screen "gdm_initial_setup_license_accepted";
                    assert_and_click "gdm_initial_setup_spoke_forward";
                    wait_still_screen 3;
                }
            }
            # assert_and_click "initialsetup_finish_configuration";
            if (check_screen "initialsetup_finish_configuration",15) {
                click_lastmatch;
                wait_still_screen 3;
            }
            set_var("_SETUP_DONE", 1);
            if (get_var('LIVE') && $desktop eq 'kde') {
                assert_screen "graphical_login_input";
                wait_still_screen 5;
                _enter_password($password);
            }
        }
        $wait_time = 300;
    }
    # Wait for the login screen, unless we're doing a GNOME no user
    # install, which transitions straight from g-i-s to logged-in
    # desktop
    unless (($desktop eq 'gnome' || $desktop eq 'kde') && get_var("INSTALL_NO_USER")) {
        # for AlmaLinux 8 happens to be a license acceptance screen
        # the initial appearance can sometimes take really long
        if (get_version_major() < 9 || (get_var("LIVE") && $desktop eq 'kde')) {
            unless (get_var("HDD_1") && !(get_var("PARTITIONING") eq "custom_resize_lvm")) {
                mouse_hide;
                assert_screen "gdm_initial_setup_license", $wait_time;
                assert_and_click "gdm_initial_setup_license";
                # Make sure the card has fully lifted until clicking on the buttons
                wait_still_screen 5, 30;
                assert_and_click "gdm_initial_setup_licence_accept";
                assert_and_click "gdm_spoke_done";
                # As well as coming back
                wait_still_screen 5, 30;
                assert_screen "gdm_initial_setup_license_accepted";
                assert_and_click "gdm_initial_setup_spoke_forward";
            }
        }
        if (get_var('ARCH') eq 's390x') {
            $wait_time = 1200;
            boot_to_login_screen(timeout => $wait_time);
        }
        else {
            boot_to_login_screen(timeout => $wait_time);
        }
        # if USER_LOGIN is set to string 'false', we're done here
        return if (get_var("USER_LOGIN") eq "false");

        # GDM 3.24.1 dumps a cursor in the middle of the screen here...
        mouse_hide;

        if ($desktop eq 'gnome') {
            my $timeout = 5;
            $timeout = 1200 if (get_var('ARCH') eq 's390x');
            if (!check_screen "graphical_login_input", $timeout) {
                if (get_version_major() > 8) {
                    if (get_var('ARCH') eq 's390x') {
                        send_key_until_needlematch("graphical_login_test_user_highlighted", "tab", 5, 30);
                    }
                    else {
                        send_key_until_needlematch("graphical_login_test_user_highlighted", "tab", 5);
                    }
                    click_lastmatch;
                    # assert_and_click "graphical_login_test_user_highlighted";
                }
                # we have to hit enter to get the password dialog, and it
                # doesn't always work for some reason so just try it three
                # times
                send_key_until_needlematch("graphical_login_input", "ret", 3, 5);
            }
        }
        assert_screen "graphical_login_input";
        # seems like we often double-type on aarch64 if we start right
        # away
        # assert_and_click('gdm_session_selection', timeout => 30, button => 'left');
        # assert_and_click('gdm_session_select_x11', timeout => 30, button => 'left');
        wait_still_screen 5;
        # mouse_set(132, 25);
        # mouse_click('left');
        _enter_password($password);
        # it takes take time on ppc64le arch
        if (get_var("ARCH" eq "ppc64le")) {
            # sleep 90;
            wait_still_screen 60;
        }
        elsif (get_var('ARCH') eq 's390x') {
            wait_still_screen(60);
        }
    }

    # For GNOME, handle initial-setup or welcome tour, unless _WELCOME_DONE
    # is set (indicating it's been done previously within this test run,
    # e.g. the second time this module runs on the update flow, or earlier
    # in the boot process on the INSTALL_NO_USER flow), or START_AFTER_TEST
    # is set to the same value as DEPLOY_UPLOAD_TEST (in which case it will
    # have been done by the previous test run)
    # the point of the default values here is to make the check fail if
    # neither var is set, without needing an extra condition
    my $sat = get_var("START_AFTER_TEST", "1");
    my $dut = get_var("DEPLOY_UPLOAD_TEST", "2");
    handle_welcome_screen if ($desktop eq 'gnome' && $sat ne $dut && !get_var("_WELCOME_DONE"));
    if (get_var("IMAGE_DEPLOY")) {
        # if this was an image deployment, we also need to create
        # root user now, for subsequent tests to work
        send_key "ctrl-alt-f3";
        console_login(user => get_var("USER_LOGIN", "test"), password => get_var("USER_PASSWORD", "weakpassword"));
        type_string "sudo su\n";
        type_string "$password\n";
        my $root_password = get_var("ROOT_PASSWORD") || "weakpassword";
        assert_script_run "echo 'root:$root_password' | chpasswd";
        desktop_vt;
    }

    # Move the mouse somewhere it won't highlight the match areas
    mouse_set(300, 800);
    # KDE can take ages to start up
    if (get_var('ARCH') eq 's390x') {
        check_desktop(timeout => 1200);
    }
    else {
        check_desktop(timeout => 120);
    }
    # Check for Display Protocol (Wayland or Xorg/X11)
    # send_key('alt-f2');
    # type_string('gnome-control-center');
    # send_key('ret');
    # send_key('super-up');
    # send_key('ctrl-s');
    # type_string('About');
    # assert_and_click('gnome_control_center_about', timeout => 30, button => 'left');
    # assert_screen('gnome_session_xorg');
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
