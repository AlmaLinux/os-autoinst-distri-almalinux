use base "installedtest";
use strict;
use testapi;
use utils;

sub run {
    # create a mount point for the ISO
    assert_script_run "mkdir -p /mnt/iso";
    # mount the ISO there
    assert_script_run "mount /dev/cdrom /mnt/iso";
    # List files
    script_run "ls -al /mnt/iso; ls -alR /mnt/iso/EFI; ls -alR /mnt/iso/images; ls -alR /mnt/iso/isolinux; cat /mnt/iso/media.repo; cat /mnt/iso/.treeinfo;";    
    # download the check script
    assert_script_run "curl -o /usr/local/bin/potential_conflict.py https://pagure.io/fedora-qa/qa-misc/raw/master/f/potential_conflict.py";
    # run the check
    assert_script_run "/usr/libexec/platform-python /usr/local/bin/potential_conflict.py --repofrompath=media,/mnt/iso -r media";
}

sub test_flags {
    return {fatal => 1};
}

1;

# vim: set sw=4 et:
