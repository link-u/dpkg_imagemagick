#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
scripts_dir=$(readlink -f $(cd $(dirname $0) && pwd))

## ビルド時に必要なパッケージのインストール
env --chdir="${scripts_dir}/../imagemagick" \
  mk-build-deps --install --remove \
  --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' \
  debian/control

## 依存パッケージのビルド
bash "${scripts_dir}/prepare_build.sh"

## 環境変数の設定
if [ ! -v PKG_CONFIG_PATH ]; then
  PKG_CONFIG_PATH="";
fi
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/opt/webp/lib/pkgconfig"

## deb ファイルのビルド
bash "${scripts_dir}/create_changelog.sh"
bash "${scripts_dir}/build.sh"
