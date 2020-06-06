#!/bin/bash

set -eu

configure_dir="$(readlink -f $(cd $(dirname $0); pwd))";
imagemagick_dir="$(basename $(ls -1vd ${configure_dir}/imagemagick-* | grep -E '\-([0-9])+\.([0-9])+\.([0-9])+\.([0-9])+$' | tail -n 1))"

DEB_HOST_MULTIARCH="$(dpkg-architecture -qDEB_HOST_MULTIARCH)"
DEB_UPSTREAM_VERSION_MAJOR="$(echo -n ${imagemagick_dir} | sed -r -e 's/imagemagick-//g' -e 's/\.([0-9])+\.([0-9])+\.([0-9])+$//g')"
DOC_PKG_PATH="/usr/share/doc/imagemagick-${DEB_UPSTREAM_VERSION_MAJOR}-common/html"

./configure \
        --enable-reproducible-build \
        --prefix=/usr \
        --libdir=/usr/lib/${DEB_HOST_MULTIARCH} \
        --docdir=/usr/share/doc/imagemagick-${DEB_UPSTREAM_VERSION_MAJOR}-common/html \
        --sysconfdir=/etc \
        --with-includearch-dir=/usr/include/${DEB_HOST_MULTIARCH}/ \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --with-modules \
        --with-gs-font-dir=/usr/share/fonts/type1/gsfonts \
        --with-magick-plus-plus \
        --with-djvu \
        --with-openjp2 \
        --with-wmf \
        --without-gvc \
        --enable-shared \
        --without-dps \
        --without-fpx \
        --with-perl \
        --with-perl-options='INSTALLDIRS=vendor' \
        --x-includes=/usr/include/X11 \
        --x-libraries=/usr/lib/X11 \
        --without-rsvg
