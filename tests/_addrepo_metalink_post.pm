use base "installedtest";
use strict;
use testapi;

sub run {
    # check the test package from the side repo was installed
    assert_script_run "rpm -q testpackage";
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
