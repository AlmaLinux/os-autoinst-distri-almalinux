use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    # If UPGRADE is set, we have to wait for the entire upgrade
    my $wait_time = 300;
    $wait_time = 6000 if (get_var("UPGRADE"));

    # handle bootloader, if requested
    if (get_var("GRUB_POSTINSTALL")) {
        do_bootloader(postinstall => 1, params => get_var("GRUB_POSTINSTALL"), timeout => $wait_time);
        $wait_time = 240;
    }

    if ((get_var("FLAVOR") eq "boot-iso" || get_var("FLAVOR") eq "dvd-iso")  && (get_var("DEPLOY_UPLOAD_TEST") eq "install_default_upload")) {
        sleep $wait_time;
        # console login requested on a graphical install, switch to console and logout 
        if (check_screen "gdm_initial_setup_license", 5) {
            # for AlmaLinuxere happens to be a license acceptance screen
            # the initial appearance can sometimes take really long
            assert_screen "gdm_initial_setup_license", 120;
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
        # If user not installed
        if (get_var("INSTALL_NO_USER")) {
            console_initial_setup;
        }
        $self->root_console(tty => 3);
        sleep 10;
        type_string "logout\n";
        # Wait a bit to let the logout properly finish.
        sleep 10;
        $wait_time = 90;
    } else {
    # OLD PATH
    # handle initial-setup, if we're expecting it (ARM disk image)
        if (get_var("INSTALL_NO_USER")) {
            console_initial_setup;
        }
    }
    # Wait for the text login
    boot_to_login_screen(timeout => $wait_time);

    # do user login unless USER_LOGIN is set to string 'false'
    unless (get_var("USER_LOGIN") eq "false") {
        # this avoids us waiting 90 seconds for a # to show up
        my $origprompt = $testapi::distri->{serial_term_prompt};
        $testapi::distri->{serial_term_prompt} = '$ ';
        console_login(user => get_var("USER_LOGIN", "test"), password => get_var("USER_PASSWORD", "weakpassword"));
        $testapi::distri->{serial_term_prompt} = $origprompt;
    }
    if (get_var("ROOT_PASSWORD")) {
        console_login(user => "root", password => get_var("ROOT_PASSWORD"));
    }
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
