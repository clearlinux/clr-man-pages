#!/bin/sh

set -e

autoreconf --force --install --symlink --warnings=all

args="\
--prefix=/usr \
--enable-silent-rules"

./configure $args "$@"
