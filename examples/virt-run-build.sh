#!/bin/sh

virt-run \
  --base ubun18 \
  --base-prefix "zz-" \
  --clone-prefix "tmp-" \
  --user mmeffie \
  "uname -a" \
  "gcc --version" \
  "kernel-ppa get" \
  "kernel-ppa install" \
  "@reboot" \
  "gcc --version" \
  "@say git clone https://gerrit.openafs.org/openafs.git" \
  "@cd openafs" \
  "@say ./regen.sh" \
  "@say ./configure --enable-debug --enable-debug-kernel --disable-optimize
        --disable-optimize-kernel --without-dot --enable-transarc-paths
        --with-linux-kernel-packaging --enable-checking" \
  "@say make -j 1" \
  "@say all done"

