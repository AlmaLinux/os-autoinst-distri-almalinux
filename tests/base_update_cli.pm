use base "installedtest";
use strict;
use testapi;
use packagetest;

sub run {
    my $self = shift;
    # switch to TTY3 for both, graphical and console tests
    $self->root_console(tty => 3);
    # grab the test repo definitions
    assert_script_run "curl -o /etc/yum.repos.d/openqa-testrepo-1.repo https://build.almalinux.org/pulp/content/copr/eabdullin1-openqa-almalinux-9-x86_64-dr/config.repo";
    # enable test repos and install test packages
    prepare_test_packages;
    # check rpm agrees they installed good
    verify_installed_packages;
    # update the fake tini-static (should come from the real repo)
    # this can take a long time if we get unlucky with the metadata refresh
    assert_script_run 'dnf -y update tini-static', 600;
    # check we got the updated version
    verify_updated_packages;
    # now remove tini-static, and see if we can do a straight
    # install from the default repos
    assert_script_run 'dnf -y remove tini-static';
    assert_script_run 'dnf -y install tini-static', 120;
    assert_script_run 'rpm -V tini-static';
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
