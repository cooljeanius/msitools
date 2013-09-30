#!/bin/sh

test -n "$srcdir" || srcdir=$(dirname "$0")
test -n "$srcdir" || srcdir=.
(
  cd "$srcdir" &&
  mkdir -p m4 &&
  AUTOPOINT='intltoolize --automake --copy' autoreconf -fiv -Wall
) || exit
test -n "$NOCONFIGURE" || echo "Running ./configure $@ (because NOCONFIGURE is _not_ set)" && "$srcdir/configure" "$@"

test -e config.h.in~ && rm -f config.h.in~
test -e autom4te.cache && rm -rf autom4te.cache
