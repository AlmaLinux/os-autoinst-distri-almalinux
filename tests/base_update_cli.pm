use base "installedtest";
use strict;
use testapi;
use packagetest;

sub run {
    my $self = shift;
    # switch to TTY3 for both, graphical and console tests
    $self->root_console(tty => 3);
    my $timeout = 600;
    $timeout = 1200 if (get_var('ARCH') eq 's390x');
    # Enable networking on AlmaLinux 8 minimal and dvd ISOs
    $self->enable_network if ((get_var('FLAVOR') =~ /(minimal|dvd)(-iso)?/) && (get_var('VERSION') =~ /8.([3-9]|[1-9][0-9])/));
    # grab the test repo definitions
    assert_script_run "curl -o /etc/yum.repos.d/openqa-testrepo-1.repo https://build.almalinux.org/pulp/content/copr/eabdullin1-openqa-almalinux-9-" . get_var("ARCH") . "-dr/config.repo";
    # enable test repos and install test packages
    prepare_test_packages;
    # check rpm agrees they installed good
    verify_installed_packages;
    # update the fake tini-static (should come from the real repo)
    # this can take a long time if we get unlucky with the metadata refresh
    assert_script_run('dnf -y update tini-static', timeout => $timeout);
    # check we got the updated version
    verify_updated_packages;
    # now remove tini-static, and see if we can do a straight
    # install from the default repos
    assert_script_run 'dnf -y remove tini-static';
    assert_script_run('dnf -y install tini-static', timeout => $timeout);
    assert_script_run 'rpm -V tini-static';
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
