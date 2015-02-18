#!/bin/sh

#use syndaemon to disable touchpad while typing if it is installed!
syndaemon=`which syndaemon`
if [ ! -z "${syndaemon}" ];then
    $syndaemon -t -k -i 1 -d
fi

#Keyboard configuration: US-International
setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl &

#Wifi manager
wicd-gtk --tray &

#Background
sh ~/.fehbg.sh &

#start AwesomeWM and log the errors.
exec awesome >> ~/.awesomeLog 2>> ~/.awesomeLogError
