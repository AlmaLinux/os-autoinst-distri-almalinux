use base "anacondatest";
use strict;
use testapi;

sub run {
    my $self = shift;
    # Anaconda hub
    assert_screen "anaconda_main_hub", 300;

    # TODO: Remove "-iso" from boot, minimal and dvd flavors.
    # Select package set. Minimal is the default, if 'default' is specified, skip selection,
    # but verify correct default in some cases
    my $packageset = get_var('PACKAGE_SET', 'default');
    if ($packageset eq 'default') {
        # we can't or don't want to check the selected package set in these cases
        return if (get_var('CANNED') || get_var('LIVE') || get_var('MEMCHECK'));
        $self->root_console;
        # my $env = 'custom-environment';
        my $env = 'graphical-server-environment';
        if (get_var('FLAVOR') =~ /minimal[-iso]?/)  {
            $env = 'minimal-environment';
        }
        # For the $selection_pattern, See:
        # AlmaLinux OS 9 pyanaconda/modules/payloads/payload/dnf/utils.py
        # AlmaLinux OS 10 - pyanaconda/ui/lib/software.py
        (my $major_version = get_var('VERSION')) =~ s/\..*//;
        my $selection_pattern = $major_version >= 10 ? 'Selecting the.*environment' : 'selected environment:';
        assert_script_run("grep -E '$selection_pattern' /tmp/anaconda.log /tmp/packaging.log | tail -1 | grep $env");
        send_key "ctrl-alt-f6";
        assert_screen "anaconda_main_hub", 30;
        return;
    }

    assert_and_click "anaconda_main_hub_select_packages";

    # Focus on "base environment" list
    send_key "tab";
    wait_still_screen 1;
    send_key "tab";
    wait_still_screen 1;

    # select desired environment
    # go through the list 20 times at max (to prevent infinite loop when it's missing)
    for (my $i = 0; !check_screen("anaconda_" . $packageset . "_highlighted", 1) && $i < 20; $i++) {
        send_key "down";
        wait_still_screen 1;
        send_key "spc";
    }

    send_key "spc";

    # check that desired environment is selected
    assert_screen "anaconda_" . $packageset . "_selected";

    assert_and_click "anaconda_spoke_done";

    # Anaconda hub
    assert_screen "anaconda_main_hub", 50;

}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
