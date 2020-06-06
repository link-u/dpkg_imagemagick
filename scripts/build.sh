#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
root_dir=$(readlink -f $(cd $(dirname $0) && cd .. && pwd))

## imagemagick のソース tar ball のファイル名の取得
tarball="$(basename $(ls -1vd ${root_dir}/imagemagick/*.tar.gz | tail -n 1))";

## imagemagick のソース tar ball の展開
mkdir -p "${root_dir}/imagemagick/imagemagick"
env --chdir="${root_dir}/imagemagick/imagemagick" tar xvf "${tarball}" --strip-components 1

## 展開した imagemagick のディレクトリ名取得
src_dir=$(basename $(ls -1vd ${root_dir}/imagemagick/*${version} | tail -n 1));

## debian package のビルド
cp -r "${root_dir}/imagemagick/debian" "imagemagick"
env --chdir="${root_dir}/imagemagick/imagemagick" fakeroot debian/rules clean -j"$(nproc)"
env --chdir="${root_dir}/imagemagick/imagemagick" fakeroot debian/rules build -j"$(nproc)"
env --chdir="${root_dir}/imagemagick/imagemagick" fakeroot debian/rules binary -j"$(nproc)"
