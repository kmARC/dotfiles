FROM ubuntu:17.10
LABEL maintainer "Mark Korondi <korondi.mark@gmail.com>"

# Install packages
RUN apt-get update
RUN apt-get install -y \
		--no-install-recommends \
		--no-install-suggests \
		vim-nox
RUN apt-get install -y \
		--no-install-recommends \
		--no-install-suggests \
		git locales

# Set proper encoding
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color

# Clone vim repo
RUN git clone https://github.com/kmARC/vim.git ~/.vim
RUN vim +PlugInstall +qall

# Install additional packages
RUN apt-get install -y \
		--no-install-recommends \
		--no-install-suggests \
		silversearcher-ag par

# Cleanup
RUN rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/apt/archives/*.deb

VOLUME /test

ENTRYPOINT ["vim"]
