systemctl --user import-environment DBUS_SESSION_BUS_ADDRESS
systemctl --user import-environment XAUTHORITY
systemctl --user import-environment XDG_RUNTIME_DIR
systemctl --user import-environment DISPLAY

parcellite & disown
sudo vnstatd -d & disown

xset r rate 310 45

exec i3
exec focus-last.py
