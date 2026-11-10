#!/bin/bash
#= bin/printhint_create_freedesktop_icon.sh

cat <<EOF

# d261110 jdg https://claude.ai/chat/d46e44cc-0d44-4a82-97ac-c140f97a7a9f "Desktop icon to open URL"

# The closest equivalent to MacOS 'open' is: xdg-open
> xdg-open https://my-url.com/
.
It opens the URL in your default browser, which on Raspberry Pi OS is Chromium. 
If Chromium is already running, the URL opens as a new tab in the existing window. 
If it isn’t running, Chromium starts.

# About .desktop files
They follow the freedesktop.org Desktop Entry Specification, a cross-desktop standard, 
so the same file works on GNOME, KDE Plasma, XFCE, Cinnamon, MATE, LXQt and others. 
Raspberry Pi OS doesn’t use GNOME: its desktop is built on labwc/Wayfire with pcmanfm 
and its own panel, and it reads the same files.
.
xdg-open is the same story. It comes from freedesktop’s xdg-utils and hands off to whatever desktop you’re running.
.
The menu entry in ~/.local/share/applications/ is the portable part. It shows up in the app launcher or menu on basically every Linux desktop.

#

cat > open-my-url.desktop <<'EOF'
#= open-my-url.desktop
#= ~/.local/share/applications/open-my-url.desktop
[Desktop Entry]
Type=Application
Name=Open My URL
Comment=Open my-url.com in Chromium
# Exec=xdg-open https://my-url.com/
Exec=/usr/lib/firefox/firefox https://my-url.com/
# Icon=chromium
Icon=firefox
Terminal=false
Categories=Network;
EOF

chmod +x open-my-url.desktop

mkdir -p ~/.local/share/applications
cp -av open-my-url.desktop ~/.local/share/applications/

EOF

#-EOF

