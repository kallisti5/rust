#!/bin/bash
# Copyright 2016 The Rust Project Developers. See the COPYRIGHT
# file at the top-level directory of this distribution and at
# http://rust-lang.org/COPYRIGHT.
#
# Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
# http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
# <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
# option. This file may not be copied, modified, or distributed
# except according to those terms.

set -ex

ARCH=$1

hide_output() {
  set +x
  on_err="
echo ERROR: An error was encountered with the build.
cat /tmp/build.log
exit 1
"
  trap "$on_err" ERR
  bash -c "while true; do sleep 30; echo \$(date) - building ...; done" &
  PING_LOOP_PID=$!
  $@ &> /tmp/build.log
  trap - ERR
  kill $PING_LOOP_PID
  set -x
}

dst=/usr/local/$ARCH-unknown-haiku

# First up, build a cross-compiler
git clone https://git.haiku-os.org/haiku
git clone https://git.haiku-os.org/buildtools
cd buildtools/jam
hide_output make -j2
hide_output ./jam0 install
cd ../..
haiku/build/scripts/build_cross_tools_gcc4 $ARCH `realpath haiku` `realpath buildtools` /usr/local/$ARCH-unknown-haiku
