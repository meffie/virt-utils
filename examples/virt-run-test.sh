#!/bin/sh

# Example virt-run command to spin a guest vm, run some commands,
# then delete the guest vm.
virt-run \
  --base ubuntu1804 \
  --base-prefix "zz-" \
  --clone-prefix "tmp-" \
  "uname -a" \
  "gcc --version" \
  "@sleep 2" \
  "@reboot" \
  "mkdir temp" \
  "@cd temp" \
  "pwd" \
  "@sleep 20"
