FROM ubuntu:18.10
LABEL maintainer="Mark Korondi <korondi.mark@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive


# Install packages
RUN apt-get update \
 && apt-get install -y \
    --no-install-recommends \
    --no-install-suggests \
    vim-nox \
    silversearcher-ag \
    par \
    locales \
    git \
 && rm -rf /var/lib/apt/lists/*

# Set proper encoding
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LANG     en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL   en_US.UTF-8
ENV TERM     xterm-256color

VOLUME /test

RUN groupadd -r user && useradd --no-log-init -r -g user user \
 && mkdir /home/user \
 && chown -R user:user /home/user

WORKDIR /home/user
USER user

RUN git clone --depth=1 https://github.com/kmARC/vim.git /home/user/.vim

RUN vim --not-a-term -n +PlugInstall +qall

ENTRYPOINT ["vim"]
