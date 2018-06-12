#!/bin/bash

BASE_NAME="ubuntu1804"
BASE_PREFIX="zz-"
REMOTE_USER="$USER"

opt_ref="master"
opt_ppa=""

usage() {
    cat >&2 <<__EOF__
usage: virt-run-build.sh [--ref <ref>] [--linux <linux>]

where:
  <ref> is the git branch or gerrit ref (default: ${opt_ref})
  <linux> is the linux ppa version (default: current rc)

examples:

   virt-run-build.sh  # master, most recent rc
   virt-run-build.sh --ref openafs-stable-1_8_x --linux daily/current
   virt-run-build.sh --ref refs/heads/34/1234/1 --linux v4.17-rc4

__EOF__
}

while [ "x$1" != "x" ]; do
    case "$1" in
    --ref)  opt_ref="$2"; shift 2;;
    --linux) opt_ppa="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *)  usage; exit 1;;
    esac
done

/usr/local/bin/virt-run \
    --base "$BASE_NAME" \
    --base-prefix "$BASE_PREFIX" \
    --clone-prefix "tmp-" \
    --user "$REMOTE_USER" \
    --wait "30" \
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
    "./configure" \
    "make" \
    "@onfail cat config.log"
