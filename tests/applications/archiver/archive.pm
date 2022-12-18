use base "installedtest";
use strict;
use testapi;
use utils;

# This script will test if files in a directory can be archived
# in an archive file.

sub run {
    my $self = shift;

    # We are already in the correct directory, so let's just
    # select all the files.
    send_key("ctrl-a");
    # Right click on the first of them to open the context menu.
    assert_and_click("archiver_file_one", button => 'right');
    # Select to archive it.
    assert_and_click("archiver_context_archive");
    # Type the name for the archive
    type_very_safely("archived_files");
    # Open the selection of formats.
    assert_and_click("archiver_format_selector");
    # Select the tar.xz method
    assert_and_click("archiver_select_tarxz");
    # Confirm
    assert_and_click("archiver_button_create");
    # Assert that a file has been created in that directory (it may take some time)
    assert_screen("archiver_archive_created");
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
