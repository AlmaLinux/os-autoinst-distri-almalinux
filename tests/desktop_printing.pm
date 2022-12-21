use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    my $usecups = get_var("USE_CUPS");
    # Prepare the environment for the test.
    #
    # Some actions need a root account, so become root.
    $self->root_console(tty => 3);

    # Create a text file, put content to it to prepare it for later printing.
    script_run "cd /home/test/";
    assert_script_run "echo 'A quick brown fox jumps over a lazy dog.' > testfile.txt";
    # Make the file readable and for everybody.
    script_run "chmod 666 testfile.txt";

    # If the test should be running with CUPS-PDF, we need to install it first.
    if ($usecups) {
        # Install the Cups-PDF package to use the Cups-PDF printer
        # Needed epel-release repo for cups-pdf package
        assert_script_run "dnf -y install epel-release", 150; 
        assert_script_run "dnf -y install cups-pdf", 180;
    }

    # Here, we were doing a version logic. This is no longer needed, because
    # we now use a different approach to getting the resulting file name:
    # We will list the directory where the printed file is put and we will
    # take the file name that will be returned. To make it work, the directory
    # must be empty, which it normally is, but to make sure let's delete everything.
    script_run("rm /home/test/Desktop/*");
    # Verification commands need serial console to be writable and readable for
    # normal users, let's make it writable then.
    script_run("chmod 666 /dev/${serialdev}");
    # Leave the root terminal and switch back to desktop for the rest of the test.
    desktop_vt();

    my $desktop = get_var("DESKTOP");
    # Set up some variables to make the test compatible with different desktops.
    # Defaults are for the Gnome desktop.
    my $editor = "gedit";
    my $viewer = "evince";
    my $maximize = "super-up";
    my $term = "gnome-terminal";
    if ($desktop eq "kde") {
        $editor = "kwrite";
        $viewer = "okular";
        $maximize = "super-pgup";
        $term = "konsole";
    }

    # Let's open the terminal. We will use it to start the applications
    # as well as to check for the name of the printed file.
    menu_launch_type($term);
    wait_still_screen(5);

    # Open the text editor and maximize it.
    wait_screen_change { type_very_safely "$editor /home/test/testfile.txt &\n"; };
    wait_still_screen(stilltime => 2, similarity_level => 45);
    wait_screen_change { send_key($maximize); };
    wait_still_screen(stilltime => 2, similarity_level => 45);

    # Print the file using one of the available methods
    send_key "ctrl-p";
    wait_still_screen(stilltime => 3, similarity_level => 45);
    # We will select the printing method
    # In case of KDE, we will need to select the printer first.
    if ($desktop eq "kde") {
        assert_and_click "printing_kde_select_printer";
    }
    if ($usecups) {
        assert_and_click "printing_use_cups_printer";
    }
    else {
        assert_and_click "printing_use_saveas_pdf";
        # For KDE, we need to set the output location.
        if ($desktop eq "kde") {
            assert_and_click "printing_kde_location_line";
            send_key("ctrl-a");
            type_safely("/home/test/Documents/output.pdf");
        }
    }
    assert_and_click "printing_print";
    # Exit the application
    send_key "alt-f4";

    # Get the name of the printed file. The path location depends
    # on the selected method. We do this on a VT because there's
    # no argument to script_output to make it type slowly, and
    # it often fails typing fast in a desktop terminal
    $self->root_console(tty => 3);
    my $directory = $usecups ? "/home/test/Desktop" : "/home/test/Documents";
    my $filename = script_output("ls $directory");
    my $filepath = "$directory/$filename";

    # Echo that filename to the terminal for troubleshooting purposes
    diag("The file of the printed out file is located in $filepath");

    # back to the desktop
    desktop_vt();
    wait_still_screen(stilltime => 3, similarity_level => 45);
    # The CLI might be blocked by some application output. Pressing the
    # Enter key will dismiss them and return the CLI to the ready status.
    send_key("ret");
    # Open the pdf file in a Document reader and check that it is correctly printed.
    type_safely("$viewer $filepath &\n");
    wait_still_screen(stilltime => 3, similarity_level => 45);
    # Resize the window, so that the size of the document fits the bigger space
    # and gets more readable.
    send_key $maximize;
    wait_still_screen(stilltime => 2, similarity_level => 45);
    # in KDE, make sure we're at the start of the document
    send_key "ctrl-home" if ($desktop eq "kde");
    # Check the printed pdf.
    assert_screen "printing_check_sentence";
}


sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
