use base "installedtest";
use strict;
use modularity;
use testapi;
use utils;

sub run {
    my $self = shift;
    # switch to tty and login as root
    $self->root_console(tty => 3);
    
    # The test case will check that dnf has modular functions and that
    # it is possible to invoke modular commands to work with modularity.

    # Check that modular repositories are installed and enabled.
    # If the repository does not exist, the output of the command is empty.

    # Check that modularity works and dnf can list the modules.
    my $modules = script_output('dnf module list', timeout => 270);
    my @modules = parse_module_list($modules);
    die "The module list seems to be empty when it should not be." if (scalar @modules == 0);

    # Check that modularity works and dnf can list the modules
    # with the -all option.
    $modules = script_output('dnf module list --all', timeout => 270);
    @modules = parse_module_list($modules);
    die "The module list seems to be empty when it should not be." if (scalar @modules == 0);

    # Check that dnf lists the enabled modules.
    $modules = script_output('dnf module list --enabled', timeout => 270);
    @modules = parse_module_list($modules);
    if (get_version_major() < 9 && get_var("FLAVOR") ne "minimal-iso") {
       die "There should be enabled modules, the list should not be empty." if (scalar @modules == 0);
    } else {
       die "There seem to be enabled modules when the list should be empty." unless (scalar @modules == 0);
    }
 
    # Check that dnf lists the disabled modules.
    $modules = script_output('dnf module list --disabled', timeout => 270);
    @modules = parse_module_list($modules);
    die "There seem to be disabled modules when the list should be empty." unless (scalar @modules == 0);

    # Check that dnf lists the installed modules.
    $modules = script_output('dnf module list --installed', timeout => 270);
    @modules = parse_module_list($modules);
    die "There seem to be installed modules when the list should be empty." unless (scalar @modules == 0);
}


1;

# vim: set sw=4 et:
