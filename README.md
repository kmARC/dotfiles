# kmARC's dotfiles

<a href="images/desktop-empty.png"><img src="images/desktop-empty.png"></a>
<center>
<a href="images/desktop-full.png"><img src="images/desktop-full.png" width="48%"></a>
<a href="images/desktop-terminal.png"><img src="images/desktop-terminal.png" width="48%"></a>
</center>

(Wallpaper: http://gallery.world/wallpaper/520.html)

## Console

Tested on Ubuntu Server 16.10

``` bash
sudo apt install -y git python tmux
git clone https://github.com/kmARC/dotfiles ~/.dotfiles
cd ~/.dotfiles && git submodule update --init && ./install && cd -
```

Re-login / restart bash.

### Configuration

To select a theme, type `base16_<TAB>` and you'll see the fantastic theme
collection from [base16]. My preference is...

    base16_materia

[base16]: https://github.com/chriskempson/base16

### Install basic apps

The following apps are configured via this dotfiles repository.

``` bash
sudo apt install -y htop mc
```

These are  some handy  tools what I  like however not  (yet!) configured  by the
dotfiles.

``` bash
sudo apt install -y dfc iotop moreutils powertop rar tig tlp zip
```

## Desktop

### Install basic apps

``` bash
sudo apt install -y consolekit compton dex elementary-icon-theme feh \
                    fonts-noto jq libx11-protocol-other-perl lightdm \
                    lightdm-gtk-greeter mpc network-manager-openvpn-gnome rofi \
                    rxvt-unicode-256color suckless-tools shutter thunar \
                    x11-xserver-utils x11-utils xcape xinit xinput \
                    xscreensaver xsel xubuntu-icon-theme
```

### Set up terminal

I use rxvt-unicode-256color as my terminal. To enable the daemon mode of it, use
the `urxvtcd` binary for x-terminal-emulator.

```bash
sudo update-alternatives --install /etc/alternatives/x-terminal-emulator urxvtcd /usr/bin/urxvtcd 20
```

### Install bspwm and sxhkd

``` bash
mkdir -p ~/.local/src

# prerequisites
sudo apt install -y build-essential
sudo apt install -y libxcb-{xinerama0,icccm4,randr0,util,ewmh,keysyms1}-dev

# bspwm
git clone https://github.com/baskerville/bspwm.git ~/.local/src/bspwm
cd ~/.local/src/bspwm
make
sudo make install
cd -

# sxhkd
git clone https://github.com/baskerville/sxhkd.git ~/.local/src/sxhkd
cd ~/.local/src/sxhkd
make
sudo make install
cd -
```

### Install Terminal Font

[Source Code Pro]

``` bash
wget https://fonts.google.com/download?family=Source%20Code%20Pro -O /tmp/source-code-pro.zip
unzip /tmp/source-code-pro.zip -d ~/.fonts
fc-cache -f
```

### Install Polybar

[Fontawesome]

``` bash
mkdir -p ~/.fonts
wget http://fontawesome.io/assets/font-awesome-4.7.0.zip -P /tmp
unzip /tmp/font-awesome-4.7.0.zip -d ~/.fonts
fc-cache -f
```

[Polybar]

``` bash
sudo apt install -y cmake pkg-config
sudo apt install -y libasound2-dev libcairo2-dev libcurl4-openssl-dev \
                    libmpdclient-dev libxcb-xkb-dev libxcb-image0-dev \
                    libxcb-xrm-dev libiw-dev python-xcbgen xcb-proto

git clone --recursive https://github.com/jaagr/polybar ~/.local/src/polybar
mkdir ~/.local/src/polybar/build
cd ~/.local/src/polybar/build
cmake ..
make -j5
sudo make install
cd -
```

[Fontawesome]: http://fontawesome.io/
[Polybar]: https://github.com/jaagr/polybar

### Install packages from Webupd8

``` bash
sudo add-apt-repository -y ppa:nilarimogard/webupd8
sudo apt update
sudo apt install -y arc-theme qt5ct ncmpcpp
```

### Configuration

To select a wallpaper, use `feh`.

``` bash
feh --bg-fill path_to_wallpaper
```

### (Optional) Install Mopidy (Spotify & TuneIn)

``` bash
sudo apt install -y python-pip

wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/jessie.list
sudo apt update
sudo apt install -y mopidy mopidy-spotify
sudo -H pip install Mopidy-TuneIn Mopidy-Qsaver
```

### Restart your desktop

You can use either `startx` or selecting any desktop environments from lightdm
(unfortunately `.xinitrc` will override any options)
