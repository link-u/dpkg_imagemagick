# ImageMagick の deb パッケージ (Link-U 公開リポジトリ)

![Build debian packages](https://github.com/link-u/dpkg_imagemagick/workflows/Build%20debian%20packages/badge.svg)

## 概要

最新の ImageMagick の deb パッケージをビルドする.

github actions によって最新のソースコードに差し替えるだけで自動的にビルドできる.

## ビルド確認バージョン

以下はビルドができることを確認した OS のバージョンである.

* Ubuntu 18.04 (bionic)
* Ubuntu 20.04 (focal)

※ 18.04 以降でのビルドならどれでもおそらくビルドできる.

## deb ファイルの命名規則

* git の HEAD に v から始まるタグが無い場合
  ```
  imagemagick_<ImageMagick のバージョン>-<YYYYMMDD>.<hhmmss>.<Commit ID>+<OS のコードネーム>_amd64.deb
  ```

* git の HEAD に v から始まるタグが有る場合
  ```
  imagemagick_<ImageMagick のバージョン>-<n>.<YYYYMMDD>+<OS のコードネーム>_amd64.deb
  ```
  ※ `<n>` は弊社の修正が入るたびに増える自然数


## How to build

基本的に github actions によって自動ビルドされるが, 手元のローカルマシンでビルドしたい場合のやり方を以下に示す.

## git リポジトリからクローン

```
git clone git@github.com:link-u/dpkg_imagemagick.git
```

## deb パッケージの作成

deb パッケージの作成ではビルドに必要なツール群や依存するパッケージ群をインストールする必要があるため, 

1. Docker コンテナ
2. 仮想マシン

のどちらかを使うことを推奨し, 以下ではそれぞれでの deb パッケージ作成方法を説明する. 

### Docker コンテナで deb パッケージ作成

git リポジトリをルートとして以下のコマンドで Docker コンテナを起動する.

```
## Ubuntu:18.04 の場合 
$ docker run --rm -it \
             -v $(pwd):/opt/dpkg_imagemagick \
             -w /opt/dpkg_imagemagick \
             ubuntu:18.04 bash


## Ubuntu:20.04 の場合 
$ docker run --rm -it \
             -v $(pwd):/opt/dpkg_imagemagick \
             -w /opt/dpkg_imagemagick \
             ubuntu:20.04 bash
```

オプションの細かい説明は省くが, 大雑把に以下のことをしている.

* カレントディレクトリをコンテナ内の `/opt/dpkg_imagemagick` にマウント (`-v` オプション).
* コンテナ起動時の作業ディレクトリを `/opt/dpkg_imagemagick` に移動 (`-w` オプション).

次に deb パッケージの作成に必要な以下のツールをインストールする.

```
$ apt update && \
  apt install -y --no-install-recommends build-essential debhelper devscripts debmake equivs && \
  apt install -y --no-install-recommends lsb-release git bash
```

準備が整ったら deb 作成用のシェルスクリプトを実行する.

```
$ bash scripts/all.sh
```

これらの作業が終わるとコンテナから `exit` して, 以下のパスに deb パッケージが作成されていることを確認する.

```
## git リポジトリをカレントディレクトリとして以下のパス
ls ./imagemagick/imagemagick_7.0.10.16-20200608.125141.4a0c693+bionic_amd64.deb
```



### 仮想マシンで deb パッケージ作成

Ubuntu 18.04, 20.04 の仮想マシンを用意しているという前提で説明をする.
といってもやることは Docker コンテナの時とほとんど同じ.

まずは, git リポジトリを仮想マシンに転送する.

そして, deb パッケージの作成に必要な以下のツールをインストールする.

```
$ sudo apt update && \
  sudo apt install -y --no-install-recommends build-essential debhelper devscripts debmake equivs && \
  sudo apt install -y --no-install-recommends lsb-release git bash
```

準備が整ったら git リポジトリルートで deb 作成用のシェルスクリプトを実行する.

```
$ sudo bash scripts/all.sh
```

これらの作業が終わると以下のパスに deb パッケージが作成されていることを確認する.

```
## git リポジトリをカレントディレクトリとして以下のパス
ls ./imagemagick/imagemagick_7.0.10.16-20200608.125141.4a0c693+bionic_amd64.deb
```
