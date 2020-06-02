#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
root_dir=$(env --chdir="$(dirname $0)/.." pwd);

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
if [ -d "${root_dir}/imagemagick/${src_dir_fixed}" ]; then
  env --chdir="${root_dir}/imagemagick/" rm -rf "${src_dir_fixed}";
fi

if [ -f "${root_dir}/imagemagick/imagemagick_${version_fixed}.orig.tar.xz" ]; then
  env --chdir="${root_dir}/imagemagick/" rm "imagemagick_${version_fixed}.orig.tar.xz"
fi
env --chdir="${root_dir}/imagemagick/" mv "${src_dir}" "${src_dir_fixed}";

## debian package のビルド
env --chdir="${root_dir}/imagemagick/" cp -r debian "${src_dir_fixed}";
env --chdir="${root_dir}/imagemagick/${src_dir_fixed}" dh_make --single --createorig --yes || true;
env --chdir="${root_dir}/imagemagick/${src_dir_fixed}" dpkg-buildpackage -us -uc -j"$(nproc)";
