#!/bin/bash

usage() {
    cat >&2 <<__EOF__
Build and smoke test OpenAFS on a Linux rc or daily build using packages
provided by the Ubuntu Kernel Team.

usage: build-openafs-on-linux-rc.sh [--ref <ref>] [--linux <linux>] [--smoke-test]

where:

  <ref> is the git branch or gerrit ref (default: master)
  <linux> is the linux ppa version (default: current rc)

examples:

   ./build.sh  # master, most recent rc
   ./build.sh --ref openafs-stable-1_8_x --linux daily/current
   ./build.sh --ref refs/heads/34/1234/1 --linux v4.17-rc4

__EOF__
}

opt_ref="master"
opt_ppa=""
opt_nodelete=""
opt_smoke_test="@skip "
while [ "x$1" != "x" ]; do
    case "$1" in
    --ref)  opt_ref="$2"; shift 2;;
    --linux) opt_ppa="$2"; shift 2;;
    --nodelete) opt_nodelete="--nodelete"; shift;;
    --smoke-test) opt_smoke_test=""; shift;;
    -h|--help) usage; exit 0;;
    *)  usage; exit 1;;
    esac
done

/usr/local/bin/virt-run \
    --base "ubuntu1804" \
    --base-prefix "zz-" \
    --clone-prefix "tmp-" \
    --user "buildbot" \
    --wait "30" \
    ${opt_nodelete} \
    "kernel-ppa get ${opt_ppa}" \
    "sudo kernel-ppa install" \
    "@reboot" \
    "uname -a" \
    "gcc --version" \
    "mkdir openafs" \
    "@cd openafs" \
    "git init" \
    "git fetch https://gerrit.openafs.org/openafs.git ${opt_ref}" \
    "git reset --hard FETCH_HEAD" \
    "git --no-pager log -n1 --stat" \
    "./regen.sh" \
    "./configure --enable-transarc-paths" \
    "make dest" \
    "${opt_smoke_test}sudo afsutil check --fix-hosts"  \
    "${opt_smoke_test}afsrobot setup" \
    "${opt_smoke_test}afsrobot run --suite client"
