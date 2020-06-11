#!/bin/bash

set -eu

## git リポジトリ上の scripts ディレクトリのパスを取得
scripts_dir=$(readlink -f $(cd $(dirname $0) && pwd))

## webp ソースの tar ball 名を取得
src_webp="$(basename $(ls -1vd ${scripts_dir}/../webp/libwebp-*.tar.gz | tail -n 1) .tar.gz)"

## webp のビルド
#  * 共有ライブラリはつくらない. 静的ライブラリのみ生成
env --chdir="${scripts_dir}/../webp" rm -rf "${src_webp}" || true;
env --chdir="${scripts_dir}/../webp" tar xvf "${src_webp}.tar.gz"
env --chdir="${scripts_dir}/../webp/${src_webp}" ./configure --enable-shared=no --prefix=/opt/webp
env --chdir="${scripts_dir}/../webp/${src_webp}" make clean -j"$(nproc)"
env --chdir="${scripts_dir}/../webp/${src_webp}" make -j"$(nproc)"
env --chdir="${scripts_dir}/../webp/${src_webp}" make install
