use base "installedtest";
use strict;
use testapi;
use utils;
use packagetest;
use cockpit;

sub run {
    my $self = shift;

    # Start Cockpit
    start_cockpit(login => 1, admin => 1);

    # Navigate to the Update screen
    select_cockpit_update();

    # FIXME Workaround for RHBZ #1765685, remove if that is ever fixed
    sleep 30;

    # Switch on automatic updates.
    # Cockpit's Updates page initialises its 'privileged' state to false and
    # only ever refreshes it from the superuser 'changed' event it subscribes
    # to in componentDidMount. The React tree is rendered after an
    # 'await cockpit.init()', so when administrative access is already granted
    # before the page mounts (cockpit restores it from localStorage at login)
    # that event can fire before the listener exists. 'privileged' then stays
    # false and the 'Enable' button is permanently greyed out. Reloading the
    # page re-runs that race, so retry a few times before giving up.
    my $auto_enabled = 0;
    foreach my $attempt (1 .. 3) {
        if (check_screen 'cockpit_updates_auto', 60) {
            $auto_enabled = 1;
            last;
        }
        record_soft_failure 'Automatic updates "Enable" button is disabled - cockpit superuser race, reloading the Updates page';
        send_key 'ctrl-r';
        assert_screen 'cockpit_updates_check', 300;
        wait_still_screen 5;
    }
    die 'Automatic updates "Enable" button never became active' unless $auto_enabled;
    click_lastmatch;
    assert_and_click 'cockpit_updates_dnf_install', '', 120;
    # from 234 onwards, we get a config screen here: "no updates",
    # "security updates only", "all updates"
    assert_and_click 'cockpit_updates_auto_all';
    assert_and_click 'cockpit_save_changes';

    # Check the default automatic settings Everyday at 6 o'clock.
    assert_screen 'autoupdate_planned_day';
    assert_screen 'autoupdate_planned_time';

    # Quit Cockpit
    quit_firefox;

    # Check that the dnf-automatic service has started
    assert_script_run "systemctl is-active dnf-automatic-install.timer";

    # Check that it is scheduled correctly
    validate_script_output "systemctl show dnf-automatic-install.timer | grep TimersCalendar", sub { $_ =~ "06:00:00" };
}

sub test_flags {
    return {always_rolllback => 1};
}

1;

# vim: set sw=4 et:
