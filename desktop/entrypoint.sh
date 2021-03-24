#!/bin/sh

SUDO=/usr/bin/sudo
SU=/usr/bin/su
USER=docker
VNC_PASSWORD_DEFAULT=sodasoda

/etc/init.d/dbus start

if [ -z "$VNC_PASSWORD" ]; then
	VNC_PASSWORD=$VNC_PASSWORD_DEFAULT
fi

if [ -n "$USERRRRR" ]; then
    useradd --create-home --shell /bin/bash --user-group --groups adm,sudo $USER
    if [ -z "$PASSWORD" ]; then
        PASSWORD=docker
    fi
    HOME=/home/$USER
    echo "$USER:$PASSWORD" | chpasswd
    chown -R $USER:$USER ${HOME}
fi

$SUDO $SU - $USER -c "mkdir /home/$USER/.vnc"
$SUDO $SU - $USER -c "chmod u+rwx /home/$USER/.vnc"
$SUDO $SU - $USER -c "chmod og-rwx /home/$USER/.vnc"


$SUDO $SU - $USER -c "x11vnc -storepasswd "$VNC_PASSWORD" /home/$USER/.vnc/passwd"
$SUDO $SU - $USER -c "chmod 400 /home/$USER/.vnc/passwd"
export VNC_PASSWORD=

cd /home/$USER
$SUDO $SU - $USER -c "/usr/bin/tightvncserver -name GuruDockerDesktop -depth 16 -geometry 1600x900 :1"
$SUDO $SU - $USER -c "websockify --web=/usr/share/novnc 6901 localhost:5901"

# otra opcion ( que no funciono )
# xfwm4 xfce4-panel xfce4-settings xfce4-session xfce4-terminal xfdesktop4 xfce4-taskmanager tango-icon-theme

# /etc/X11/Xsession

