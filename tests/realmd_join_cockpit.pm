use base "installedtest";
use strict;
use testapi;
use lockapi;
use utils;
use tapnet;
use cockpit;

sub run {
    my $self = shift;
    # use FreeIPA server as DNS server
    assert_script_run "printf 'search test.openqa.almalinux.org\nnameserver 172.16.2.100' > /etc/resolv.conf";
    # this gets us the name of the first connection in the list,
    # which should be what we want
    my $connection = script_output "nmcli --fields NAME con show | head -2 | tail -1";
    assert_script_run "nmcli con mod '$connection' ipv4.dns '172.16.2.100'";
    assert_script_run "nmcli con down '$connection'";
    assert_script_run "nmcli con up '$connection'";
    # wait for the server to be ready (do it now just to make sure name
    # resolution is working before we proceed)
    mutex_lock "freeipa_ready";
    mutex_unlock "freeipa_ready";
    # do repo setup
    repo_setup();
    # set sssd debugging level higher (useful for debugging failures)
    # optional as it's not really part of the test
    script_run "dnf -y install sssd-tools", 220;
    script_run "sss_debuglevel 9";
    my $cockpitver = script_output 'rpm -q cockpit --queryformat "%{VERSION}\n"';
    # run firefox and login to cockpit
    # note: we can't use wait_screen_change, wait_still_screen or
    # check_type_string in cockpit because of that fucking constantly
    # scrolling graph
    start_cockpit(login => 1);
    # to activate the right pane
    assert_and_click "cockpit_main";
    send_key "pgdn";
    # wait out scroll...
    wait_still_screen 2;
    # sometimes this click fails because CPU usage goes from one line
    # to two at just the wrong moment and the link moves, so if it
    # didn't work, try again a few times
    my $count = 4;
    while ($count > 0) {
        assert_and_click "cockpit_join_domain_button", timeout => 5;
        last if (check_screen "cockpit_join_domain", 30);
    }
    assert_screen "cockpit_join_domain";
    # we need one tab to reach "Domain address" and then one tab to
    # reach "Domain administrator name" on cockpit 255+...
    my $tabs = "\t";
    # ...but two tabs in both places on earlier versions
    $tabs = "\t\t" if ($cockpitver < 255);
    type_string($tabs, 4);
    type_string("ipa001.test.openqa.almalinux.org", 4);
    type_string($tabs, 4);
    type_string("admin", 4);
    send_key "tab";
    sleep 3;
    type_string("monkeys123", 4);
    sleep 3;
    assert_and_click "cockpit_join_button";
    # join involves package installs, so it may take some time
    assert_screen "cockpit_join_complete", 300;
    # quit browser to return to console
    quit_firefox;
}

sub test_flags {
    return {fatal => 1, milestone => 1};
}

1;

# vim: set sw=4 et:
