#!/bin/bash

set -eu

configure_dir="$(cd $(dirname $0); pwd)";
imagemagick_dir="$(basename $(ls -1vd ${configure_dir}/imagemagick-* | grep -E '\-([0-9])+\.([0-9])+\.([0-9])+\.([0-9])+$' | tail -n 1))"

DEB_HOST_MULTIARCH="$(dpkg-architecture -qDEB_HOST_MULTIARCH)"
DEB_UPSTREAM_VERSION_MAJOR="$(echo -n ${imagemagick_dir} | sed -r -e 's/imagemagick-//g' -e 's/\.([0-9])+\.([0-9])+\.([0-9])+$//g')"
DOC_PKG_PATH="/usr/share/doc/imagemagick-${DEB_UPSTREAM_VERSION_MAJOR}-common/html"

./configure \
  --prefix=/usr/ \
  --libdir=/usr/lib/${DEB_HOST_MULTIARCH} \
  --docdir=/usr/share/doc/imagemagick-${DEB_UPSTREAM_VERSION_MAJOR}-common/html \
  --sysconfdir=/etc \
  --mandir=/usr/share/man \
  --infodir=/usr/share/info \
  --with-modules \
  --with-gs-font-dir=/usr/share/fonts/type1/gsfonts \
  --with-wmf \
  --without-fpx \
  --enable-shared
  