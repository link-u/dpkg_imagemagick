#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
root_dir=$(env --chdir "$(dirname $0)/.." pwd)

## HEAD のコミットID と HEAD の時のタグを取得
git_commit="$(env --chdir=${root_dir} git rev-parse HEAD)"
git_ref="$(env --chdir=${root_dir} git tag --points-at ${git_commit})"

## ディストリビューションのコードネームの取得
code_name="$(lsb_release -cs)"

## changelog の作成
cp "${root_dir}/scripts/changelog_template" "${root_dir}/imagemagick/debian/changelog"
env --chdir "${root_dir}/imagemagick/debian" sed -i -r "s/%DATE%/$(LC_ALL=C TZ=JST-9 date '+%a, %d %b %Y %H:%M:%S %z')/g" changelog

## changelog のバージョニング
if [ "${git_ref:0:1}" = "v" ]; then
  ## タグからバージョン名を生成
  version="$(echo ${git_ref:1} | sed -e 's/-/\./').$(TZ=JST-9 date +%Y%m%d)+${code_name}"
else
  ## tar ball とコミット ID からバージョン名を生成
  version="$(basename $(ls -1vd ${root_dir}/imagemagick/*.tar.gz | tail -n 1) .tar.gz | sed -e 's/-/\./')-$(TZ=JST-9 date +%Y%m%d.%H%M%S).${git_commit:0:7}+${code_name}"
fi
env --chdir "${root_dir}/imagemagick/debian" sed -i -r "s/UpstreamVersion-DebianRevision/${version}/g" changelog
