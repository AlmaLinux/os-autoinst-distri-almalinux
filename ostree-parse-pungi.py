#!/usr/bin/python

import re
import sys

# the "current" base platform version, i.e. the one that the GNOME
# app builds currently tagged "stable" need
BASEVER = "37"
# a regex to find where we replace that
BASEPATT = re.compile(r"(runtime/org.almalinux.Platform/.*?/f)(\d+)")

flavor = sys.argv[1]
arch = sys.argv[2]

started = 0
finished = 0
ostree = ""
with open("fedora.conf", "r") as conffh:
    for line in conffh.readlines():
        if line == "ostree_installer = [\n":
            started = 1
        if started and not finished:
            ostree += line
        if started and line == "]\n":
            finished = 1
# don't do this at home, kids!
exec(ostree)

for (gotflav, dic) in ostree_installer:
    if flavor in gotflav.lower():
        args = dic[arch]
        break

cmd = "--rootfs-size=" + args["rootfs_size"]
for addtemp in args["add_template"]:
    cmd += f" --add-template=/fedora-lorax-templates/{addtemp}"
for addtempvar in args["add_template_var"]:
    # this changes e.g. "runtime/org.almalinux.Platform/x86_64/f35"
    # to "runtime/org.almalinux.Platform/x86_64/f37" , if BASEVER
    # is "37"
    addtempvar = BASEPATT.sub(r"\g<1>" + BASEVER, addtempvar)
    cmd += f" --add-template-var=\"{addtempvar}\""

# this is where the previous step of the openQA test created the
# ostree repo
cmd = cmd.replace("https://kojipkgs.almalinux.org/compose/ostree/repo/", "file:///var/tmp/ostree/repo")

print(cmd)
