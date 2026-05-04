package cockpit;

use strict;

use base 'Exporter';
use Exporter;
use lockapi;
use testapi;
use utils;

our @EXPORT = qw(start_cockpit select_cockpit_update check_updates);


sub start_cockpit {
    # Starting from a console, get to a browser with Cockpit (running
    # on localhost) shown. If login is truth-y, also log in. If login
    # and admin are both truthy, also gain admin privileges. Assumes
    # X and Firefox are installed.
    my %args = @_;
    $args{login} //= 0;
    $args{admin} //= 1;
    my $login = shift || 0;
    disable_firefox_studies;
    my @major_version = split(/\./, get_var('VERSION'));
    if ($major_version[0] >= 10) {
        # AlmaLinux 10 dropped Xorg server (no startx). Use gnome-kiosk:
        # a minimal Wayland compositor that runs a single app fullscreen
        # and renders to TTY via KMS/DRM, visible to openQA's VGA capture.
        # gnome-kiosk needs a real session env: $XDG_RUNTIME_DIR, dbus
        # session, XDG_SESSION_TYPE=wayland.
        assert_script_run "mkdir -p /run/user/0 && chmod 700 /run/user/0 && chown root:root /run/user/0";
        type_string "XDG_RUNTIME_DIR=/run/user/0 XDG_SESSION_TYPE=wayland XDG_SESSION_CLASS=user dbus-run-session -- gnome-kiosk -- /usr/bin/firefox --kiosk -width 1024 -height 768 http://localhost:9090\n";
    } else {
        # https://bugzilla.redhat.com/show_bug.cgi?id=1439429
        assert_script_run "sed -i -e 's,enable_xauth=1,enable_xauth=0,g' /usr/bin/startx";
        # run firefox directly in X as root. never do this, kids!
        type_string "startx /usr/bin/firefox -width 1024 -height 768 http://localhost:9090\n";
    }
    assert_screen "cockpit_login", 60;
    wait_still_screen(stilltime => 5, similarity_level => 45);
    if ($args{login}) {
        type_safely "test";
        wait_screen_change { send_key "tab"; };
        type_safely get_var("USER_PASSWORD", "weakpassword");
        send_key "ret";
        if ($args{admin}) {
            # wait for cockpit Overview to settle: under gnome-kiosk,
            # Firefox can transition to fullscreen mid-click, moving the
            # button out from under the cursor before the click registers
            wait_still_screen(stilltime => 5, similarity_level => 45);
            assert_and_click "cockpit_admin_enable";
            assert_screen "cockpit_admin_password";
            type_safely get_var("USER_PASSWORD", "weakpassword");
            send_key "ret";
        }
        assert_screen "cockpit_main";
        # wait for any animation or other weirdness
        # can't use wait_still_screen because of that damn graph
        sleep 3;
    }
}

sub select_cockpit_update {
    # This method navigates to to the updates screen
    # From Firefox 100 on, we get 'adaptive scrollbars', which means
    # the scrollbar is just invisible unless you moved the mouse
    # recently. So we click in the search box and hit 'up' to scroll
    # the sidebar to the bottom if necessary
    assert_screen ["cockpit_software_updates", "cockpit_search"], 120;
    click_lastmatch;
    if (match_has_tag "cockpit_search") {
        click_lastmatch;
        send_key "up";
        wait_still_screen 2;
        send_key "up";
        wait_still_screen 2;
        # assert_and_click "cockpit_software_updates";
        if (check_screen "cockpit_software_updates", 1) {
            click_lastmatch;
        } else {
            send_key "pgdn";
            wait_still_screen 2;
            if (check_screen "cockpit_software_updates", 1) {
                click_lastmatch;
            }
        }
    }
    # wait for the updates to download
    assert_screen 'cockpit_updates_check', 300;
}

sub check_updates {
    my $logfile = shift;
    sleep 2;
    my $checkresult = script_run "dnf check-update > $logfile";
    upload_logs "$logfile", failok => 1;
    return ($checkresult);
}
