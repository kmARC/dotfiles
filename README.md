# kmARC's dotfiles

<p align="center">
  <a href="images/desktop-terminal.png"><img src="images/desktop-terminal.png"></a>
  <a href="images/desktop-full.png"><img src="images/desktop-full.png" width="48%"></a>
  <a href="images/desktop-empty.png"><img src="images/desktop-empty.png" width="48%"></a>
</p>

- Wallpaper: https://github.com/elementary/wallpapers/blob/master/Ashim%20DSilva.jpg
- VIM configuration: https://githu.bom/kmarc/vim

## Installation on Arch Linux

### AUR packages (`yay`)

I'm using [yay] to acquire packages from [AUR].

``` bash
# Install preqrequisited
sudo pacman -Syu
sudo pacman -S base-devel git

# Don't forget to tune /etc/makepkg.conf (MAKEFLAGS="-j3" / "-j5")
sudo vi /etc/makepkg.conf

# Acquire yay PKGBUILD
mkdir -p /tmp/yay
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay

# Install yay
makepkg -si
```

[yay]: https://aur.archlinux.org/packages/yay/
[AUR]: https://aur.archlinux.org

### Dotfiles

> Note: You might want to create your own fork from this repo and `clone` the fork.

``` bash
# Install prerequisites
sudo pacman -S python tmux

# Clone dotfiles repository
git clone --recursive --depth=1 https://github.com/kmARC/dotfiles ~/.dotfiles

# Install symlinks
~/.dotfiles/install
```

Re-login / restart bash.

### Shell & color theme

This setup heavily depends on the brilliant [base16] project.

``` bash
# Install prerequisites
sudo pacman -S xorg-xrdb
yay -S base16-manager

# Install and select a theme
base16-manager install chriskempson/base16-shell
base16-manager set solarized-dark

# Populate theming variables
bin/colorize.sh
```

[base16]: https://github.com/chriskempson/base16

### Bash customizations

There are some customizations in my bashrc. Install and enable them as you like.

``` bash
# Install prerequisites (select what you need. Order is the same as in .bashrc.kmarc)
yay -S fzf \
       nvm \
       tmux \
       direnv \
       todotxt xdg-user-dirs \
       ripgrep \
       liquidprompt

# Enable bashrc customizations
echo "source $HOME/.bashrc.kmarc" >> "$HOME/.bashrc"
```

## Misc dependencies

Have a look at  [install.conf.yaml](install.conf.yaml) to get a hint on  what software is configured
with these dotfiles. Here is a categorization of what you might want to use from my repo.

### Productivity: Mail + Calendar + Contacts

I  have  a  95% terminal-based  workflow  for  Mail  ([neomutt]),  Calendar ([khal]),  and  Contacts
([khard]). All configured  to work together with  GMail/Google Suite, and Office  365. Calendars are
syncronized from all these sources and from facebook. All from terminal!

```bash
# Mail
sudo pacman -S neomutt offlineimap libsecret
yay -S urlscan mutt-ics
sudo pacman -S notmuch  # Fast email indexing support
sudo pacman -S pandoc   # HTML email editing support
yay -S davmail          # o365 synchronization support

# Calendar + Contacts
sudo pacman -S khal khard vdirsyncer python-requests-oauthlib
```

Neomutt  configuration resides  in [muttrc](muttrc)  and [mutt/muttrc.\_gmail_](mutt/muttrc._gmail_)
and [mutt/muttrc.\_owa_](mutt/muttrc._owa_).  However, it  sources `~/.pdotfiles/muttrc`,  where _p_
stands  for _private_,  thus not  included  in this  repository. You  can  find examples  on how  to
configure tools in  the [pdotfiles](pdotfiles) directory. Note: *.pdotfiles* setup  is not automated
by this repository.

[neomutt]: https://neomutt.org/
[khal]: https://lostpackets.de/khal/
[khard]: https://github.com/scheibler/khard/

### Graphical system

You most probably want Xorg and a login manager (some apps require it).

``` bash
sudo pacman -S \
  lightdm-gtk-greeter \
  xorg-xserver
```

### Desktop: tiled window manager and panel

Window manager is provided  by [bspwm], hotkeys by [sxhkd], compositing by  [picom], a launcher by
[rofi] and a fancy panel by [polybar].

``` bash
# Install window manager & tools
sudo pacman -S bspwm sxhkd picom rofi
sudo pacman -S libmpdclient # Media Player Daemon support
sudo pacman -S pulseaudio   # Pulseaudio support
yay -S polybar ttf-{emojione,material-icons}

# Install startx / desktop.sh dependencies
sudo pacman -S \
  dex \
  feh \
  geoclue2 \
  jq \
  libpulse \
  polkit-gnome \
  redshift \
  system-config-printer \
  wmname \
  xcape \
  xdotool \
  xf86-input-synaptics \
  xfce4-notifyd \
  xorg-{xbacklight,xinput,xprop,xrandr,xsetroot,xwininfo}

# Set a wallpaper
feh --bg-fill path_to_wallpaper
```

[bspwm]: https://github.com/baskerville/bspwm
[sxhkd]: https://github.com/baskerville/sxhkd
[compton]: https://github.com/chjj/compton
[polybar]: https://github.com/jaagr/polybar
[rofi]: https://github.com/DaveDavenport/rofi

### Music player

An MPD compatible daemon, [mopidy] is responsible for my daily music intake. For configuration, see
examples in [pdotfiles/](pdotfiles/)

``` bash
# Install / upgrade mopidy
yay -S libspotify
sudo -H pip install -U mopidy{,-spotify,-spotify-web,-soundcloud,-tunein,-mpris,-mpd}
```

[mopidy]: https://www.mopidy.com/

### Apps & Tools

Have a look at the [sxhkd configuration](config/sxhkd/sxhkdrc) and customize the launchable apps /
tools

``` bash
# Sxhkd shortcuts
sudo pacman -S \
  firefox \
  mpc \
  ranger \
  thunar \
  xfce4-terminal
yay -S splatmoji-git

# Other tools
sudo pacman -S \
  hplip
```

### GUI themes

I keep it  simple: using [Arc] GTK and  icon themes, configured Qt/KDE applications to  pick up gtk2
theme settings. `lxappearance` is a handy tool to set gtk2/3 themes.

[Arc]: https://github.com/horst3180/Arc-theme

``` bash
sudo pacman -S arc-{gtk,icon}-theme elementary-icon-theme gtk-engine-murrine lxappearance \
          qt5-styleplugins
```

### Quirks

Sometimes I use Xfce's panel `xfce4-panel` to display the notification's icon and system tray
(by default hidden when out of focus). It's started automatically by [xstart](xstart). You might
need to disable / tweak it's look as you like

### Restart your desktop

You can use either `startx` or selecting any desktop environments from lightdm
(unfortunately `.xinitrc` will override any options)
