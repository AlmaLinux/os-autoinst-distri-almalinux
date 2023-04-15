package packagetest;

use strict;

use base 'Exporter';
use Exporter;

use testapi;
our @EXPORT = qw/prepare_test_packages verify_installed_packages verify_updated_packages/;

# enable the openqa test package repositories and install the main
# test packages, remove tini-static and install the fake one
sub prepare_test_packages {
    my $timeout = 90;
    $timeout = 1200 if (get_var('ARCH') eq 's390x');
    # remove tini-static if installed (we don't use assert
    # here in case it's not)
    # TODO: we dont have kickstart installled
    #  This module needs more work
    # script_run 'dnf -y remove tini-static', 180;
    # grab the test repo definitions
    assert_script_run "curl -o /etc/yum.repos.d/openqa-testrepo-1.repo https://build.almalinux.org/pulp/content/copr/eabdullin1-openqa-almalinux-9-" . get_var("ARCH") . "-dr/config.repo";
    # install the test packages from repo1
    assert_script_run "dnf repolist"; # --disablerepo=* --enablerepo=openqa-testrepo-1
    assert_script_run 'dnf -y  install tini-static', timeout => $timeout;
    # TODO: BR revisit below
    #if (get_var("DESKTOP") eq 'kde' && get_var("TEST") eq 'desktop_update_graphical') {
        # kick pkcon so our special update will definitely get installed
    #    assert_script_run 'pkcon refresh force';
    #}
}

# check our test packages installed correctly (this is a test that dnf
# actually does what it claims)
sub verify_installed_packages {
    # validate_script_output 'rpm -q tini-static', sub { $_ =~ m/^tini-static-0.19.0-5.el9.x86_64$/ };
    assert_script_run 'rpm -V tini-static';
}

# check updating the test packages and the fake tini-static work
# as expected
sub verify_updated_packages {
    # we don't know what version of tini-static we'll actually
    # get, so just check it's *not* the fake one
    # TODO: Revisit
    # validate_script_output 'rpm -q tini-static', sub { $_ !~ m/^tini-static-1.1-1.el9.noarch$/ };
    assert_script_run 'rpm -V tini-static';
}
