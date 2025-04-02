#!/usr/bin/env bash

set -Eeuo pipefail

TMUX_VERSION=3.5a           # https://github.com/tmux/tmux/releases/
VIM_VERSION=9.1.1236        # https://github.com/vim/vim/tags
VIM_URL=https://github.com/vim/vim/archive/refs/tags/v$VIM_VERSION.tar.gz
TMUX_URL=https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz
LIBEVENT_VERSION=2.1.12     # LIBEVENT_VERSION=2.0.21 is the same as in EL7
LIBEVENT_URL=https://github.com/libevent/libevent/archive/refs/tags/release-$LIBEVENT_VERSION-stable.tar.gz
DIRENV_VERSION=2.35.0       # https://github.com/direnv/direnv/releases/
DIRENV_URL=https://github.com/direnv/direnv/releases/download/v$DIRENV_VERSION/direnv.linux-amd64

LOCAL_CHECKOUTS="${MODERN_TOOLS_LOCAL_CHECKOUTS:-$HOME/src}"

PREFIX="${MODERN_TOOLS_PREFIX:-$HOME/.local}"
export PREFIX
PKG_CONFIG_PATH="$PREFIX"/lib/pkgconfig
export PKG_CONFIG_PATH
MAKEFLAGS="-j"
export MAKEFLAGS

ALL_GIT=()

mkdir -p "$PREFIX"/bin "$LOCAL_CHECKOUTS"

function _install_from_archive {
  local PACKAGE=$1
  local _url_var=${PACKAGE^^}_URL
  local URL="${!_url_var}"

  pushd "$LOCAL_CHECKOUTS" || exit 1
  mkdir -p "$PACKAGE"
  curl -L -o"$PACKAGE.pkg" "$URL"
  tar -x -z --strip-components=1 -C "$PACKAGE" -f "$PACKAGE.pkg"
  pushd "$PACKAGE" || exit 1
  install_"$1"
  popd
  rm "$PACKAGE.pkg"
  popd
}

function _install_from_git {
  local PACKAGE=$1
  local _git_var=${1^^}_GIT
  local GIT=${!_git_var}

  pushd "$LOCAL_CHECKOUTS" || exit 1
  if ! [ -d "$PACKAGE" ]; then
    git clone "$GIT" "$1"
  fi

  pushd "$PACKAGE" || exit 1
  local _git_ver_var=${1^^}_VERSION
  local VERSION=${!_git_ver_var}
  git fetch origin "$VERSION"
  git checkout "$VERSION"
  install_"$1"
  popd
  popd
}

function _install_raw {
  install_"$1"
}

function install_libevent {
  ./autogen.sh || true
  ./configure --prefix="$PREFIX"
  make
  make install
}
ALL_ARCHIVE+=(libevent)

function install_tmux {
  _install_from_archive libevent

  ./configure --prefix="$PREFIX"
  make
  make install
}
ALL_ARCHIVE+=(tmux)

function install_direnv {
  curl -L -o"$PREFIX"/bin/direnv "$DIRENV_URL"
  chmod a+x "$PREFIX"/bin/direnv

  curl -L -o"$XDG_DATA_HOME"/man/man1/direnv-fetchurl.1 https://raw.githubusercontent.com/direnv/direnv/refs/tags/v$DIRENV_VERSION/man/direnv-fetchurl.1
  curl -L -o"$XDG_DATA_HOME"/man/man1/direnv-stdlib.1 https://raw.githubusercontent.com/direnv/direnv/refs/tags/v$DIRENV_VERSION/man/direnv-stdlib.1
  curl -L -o"$XDG_DATA_HOME"/man/man1/direnv.1 https://raw.githubusercontent.com/direnv/direnv/refs/tags/v$DIRENV_VERSION/man/direnv.1
  curl -L -o"$XDG_DATA_HOME"/man/man1/direnv.toml.1 https://raw.githubusercontent.com/direnv/direnv/refs/tags/v$DIRENV_VERSION/man/direnv.toml.1
}
ALL_RAW+=(direnv)

function install_vim {
  ./configure \
    --prefix="$PREFIX" \
    --with-features=huge \
    --enable-multibyte \
    --enable-cscope \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes \
    --enable-python3interp=yes
  make
  make install
}
ALL_ARCHIVE+=(vim)


case "$1" in
  all )
    for f in "${ALL_ARCHIVE[@]}"; do
      _install_from_archive "$f";
    done
    for f in "${ALL_GIT[@]}"; do
      _install_from_git "$f";
    done
    for f in "${ALL_RAW[@]}"; do
      _install_raw "$f";
    done
    ;;
  * )
    if   [[ "${ALL_ARCHIVE[*]:-}" =~ $1 ]]; then
      _install_from_archive "$1"
    elif [[ "${ALL_GIT[*]:-}" =~ $1 ]]; then
      _install_from_git "$1"
    elif [[ "${ALL_RAW[*]:-}" =~ $1 ]]; then
      _install_raw "$1"
    else
      echo "Cannot install $1"
    fi
    ;;
esac

