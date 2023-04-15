use base "anacondatest";
use strict;
use testapi;
use anaconda;

sub run {
    my $self = shift;
    my $timeout = 30;
    $timeout = 1200 if (get_var('ARCH') eq 's390x');
    # Go to INSTALLATION DESTINATION and ensure the disk is selected.
    # Because PARTITIONING starts with 'custom_', this will select custom.
    select_disks();
    assert_and_click "anaconda_spoke_done";

    # Manual partitioning spoke should be displayed.
    # Select the Standard Partitioning scheme
    custom_scheme_select("standard");
    # Do 'automatic' partition creation
    assert_and_click "anaconda_part_automatic";
    # Select ext4 as filesystems for partitions
    custom_change_fs("ext4", "root", $timeout);
    custom_change_fs("ext4", "boot", $timeout);
    # Finish the settings
    assert_and_click "anaconda_spoke_done";
    assert_and_click "anaconda_part_accept_changes";

    # Anaconda hub
    assert_screen "anaconda_main_hub", 300;

}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
