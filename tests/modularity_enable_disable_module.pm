use base "installedtest";
use strict;
use modularity;
use testapi;
use utils;

sub run {
    my $self = shift;
    my $hook_run = 0;
    # switch to tty and login as root
    $self->root_console(tty => 3);

    # TODO: Remove "-iso" from boot, minimal and dvd flavors.
    # Enable networking on AlmaLinux 8 minimal and dvd ISOs
    $self->enable_network if ((get_var('FLAVOR') =~ /(minimal|dvd)(-iso)?/) && (get_var('VERSION') =~ /8.([3-9]|[1-9][0-9])/));

    # Enable the module.
    # my $name = "mysql";
    # my $stream = "8.0";
    my $name = "nodejs";
    my $stream = "18";
    assert_script_run("dnf module enable -y $name:$stream");

    # Check that it is listed in the enabled list.
    my $enabled = script_output('dnf module list --enabled');
    my @enabled_modules = parse_module_list($enabled);
    unless (is_listed($name, $stream, \@enabled_modules)) {
        die "The enabled module is not listed in the list of enabled modules but it should be.";
    }

    # Check that it is not listed in the disabled list.
    my $disabled = script_output('dnf module list --disabled');
    my @disabled_modules = parse_module_list($disabled);
    if (is_listed($name, $stream, \@disabled_modules)) {
        die "The enabled module is listed in the list of disabled modules but it should not be.";
    }

    # Disable some other module.
    # my $name_alt = "nginx";
    # my $stream_alt = "mainline";
    my $name_alt = "ruby";
    my $stream_alt = "3.1";
    assert_script_run("dnf module disable -y $name_alt:$stream_alt");

    # Check that it is listed in the disabled list.
    $disabled = script_output('dnf module list --disabled');
    @disabled_modules = parse_module_list($disabled);
    unless (is_listed($name_alt, $stream_alt, \@disabled_modules)) {
        die "The disabled module is not listed in the list of disabled modules but it should be.";
    }

    # Check that it is not listed in the enabled list.
    $enabled = script_output('dnf module list --enabled');
    @enabled_modules = parse_module_list($enabled);
    if (is_listed($name_alt, $stream_alt, \@enabled_modules)) {
        die "The disabled module is listed in the list of enabled modules but it should not be.";
    }

    # Reset the first module to its original state and do the list checks.
    assert_script_run("dnf module reset -y $name");

    # Check that the module has disappeared from both the lists.
    $disabled = script_output('dnf module list --disabled');
    @disabled_modules = parse_module_list($disabled);
    if (is_listed($name, $stream, \@disabled_modules)) {
        die "The disabled module is listed in the list of disabled modules but it should not be.";
    }

    $enabled = script_output('dnf module list --enabled');
    @enabled_modules = parse_module_list($enabled);
    if (is_listed($name, $stream, \@enabled_modules)) {
        die "The disabled module is listed in the list of enabled modules but it should not be.";
    }

    # Reset the second module but do not perform any list checks.
    assert_script_run("dnf module reset -y $name_alt");

}

1;

# vim: set sw=4 et:
