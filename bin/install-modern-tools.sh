#!/usr/bin/env bash

set -Eeuo pipefail

FZF_VERSION=0.61.1          # https://github.com/junegunn/fzf/releases/
FZF_GITSH_VERSION=main      # https://github.com/junegunn/fzf-git.sh
LIQUIDPROMPT_VERSION=2.2.1  # https://github.com/liquidprompt/liquidprompt/releases/
DIRENV_VERSION=2.35.0       # https://github.com/direnv/direnv/releases/
CTAGS_VESION=6.1.0          # https://github.com/universal-ctags/ctags/releases/
VIM_VERSION=9.1.1236        # https://github.com/vim/vim/tags
RG_VERSION=14.1.1           # https://github.com/BurntSushi/ripgrep/releases
GDU_VERSION=5.30.1          # https://github.com/dundee/gdu/releases
BUILDIFIER_VERSION=8.0.3    # https://github.com/bazelbuild/buildtools/releases/
TMUX_VERSION=3.5a           # https://github.com/tmux/tmux/releases/
GRC_VERSION=v1.13           # https://github.com/garabik/grc/releases
KUBECTL_VERSION=1.32.3      # https://dl.k8s.io/release/stable.txt
JQ_VERSION=1.7.1            # https://github.com/jqlang/jq/releases

FZF_URL=https://github.com/junegunn/fzf/releases/download/v$FZF_VERSION/fzf-$FZF_VERSION-linux_amd64.tar.gz
FZF_GITSH_GIT=https://github.com/junegunn/fzf-git.sh.git
LIQUIDPROMPT_URL=https://github.com/liquidprompt/liquidprompt/releases/download/v$LIQUIDPROMPT_VERSION/liquidprompt
DIRENV_URL=https://github.com/direnv/direnv/releases/download/v$DIRENV_VERSION/direnv.linux-amd64
CTAGS_URL=https://github.com/universal-ctags/ctags/releases/download/v$CTAGS_VESION/universal-ctags-$CTAGS_VESION.tar.gz
VIM_URL=https://github.com/vim/vim/archive/refs/tags/v$VIM_VERSION.tar.gz
RG_URL=https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz
GDU_URL=https://github.com/dundee/gdu/releases/download/v$GDU_VERSION/gdu_linux_amd64_static.tgz
BUILDIFIER_URL=https://github.com/bazelbuild/buildtools/releases/download/v$BUILDIFIER_VERSION/buildifier-linux-amd64
TMUX_URL=https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz
GRC_GIT=https://github.com/garabik/grc.git
KUBECTL_URL=https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl
JQ_URL=https://github.com/jqlang/jq/releases/download/jq-$JQ_VERSION/jq-linux-amd64

export MAKEFLAGS="-j"

LOCAL_CHECKOUTS="${MODERN_TOOLS_LOCAL_CHECKOUTS:-$HOME/src}"

PREFIX="${MODERN_TOOLS_PREFIX:-$HOME/.local}"
export PREFIX
PKG_CONFIG_PATH="$PREFIX"/lib/pkgconfig
export PKG_CONFIG_PATH

TMPDIRS=()
# # shellcheck disable=SC2064
# trap 'echo rm -rf "${TMPDIRS[@]}"; exit 0' 0    # EXIT
# # shellcheck disable=SC2064
# trap 'echo rm -rf "${TMPDIRS[@]}"; exit 2' 2    # INT
# # shellcheck disable=SC2064
# trap 'echo rm -rf "${TMPDIRS[@]}"; exit 1' 1 15 # HUP TERM

mkdir -p "$PREFIX"/bin "$LOCAL_CHECKOUTS"

function _install {
  TMPDIR="$(mktemp -d -t install_$1.XXXXXX)"
  TMPDIRS+=($TMPDIR)

  pushd "$TMPDIR" || exit 1
  mkdir -p EXTRACT

  install_$1

  popd
}

function _install_git {
  pushd "$LOCAL_CHECKOUTS" || exit 1

  local _git_var=${1^^}_GIT
  local _git=${!_git_var}
  
  if ! [ -d "$1" ]; then
    git clone "$_git" "$1"
  fi

  pushd "$1"
  local _git_ver_var=${1^^}_VERSION
  local _git_ver=${!_git_ver_var}
  git fetch origin "$_git_ver"
  git checkout "$_git_ver"

  install_git_"$1"

  popd
  popd
}

function install_git_fzf_gitsh {
  mkdir "$XDG_DATA_HOME"/fzf-git/
  ln -sf "$PWD"/fzf-git.sh "$XDG_DATA_HOME"/fzf-git/fzf-git.sh
}
ALL_GIT+=(fzf-git)

function install_fzf {
  curl -L -oARCHIVE $FZF_URL
  tar -x -z --strip-components=0 -C EXTRACT -f ARCHIVE
  chmod a+x EXTRACT/fzf
  mv EXTRACT/fzf "$PREFIX"/bin/

  fzf --bash > "$XDG_DATA_HOME"/bash-completion/completions/fzf

  # fzf has --man, but it doesn't generate the man page, just displays it
  curl -L -o"$XDG_DATA_HOME"/man/man1/fzf.1 https://raw.githubusercontent.com/junegunn/fzf/refs/tags/v$FZF_VERSION/man/man1/fzf.1
  curl -L -o"$XDG_DATA_HOME"/man/man1/fzf-tmux.1 https://raw.githubusercontent.com/junegunn/fzf/refs/tags/v$FZF_VERSION/man/man1/fzf-tmux.1
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

function install_jq {
  curl -L -ojq $JQ_URL
  chmod a+x jq
  mv jq "$PREFIX"/bin/
}
ALL+=(jq)

function install_kubectl {
  curl -L -okubectl $KUBECTL_URL
  chmod a+x kubectl
  mv kubectl "$PREFIX"/bin/
}
ALL+=(kubectl)

function _install_pcre2 {
  PCRE2_VERSION=10.23 # Same as in EL7
  PCRE2_URL=https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VERSION/pcre2-$PCRE2_VERSION.tar.gz
  curl -L -oARCHIVE $PCRE2_URL
  tar -x -z --strip-components=1 -C EXTRACT -f ARCHIVE
  pushd EXTRACT || exit 1

  ./configure --prefix="$PREFIX"
  make
  make install

  popd
}

function install_ctags {
  if grep -q 'VERSION_ID="7' /etc/os-release; then
    _install_pcre2
  fi

  curl -L -oARCHIVE $CTAGS_URL
  tar -x -z --strip-components=1 -C EXTRACT -f ARCHIVE
  pushd EXTRACT || exit 1

  ./autogen.sh
  ./configure --prefix="$PREFIX"
  make
  make install

  popd
}
ALL+=(ctags)

function install_vim {
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

  popd
}
ALL+=(vim)

function install_rg {
  curl -L -oARCHIVE $RG_URL
  tar -x -z --strip-components=1 -C EXTRACT -f ARCHIVE
  mv EXTRACT/rg "$PREFIX"/bin/rg

  rg --generate=complete-bash > "$XDG_DATA_HOME"/bash-completion/completions/rg
  rg --generate=man > "$XDG_DATA_HOME"/man/man1/rg.1
}
ALL+=(rg)

function install_gdu {
  curl -L -oARCHIVE $GDU_URL
  tar -x -z -C EXTRACT -f ARCHIVE
  mv EXTRACT/gdu_linux_amd64_static "$PREFIX"/bin/gdu
}
ALL+=(gdu)

function install_buildifier {
  curl -L -oBINARY $BUILDIFIER_URL
  chmod a+x BINARY
  mv BINARY "$PREFIX"/bin/buildifier
}
ALL+=(buildifier)

function _install_libevent {
  # LIBEVENT_VERSION=2.0.21 # Same as in EL7
  LIBEVENT_VERSION=2.1.12
  LIBEVENT_URL=https://github.com/libevent/libevent/archive/refs/tags/release-$LIBEVENT_VERSION-stable.tar.gz
  curl -L -oARCHIVE $LIBEVENT_URL
  tar -x -z --strip-components=1 -C EXTRACT -f ARCHIVE
  pushd EXTRACT || exit 1

  ./autogen.sh || true
  ./configure --prefix="$PREFIX"
  make
  make install

  popd
}

function install_tmux {
  _install_libevent
  curl -L -oARCHIVE $TMUX_URL
  tar -x -z --strip-components=1 -C EXTRACT -f ARCHIVE
  pushd EXTRACT || exit 1

  ./configure --prefix="$PREFIX"
  make
  make install

  popd
}
ALL+=(tmux)

case "$1" in
  all )
    for f in "${ALL[@]}"; do
      _install "$f";
    done
    for f in "${ALL_GIT[@]}"; do
      _install_git "$f";
    done
    ;;
  * )
    if   declare -F install_"$1" >/dev/null; then
      _install "$1"
    elif declare -F install_git_"$1" >/dev/null; then
      _install_git "$1"
    else
      echo "Cannot install $1"
    fi
    ;;
esac

