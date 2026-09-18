use base "installedtest";
use strict;
use testapi;
use utils;

# This test collects the results of application registration (presence or absence).

sub run {
    my $self = shift;
    $self->root_console(tty => 3);

    # List of applications, that we want to track for their presence.
    my @core_applications = ("gnome-software", "firefox", "nautilus");
    # GNOME Terminal belongs in this set only where it is actually shipped
    # and its own test runs. AlmaLinux 10 replaced it with Ptyxis, so the
    # terminal test is not loaded there and nothing ever registers
    # gnome-terminal: requiring it would fail this test over an application
    # that is not on the medium. Testing Ptyxis in its place would need a
    # needle for it and is worth doing separately.
    push(@core_applications, "gnome-terminal") if (get_version_major() < 10);

    # Evaluate the results, make the log files and pass or fail the entire
    # test suite.
    my $failed;
    foreach my $app (@core_applications) {
        # @utils::application_list here is the list of registered apps
        if (grep { $_ eq $app } @utils::application_list) {
            assert_script_run "echo '$app=passed' >> registered.log";
        }
        else {
            assert_script_run "echo '$app=failed' >> registered.log";
            $failed = 1;
        }
    }
    upload_logs "registered.log", failok => 1;
    die "Some core applications could not be started. Check logs." if ($failed);
}

sub test_flags {
    return {fatal => 1};
}


1;

# vim: set sw=4 et:
