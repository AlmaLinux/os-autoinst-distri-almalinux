use base "anacondatest";
use strict;
use testapi;
use anaconda;
use File::Basename;

sub run {
    my $self = shift;
    my $repourl;
    my $addrepourl;
    if (get_var("MIRRORLIST_GRAPHICAL")) {
        $repourl = get_mirrorlist_url();
    }
    else {
        # we kinda intentionally don't check ADD_REPOSITORY_GRAPHICAL
        # here, as we cover that case with a postinstall check
        $repourl = get_var("REPOSITORY_VARIATION", get_var("REPOSITORY_GRAPHICAL"));
        $repourl = get_full_repo($repourl) if ($repourl);
        $addrepourl = get_var("ADD_REPOSITORY_VARIATION");
        $addrepourl = get_full_repo($addrepourl) if ($addrepourl);
    }

    # check that the repo was used
    $self->root_console;
    if ($addrepourl) {
        if ($addrepourl =~ m,^nfs://,,) {
            # this line tells us it set up a repo for our URL.
            # "repo addrepo" is older format from before Fedora 37,
            # "Add the 'addrepo" is newer format from F37+
            assert_script_run 'grep "\(repo \|Add the \'\)addrepo.*' . ${addrepourl} . '" /tmp/packaging.log';
            # ...this line tells us it added the repo called 'addrepo'
            assert_script_run 'grep "Added the \'addrepo\'" /tmp/anaconda.log';
            # ...and this tells us it worked (I hope).
            assert_script_run 'grep "Load metadata for the \'addrepo\'" /tmp/anaconda.log';
            assert_script_run 'grep "Loaded metadata from.*file:///run/install/addrepo.nfs" /tmp/anaconda.log';
        }
    }
    if ($repourl =~ /^hd:/) {
        assert_script_run "mount |grep 'almalinux_image.iso'";
    }
    elsif ($repourl =~ s/^nfs://) {
        $repourl =~ s/^nfsvers=.://;
        # the above both checks if we're dealing with an NFS URL, and
        # strips the 'nfs:' and 'nfsvers=.:' from it if so
        # remove image.iso name when dealing with nfs iso
        if ($repourl =~ /\.iso/) {
            $repourl = dirname $repourl;
        }
        # check the repo was actually mounted
        assert_script_run "mount |grep nfs |grep '${repourl}'";
    }
    elsif ($repourl) {
        # there are only three hard problems in software development:
        # naming things, cache expiry, off-by-one errors...and quoting
        assert_script_run 'grep "Added the \'anaconda\'" /tmp/anaconda.log';
        assert_script_run 'grep "Load metadata for the \'anaconda\'" /tmp/anaconda.log';
        assert_script_run 'grep "Loaded metadata from.*' . ${repourl} . '" /tmp/anaconda.log';
    }
    if ($repourl) {
        # check we don't have an error indicating our repo wasn't used.
        # we except error with 'cdrom/file' in it because this error:
        # base repo (cdrom/file:///run/install/repo) not valid -- removing it
        # *always* happens when booting a netinst (that's just anaconda
        # trying to use the image itself as a repo and failing because it's
        # not a DVD), and this was causing false failures when running
        # universal tests on netinsts
        assert_script_run '! grep "base repo.*not valid" /tmp/packaging.log | grep -v "cdrom/file"';
    }
    # just for convenience - sometimes it's useful to see this log
    # for a success case
    upload_logs "/tmp/packaging.log", failok => 1;
    send_key "ctrl-alt-f6";

    # Anaconda hub
    assert_screen "anaconda_main_hub", 30;

}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
