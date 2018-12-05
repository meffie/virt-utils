#!/bin/bash

usage() {
    cat <<__EOF__
Build and smoke test OpenAFS on a Linux RC or daily using packages
provided by the Ubuntu Kernel Team.

usage: virt-run-build [--user <user>] [--branch <ref>] [--linux <linux>] [--smoke-test]

where:

  <ref> is the git branch or gerrit ref (default: master)
  <linux> is the linux ppa version (default: current rc)

examples:

   virt-run-build  # master, most recent rc
   virt-run-build --branch openafs-stable-1_8_x --linux daily
   virt-run-build --branch refs/heads/34/1234/1 --linux v4.17-rc4

__EOF__
}

opt_user="$USER"
opt_branch="master"
opt_ppa="rc"
opt_nodelete=""
opt_dotest="@skip "
while [ "x$1" != "x" ]; do
    case "$1" in
    --user) opt_user="$2"; shift 2;;
    --branch|--ref) opt_branch="$2"; shift 2;;
    --linux) opt_ppa="$2"; shift 2;;
    --nodelete) opt_nodelete="--nodelete"; shift;;
    --smoke-test) opt_dotest=""; shift;;
    -h|--help) usage; exit 0;;
    *)  usage; exit 1;;
    esac
done

virt-run \
    --base "ubuntu1804" \
    --base-prefix "zz-" \
    --clone-prefix "tmp-" \
    --user "$opt_user" \
    --wait "30" \
    ${opt_nodelete} \
    "kernel-ppa get ${opt_ppa}" \
    "sudo kernel-ppa install" \
    "@reboot" \
    "uname -a" \
    "@cd openafs" \
    "git fetch origin" \
    "git checkout origin/${opt_branch}" \
    "git --no-pager log -n1 --stat" \
    "./regen.sh" \
    "./configure --enable-transarc-paths" \
    "make dest" \
    "${opt_dotest}sudo afsutil check --fix-hosts"  \
    "${opt_dotest}afsrobot setup" \
    "${opt_dotest}afsrobot run --suite client"
