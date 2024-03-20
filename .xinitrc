#xrandr --setprovideroutputsource modesetting NVIDIA-0

systemctl --user import-environment DBUS_SESSION_BUS_ADDRESS
systemctl --user import-environment XAUTHORITY
systemctl --user import-environment XDG_RUNTIME_DIR
systemctl --user import-environment DISPLAY

systemctl --user start replay-sorcery.service

sudo vnstatd -d & disown
parcellite & disown
/usr/local/bin/focus-last.py & disown
#sudo wg-systray & disown
#blueman-applet & disown

xset r rate 250 47

exec i3
#exec focus-last.py
