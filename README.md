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
sudo apt install -y git python
git clone https://github.com/kmARC/dotfiles ~/.dotfiles
cd ~/.dotfiles && git submodule update --init
sudo ./install-packages-console
sudo ./install-packages-gui
./install
sudo ./install-system
cd -
```

Re-login / restart bash.

### Configuration

I used to depend on [base16] however currently I configure colorization from
`color.kmarc`. I'll clean this up in the future

[base16]: https://github.com/chriskempson/base16

## Desktop

### Set up terminal

I use rxvt-unicode-256color as my terminal. To enable the daemon mode of it, use
the `urxvtcd` binary for x-terminal-emulator.

```bash
sudo update-alternatives --install /etc/alternatives/x-terminal-emulator urxvtcd /usr/bin/urxvtcd 20
```

### Install bspwm and sxhkd

``` bash
mkdir -p ~/.local/src

# bspwm
git clone https://github.com/baskerville/bspwm.git ~/.local/src/bspwm
cd ~/.local/src/bspwm
make
sudo make install
cd -
sudo mkdir -p /usr/share/xsessions
sudo ln -s /usr/local/share/xsessions/bspwm.desktop /usr/share/xsessions/

# sxhkd
git clone https://github.com/baskerville/sxhkd.git ~/.local/src/sxhkd
cd ~/.local/src/sxhkd
make
sudo make install
cd -
```

### Install Polybar

[FontAwesome]

``` bash
mkdir -p ~/.fonts
wget http://fontawesome.io/assets/font-awesome-4.7.0.zip -P /tmp
unzip /tmp/font-awesome-4.7.0.zip -d ~/.fonts
fc-cache -f
```

[Polybar]

``` bash
git clone --recursive https://github.com/jaagr/polybar ~/.local/src/polybar
mkdir ~/.local/src/polybar/build
cd ~/.local/src/polybar/build
cmake ..
make -j5
sudo make install
cd -
```

[FontAwesome]: http://fontawesome.io/
[Polybar]: https://github.com/jaagr/polybar

### Install i3 screen locker

``` bash
git clone https://github.com/chrjguill/i3lock-color ~/.local/src/i3lock-color
cd ~/.local/src/i3lock-color
make -j5
sudo make install
```

### Install hideIt.sh

``` bash
git clone https://github.com/Tadly/hideIt.sh ~/.local/src/hideIt.sh
```

### Configuration

To select a wallpaper, use `feh`.

``` bash
~/bin/colorize.sh ~/.colors.kmarc
feh --bg-fill path_to_wallpaper
```

### (Optional) Install Mopidy (Spotify & TuneIn)

``` bash
wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/jessie.list
sudo apt update
sudo apt install -y mopidy mopidy-spotify
sudo -H pip install Mopidy-TuneIn Mopidy-Spotify-Web Mopidy-SoundCloud \
                    Mopidy-MPRIS
```


### Restart your desktop

You can use either `startx` or selecting any desktop environments from lightdm
(unfortunately `.xinitrc` will override any options)
