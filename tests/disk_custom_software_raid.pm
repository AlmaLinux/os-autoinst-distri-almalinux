use base "anacondatest";
use strict;
use testapi;
use anaconda;

sub run {
    my $self = shift;
    # Go to INSTALLATION DESTINATION and ensure two disks are selected.
    # Because PARTITIONING starts with 'custom_', this will select custom.
    select_disks(disks => 2);
    assert_and_click "anaconda_spoke_done";

    # Manual partitioning spoke should be displayed
    assert_and_click "anaconda_part_automatic";
    custom_change_type("raid");
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
