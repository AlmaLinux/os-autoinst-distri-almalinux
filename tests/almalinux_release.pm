use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    # Version as defined in the VERSION variable.
    my $os_codename = get_code_name();
    my $expectver = get_var('VERSION');
    # Rawhide release number.
    my $rawrel = get_var('RAWREL', '');
    # Create the expected content of the release file
    # and compare it with its real counterpart.
    my $expected = "AlmaLinux release $expectver ($os_codename)";
    validate_script_output 'cat /etc/almalinux-release', sub { $_ eq $expected };
}

sub test_flags {
    return {always_rollback => 1};
}

1;

# vim: set sw=4 et:
