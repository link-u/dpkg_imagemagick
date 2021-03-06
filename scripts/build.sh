#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
root_dir=$(readlink -f $(cd $(dirname $0) && cd .. && pwd))

## imagemagick のソース tar ball のファイル名とバージョン名の取得
src="$(basename $(ls -1vd ${root_dir}/imagemagick/*.tar.gz | tail -n 1))";
version="$(basename ${src} .tar.gz)";

## imagemagick のソース tar ball の展開
env --chdir="${root_dir}/imagemagick/" tar xvf "$src";

## 展開した imagemagick のディレクトリ名取得
src_dir=$(basename $(ls -1vd ${root_dir}/imagemagick/*${version} | tail -n 1));

## debian パッケージで使われるバージョンニングルールになるように修正する
version_fixed="$(echo ${version} | sed -e 's/-/\./')";

## ↑に伴ってディレクトリ名の修正
src_dir_fixed="imagemagick-${version_fixed}";
rm -rf "${root_dir}/imagemagick/${src_dir_fixed}" || true;
env --chdir="${root_dir}/imagemagick/" mv "${src_dir}" "${src_dir_fixed}";

## debian package のビルド
env --chdir="${root_dir}/imagemagick/" cp -r debian "${src_dir_fixed}";
env --chdir="${root_dir}/imagemagick/${src_dir_fixed}" fakeroot debian/rules clean -j"$(nproc)"
env --chdir="${root_dir}/imagemagick/${src_dir_fixed}" fakeroot debian/rules build -j"$(nproc)"
env --chdir="${root_dir}/imagemagick/${src_dir_fixed}" fakeroot debian/rules binary -j"$(nproc)"
