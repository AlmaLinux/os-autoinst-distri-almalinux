use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    # try to login, check whether target release is installed
    $self->root_console(tty => 3);
    my $version = lc(get_var('VERSION'));
    my $rawrel = get_var('RAWREL');
    # if VERSION is the Rawhide release number (happens for Rawhide
    # update tests), check for "rawhide" not the number
    my $tocheck = $version eq $rawrel ? 'rawhide' : $version;
    check_release($tocheck);
}


sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
