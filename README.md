# dotfiles

``` shell

sudo dnf remove korganizer akregator kdepim-addons kontact pim-sieve-editor libsieve dragon neochat elisa-player

sudo dnf install --enablerepo='*debug*' fuse fontawesome-fonts-all make git gcc g++ clang++ elementary-icon-theme btrfs-assistant oxygen* plasma-oxygen-qt6 plasma-oxygen-qt5 mpv libvterm emacs thunderbird cgdb clangd clang-format clang valgrind gtest gmock docker docker-compose virtualbox-guest-additions ffmpeg libheif rust cargo rustc stow adw-gtk* lualatex pdf-tools texlive-scheme-full git-credential-oauth autoconf automake poppler-devel poppler-glib-devel zlib-devel pkgconf libtool libasan syncthing dnfdragora 7zip adwaita-sans-fonts adwaita-mono-fonts kpublictransport maven java-25-openjdk-headless nodejs vlc virtualbox cascadia-code* wireshark skanpage transmission kclock jetbrains-mono* chromium sqlite sqlitebrowser helix imhex cmake cutter-re lokalize kbibtex gdb gnome-system-monitor We10X* dolphin-emu gimp foliate filelight visualboyadvance-m git-lfs adb fastboot fira-code* rust-analyzer raylib raylib-devel ALL-openmpi* spdlog* winetricks bottles geany plasma-oxygen *papirus* libxcrypt-compat GtkAda gcc-gnat gprbuild libasan-debuginfo spdlog-debuginfo gtest-debuginfo gmock-debuginfo libstdc++-debuginfo glibc-debuginfo libubsan-debuginfo libgcc-debuginfo fmt-debuginfo gtest-devel gmock-devel libubsan httpie *plantuml* GtkAda3-devel --allowerasing

git-credential-oauth configure

git config --global user.name "SAMPLE NAME"

git config --global user.email EMAIL@SAMPLE.COM
	
sudo usermod -a -G dialout $USER

export GPR_PROJECT_PATH=/usr/share/gpr:/usr/lib64/gnat:/usr/lib/gnat

```

``` shell
# Crear Hotspot Wi-Fi con SSID "A", Contraseña "12345678", Banda de 2,4 GHz
nmcli device wifi hotspot ifname wlp4s0 con-name A ssid A band bg password 12345678

# Ver zonas de Interfaz
sudo firewall-cmd --get-zone-of-interface=wlp4s0

# Espiar consola
sudo tcpdump -i wlp4s0 host 10.42.0.3

# Abrir puerto 
sudo firewall-cmd --zone=nm-shared --add-port=3000/tcp

# Listar puertos abiertos
sudo firewall-cmd --zone=nm-shared --list-ports

# Mitigar problemas de Offloading
sudo ethtool -K wlp4s0 tso off gso off gro off
```
