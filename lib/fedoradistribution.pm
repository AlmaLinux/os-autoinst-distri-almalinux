package fedoradistribution;

use strict;

use base 'distribution';
use Cwd;

# Fedora distribution class

# Distro-specific functions, that are actually part of the API
# (and it's completely up to us to implement them) should be here

# functions that can be reimplemented:
# ensure_installed (reimplemented here)
# x11_start_program (reimplemented here)
# become_root (reimplemented here)
# script_sudo (reimplemented here)
# assert_script_sudo (reimplemented here
# type_password (works as is)

# importing whole testapi creates circular dependency, so import only
# necessary functions from testapi
use testapi qw(check_var get_var send_key type_string assert_screen check_screen assert_script_run validate_script_output enter_cmd type_password);
use utils qw(console_login desktop_vt menu_launch_type);

# Class constructor
sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new(@_);

    # script_run requires this to be set distri-wide or specified on
    # each invocation, it tells os-autoinst what to do if a script_run
    # times out (rather than succeeding or failing)
    $self->{script_run_die_on_timeout} = 1;
    return $self;
}

sub init() {
    my ($self) = @_;

    $self->SUPER::init();
    # Initialize the first virtio serial console as "virtio-console"
    if (check_var('BACKEND', 'qemu')) {
        $self->add_console('virtio-console', 'virtio_terminal', {});
        for (my $num = 1; $num < get_var('VIRTIO_CONSOLE_NUM', 1); $num++) {
            # initialize second virtio serial console as
            # "virtio-console1", third as "virtio-console2" etc.
            $self->add_console('virtio-console' . $num, 'virtio_terminal', {socked_path => cwd() . '/virtio_console' . $num});
        }
    }
}

# This routine should be able to start a graphical application in various DEs
# across Fedora, as it uses the Alt-F2 combination that is known to work
# similarly everywhere, maybe not in i3 or sway, but we do not test them so often anyway.
# If this should change in the future, we would need to enhance this routine.
sub x11_start_program {
    my ($self, $program, $timeout, $options) = @_;
    send_key "alt-f2";
    assert_screen "desktop_runner";
    type_string $program, 20;
    sleep 5;    # because of KDE dialog - SUSE guys are doing the same!
    send_key "ret", 1;
}

# ensure_installed checks if a package is already installed and if not install it.
# To make it happen, it will switch to a virtual terminal (if not already there)
# and try to install the package. DNF will skip the installation,
# if it is already installed.
sub ensure_installed {
    my ($self, @packages) = @_;
    # First, let's assume that we are in the virtual console and that we want to stay there
    # when the routine finishes.
    my $stay_on_console = 1;
    # We will check if GUI elements are present, that would suggest that we are not in the
    # console but in GUI.
    if (check_screen("apps_menu_button")) {
        # In that case, we want to return to GUI after the routine finishes.
        $stay_on_console = 0;
        # From GUI we need to switch to the console.
        send_key("ctrl-alt-f3");
        # Let's wait to allow for screen changes.
        sleep 5;
        # And do the login.
        console_login();
    }
    # Try to install the packages via dnf. If it is already installed, DNF will not do anything
    # so there is no need to do any complicated magic.
    assert_script_run("dnf install -y @packages", timeout => 240);
    # If we need to leave the console.
    if ($stay_on_console == 0) {
        desktop_vt();
    }
}

# This subroutine switches to the root account.
# On Fedora, the system can be installed with a valid root account (root password assigned)
# or without it (with root password empty). If no root password is provided through environment
# variables, we assume that the system is a "rootless" system. In that case we will use
# `sudo -i` to acquire the administrator access.
sub become_root {
    # If ROOT_PASSWORD exists, it means that the root account exists, too.
    # To become root, we will use the real root account and we'll switch to it.
    if (check_var("ROOT_PASSWORD")) {
        my $password = get_var("ROOT_PASSWORD");
        enter_cmd("su -", max_interval => 15, wait_screen_changes => 3);
        type_password($password, max_interval => 15);
        send_key("ret");
    }
    # If no root password is set, it means, that we are only using an administrator
    # who is in the wheel group and therefore we will use the sudo command to obtain
    # the admin rights.
    else {
        my $password = get_var("USER_PASSWORD") || "weakpassword";
        enter_cmd("sudo -i", max_interval => 15, wait_screen_changes => 3);
        # The SUDO warning might be displayed so let's wait it out a bit.
        sleep 2;
        type_password($password, max_interval => 15);
        send_key("ret");
    }
    sleep 2;
    # Now we should be root. Let's check for root prompt.
    assert_screen("root_logged_in");
}

# This routine is adapted from the SuSE distribution file.
# There are two differences however. To save a needle,
# we actually call the `sudo -k` command instead plain sudo to always
# require a password. Then, we do not need to check for
# password prompt and and we can provide the password any time.
# Also, the routine uses the serial console to check for messages
# passed to it after the command has finished to save some time.
# The serial console is only accessible for the root user, so that
# mechanism does not work when not root (why would anyone use sudo
# if they were root already anyway).
# To override this, call `make_serial_writable` from `utils.pm` in the
# beginning of the test script to enable serial console for normal users.
sub script_sudo {
    my ($self, $prog, $wait) = @_;

    # If $wait is not assigned, let's make it 10 seconds to give some
    # time to the commands to finish.
    $wait //= 10;

    my $str;
    if ($wait > 0) {
        # Create a uniqe hash from the command and the wait time.
        $str = testapi::hashed_string("SS$prog$wait");
        # Chain the commands to pass the message to the serial console.
        $prog = "$prog; echo $str > /dev/$testapi::serialdev";
    }
    # Run the command with `sudo -k`
    type_string "sudo -k $prog\n";
    # Put a user password (we might not know the root password anyway)
    my $password = get_var("USER_PASSWORD") || "weakpassword";
    type_password($password);
    send_key "ret";
    # Wait for the message hash to appear on the serial console which indicates
    # that the command has finished. No matter what time has passed, finish
    # or die if no message appears on time.
    if ($str) {
        return testapi::wait_serial($str, $wait);
    }
    send_key("ret");
    return;
}

# Run the script with sudo and check the exit code after it has run.
# See the script_sudo subroutine for details.
sub assert_script_sudo {
    my ($self, $prog, $wait) = @_;
    script_sudo($prog, $wait);
    # Validate that the command exited with a correct exit code.
    validate_script_output('echo $?', sub { $_ == 0 });
    return;
}

1;
# vim: set sw=4 et:
