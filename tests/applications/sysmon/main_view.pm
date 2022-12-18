use base "installedtest";
use strict;
use testapi;
use utils;

# This script tests that users can switch between the three main regimes.

sub run {
    # wait for the restore to settle down
    wait_still_screen 3;
    # Press Alt-3 to see the file systems
    send_key("alt-3");
    assert_screen("sysmon_fsystems_shown");

    # Press Alt-1 to see the processes
    send_key("alt-1");
    assert_screen("sysmon_processes_shown");

    # Press Alt-2 to see the resources
    send_key("alt-2");
    assert_screen("sysmon_resources_shown");
}

sub test_flags {
    return {always_rollback => 1};
}

1;


