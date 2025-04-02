#!/usr/bin/env bash

FZF_VERSION=0.61.1          # https://github.com/junegunn/fzf/releases/
LIQUIDPROMPT_VERSION=2.2.1  # https://github.com/liquidprompt/liquidprompt/releases/
DIRENV_VERSION=2.35.0       # https://github.com/direnv/direnv/releases/
CTAGS_VESION=6.1.0          # https://github.com/universal-ctags/ctags/releases/
VIM_VERSION=9.1.1236        # https://github.com/vim/vim/tags
RG_VERSION=14.1.1           # https://github.com/BurntSushi/ripgrep/releases
GDU_VERSION=5.30.1          # https://github.com/dundee/gdu/releases

FZF_URL=https://github.com/junegunn/fzf/releases/download/v$FZF_VERSION/fzf-$FZF_VERSION-linux_amd64.tar.gz
LIQUIDPROMPT_URL=https://github.com/liquidprompt/liquidprompt/releases/download/v$LIQUIDPROMPT_VERSION/liquidprompt
DIRENV_URL=https://github.com/direnv/direnv/releases/download/v$DIRENV_VERSION/direnv.linux-amd64
CTAGS_URL=https://github.com/universal-ctags/ctags/releases/download/v$CTAGS_VESION/universal-ctags-$CTAGS_VESION.tar.gz
VIM_URL=https://github.com/vim/vim/archive/refs/tags/v$VIM_VERSION.tar.gz
RG_URL=https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz
GDU_URL=https://github.com/dundee/gdu/releases/download/v$GDU_VERSION/gdu_linux_amd64_static.tgz

export MAKEFLAGS="-j"

PREFIX=/workspaces/"$HOSTNAME"/"$USER"/.local
export PREFIX

TMPDIR="$(mktemp -d -t init_sh.XXXXXX)"
# shellcheck disable=SC2064
trap "rm -rf '$TMPDIR'" 0               # EXIT
# shellcheck disable=SC2064
trap "rm -rf '$TMPDIR'; exit 1" 2       # INT
# shellcheck disable=SC2064
trap "rm -rf '$TMPDIR'; exit 1" 1 15    # HUP TERM

mkdir -p "$PREFIX"/bin

function install_fzf {
  rm -rf EXTRACT && mkdir -p EXTRACT
  curl -L -oARCHIVE $FZF_URL
  tar -x -z --strip-components=0 -C EXTRACT -f ARCHIVE
  chmod a+x EXTRACT/fzf
  mv EXTRACT/fzf "$PREFIX"/bin/

  fzf --bash > "$HOME"/.fzf.bash
}
ALL+=(fzf)

function install_liquidprompt {
  curl -L -oliquidprompt $LIQUIDPROMPT_URL
  chmod a+x liquidprompt
  mv liquidprompt "$PREFIX"/bin/
}
ALL+=(liquidprompt)

function install_direnv {
  curl -L -odirenv $DIRENV_URL
  chmod a+x direnv
  mv direnv "$PREFIX"/bin/
}
ALL+=(direnv)

function install_ctags {
  rm -rf EXTRACT && mkdir -p EXTRACT
  curl -L -oARCHIVE $CTAGS_URL
  tar -x -z --strip-components=1 -C EXTRACT -f ARCHIVE
  pushd EXTRACT || exit 1
  ./autogen.sh
  ./configure --prefix="$PREFIX"
  make
  make install
}
ALL+=(ctags)

function install_vim {
  rm -rf EXTRACT && mkdir -p EXTRACT
  curl -L -oARCHIVE $VIM_URL
  tar -x -z --strip-components=1 -C EXTRACT -f ARCHIVE
  pushd EXTRACT || exit 1
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
ALL+=(vim)

function install_rg {
  rm -rf EXTRACT && mkdir -p EXTRACT
  curl -L -oARCHIVE $RG_URL
  tar -x -z --strip-components=1 -C EXTRACT -f ARCHIVE
  mv EXTRACT/rg "$PREFIX"/bin/rg
}
ALL+=(rg)

function install_gdu {
  rm -rf EXTRACT && mkdir -p EXTRACT
  curl -L -oARCHIVE $GDU_URL
  tar -x -z -C EXTRACT -f ARCHIVE
  mv EXTRACT/gdu_linux_amd64_static "$PREFIX"/bin/gdu
}
ALL+=(gdu)

pushd "$TMPDIR" || exit 1

case "$1" in
  all )
    for f in "${ALL[@]}"; do
      install_"$f";
    done
    ;;
  * )
    if declare -F install_"$1" >/dev/null; then
      install_"$1"
    else
      echo "Cannot install $1"
    fi
    ;;
esac

