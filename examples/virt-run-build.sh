#!/bin/sh

virt-run \
  --base ubuntu1804 \
  --base-prefix "zz-" \
  --clone-prefix "tmp-" \
  --user mmeffie \
  --wait 30 \
  "uname -a" \
  "gcc --version" \
  "kernel-ppa get" \
  "sudo kernel-ppa install" \
  "@reboot" \
  "gcc --version" \
  "git clone https://gerrit.openafs.org/openafs.git" \
  "@cd openafs" \
  "./regen.sh" \
  "./configure --enable-debug --enable-debug-kernel --disable-optimize --disable-optimize-kernel" \
  "make -j 1" \
  "@say all done"
