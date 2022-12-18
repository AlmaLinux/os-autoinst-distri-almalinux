use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    my $self = shift;
    my $relnum = get_release_number;
    check_desktop;
    menu_launch_type('terminal');
    assert_screen "apps_run_terminal";
    wait_still_screen(stilltime => 5, similarity_level => 42);
    # need to be root
    my $rootpass = get_var("ROOT_PASSWORD", "weakpassword");
    type_string "su\n", 20;
    wait_still_screen(stilltime => 3, similarity_level => 42);
    # can't use type_safely for now as current implementation relies
    # on screen change checks, and there is no screen change here
    type_string "$rootpass\n", 1;
    wait_still_screen(stilltime => 3, similarity_level => 42);
    # if we can run something successfully, we're at a console;
    # we're reinventing assert_script_run instead of using it so
    # we can type safely
    type_very_safely "ls && echo 'ls OK' > /dev/${serialdev}\n";
    die "terminal command failed" unless defined wait_serial "ls OK";
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
