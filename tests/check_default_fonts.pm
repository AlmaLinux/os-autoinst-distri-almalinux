use base "installedtest";
use strict;
use testapi;
use utils;

# This test cases automates the Testcase_i18n_default_fonts, see
# https://fedoraproject.org/wiki/QA:Testcase_i18n_default_fonts.

sub run {
    my $self = shift;

    # On the console, the fonts might differ than in GUI.
    # We will perform the tests in the gnome-terminal.
    # First, open it!
    desktop_switch_layout 'ascii';
    wait_still_screen(2);

    menu_launch_type("terminal");
    # Similarly to _graphical_input.pm, repeat running the command
    # if it fails the first time (it often does).
    unless (check_screen "apps_run_terminal", 30) {
        check_desktop;
        menu_launch_type("terminal");
    }
    assert_screen("apps_run_terminal");
    wait_still_screen(stilltime => 5, similarity_level => 42);

    # Run the test commands and record their output in the test file.
    enter_cmd("fc-match sans > test.txt");
    sleep(2);
    enter_cmd("fc-match serif >> test.txt");
    sleep(2);
    enter_cmd("fc-match monospace >> test.txt");
    sleep(2);

    # Depending on the selected language (Japanese or Arabic), we
    # will download a reference file and compare it with the test
    # file obtained in the previous step.

    my $language = get_var("LANGUAGE");
    my @supported = qw(japanese arabic);
    # If the language is among supported languages
    if ($language ~~ @supported) {
        # Go to root console for script assertions.
        $self->root_console(tty => 3);
        # Load us keys to be used on console
        script_run("loadkeys us");
        # Navigate to the home directory.
        my $username = get_var("USER_LOGIN") // "test";
        script_run("cd /home/$username/");
        # Download the language reference file.
        script_run("wget https://fedorapeople.org/groups/qa/openqa-fonts/$language-reference.txt");
        # upload the log for debugging.
        upload_logs "test.txt", failok => 1;
        # Compare the test file and the reference file.
        # We have been having a lot of failures on the Install Arabic test because of this
        # part, which is actually testing an optional test. Unfortunately, it is still
        # not clear what the current situation on Fedora should be and this will need
        # more investigation.
        # For now, let us softfail instead of fail until we know for sure how what the outcome
        # should be.
        my $exit = script_run("diff -u test.txt $language-reference.txt", timeout => 15);
        if ($exit != 0) {
            record_soft_failure("The default fonts differ from what is expected, see RBZ#2093080.");
        }
    }

    # For the rest of languages that are not currently defined, do nothing.
}

sub test_flags {
    return {fatal => 0};
}

1;

# vim: set sw=4 et:
