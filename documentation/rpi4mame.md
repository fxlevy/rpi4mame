## Links

System, Installation and configuration for a dedicated MAME on Raspberrry from [Sonicprod](https://gist.github.com/sonicprod):
https://gist.github.com/sonicprod/f5a7bb10fb9ed1cc5124766831e120c4

Roms, Extras and Mulimedia file for MAME from Pleasuredom:
https://pleasuredome.github.io/pleasuredome/mame/index.html

Mame ini files from [AntoPISA](https://github.com/AntoPISA)
https://www.progettosnaps.net/support/

Bezels (Artwors Wide Screen) from [AntoPISA](https://github.com/AntoPISA)
https://www.progettosnaps.net/artworks/

Bash spinner script from [Wolf](https://github.com/TGWolf)
https://github.com/DevelopersToolbox/bash-spinner/
osnaps.net/artworks/

## Usefull Linux commands

jstest /dev/input/js0 -> Pour tester que les boutons et le joystick fonctionne.
evtest /dev/input/event0
thd --dump /dev/input/event0 -> Pour identifier les évènements générés lorsque l'on utilise les boutons ou le joystick

## Picade console Buttons mapping

| Event category | Event name | Event value | Event trigger | Description |
|---|---|:---:|---|---|
| EV_ABS | ABS_Y | -127 | /dev/input/event0 | Joystick up |
| EV_ABS | ABS_Y | 127 | /dev/input/event0 | Joystick down |
| EV_ABS | ABS_X | -127 | /dev/input/event0 | Joystick left |
| EV_ABS | ABS_X | 127 | /dev/input/event0 | Joystick right |
| EV_KEY | BTN_GAMEPAD | 1 |/dev/input/event0 | Boutton 1 |
| EV_KEY | BTN_B | 1 | /dev/input/event0 | Boutton 2 |
| EV_KEY | BTN_C | 1 | /dev/input/event0 | Boutton 3 |
| EV_KEY | BTN_X | 1 | /dev/input/event0 | Boutton 4 |
| EV_KEY | BTN_WEST | 1 | /dev/input/event0 | Boutton 5 |
| EV_KEY | BTN_Z | 1 | /dev/input/event0 | Boutton 6 |
| EV_KEY | BTN_TL2 | 1 | /dev/input/event0 | Boutton right side |
| EV_KEY | BTN_TR2 | 1 | /dev/input/event0 | Boutton left side |
| EV_KEY | BTN_SELECT | 1 | /dev/input/event0 | Boutton front left |
| EV_KEY | BTN_START | 1 | /dev/input/event0 | Boutton front right |

## Start a frontend automatically at startup

Create a Bash Alias to set the Frontend value

```
nano ~/.bash_aliases
```

>alias frontend='upd(){ grep -q $1= /home/pi/rpi4mame/configs/settings && sed -i "s/^$1=.*$/$2/g" $(readlink -f /home/pi/rpi4mame/configs/settings) || echo $2 | tee -a /home/pi/rpi4mame/configs/settings;}; _frontend(){ if [[ "${1,,}" =~ ^(mame|attract)$ ]]; then [ ! -f /home/pi/rpi4mame/configs/settings ] && touch /home/pi/rpi4mame/configs/settings; upd FRONTEND FRONTEND="${1,,}" && echo "Frontend set to: "${1,,}" (reboot to apply).";  else echo "Invalid or missing argument. Try: mame [rom], attract [emulator rom] or advance"; fi;}; _frontend'

Reload Bash alias

```
. ~/.bash_aliases
```

Create a service which will execute a starting script.

```
sudo systemctl edit rpi4mame-autostart.service --force --full
```

  GNU nano 7.2                                                 /etc/systemd/system/.#rpi4mame-autostart.serviced264b163fc06da41                                                           
>[Unit]
>Description=RPI4MAME Autostart service
>Conflicts=getty@tty1.service smbd.service nmbd.service rng-tools.>service cron.service
>Requires=local-fs.target
>After=local-fs.target
>ConditionPathExists=/home/pi/rpi4mame/configs/settings
>
>[Service]
>User=pi
>Group=pi
>PAMName=login
>Type=simple
>EnvironmentFile=/home/pi/rpi4mame/configs/settings
>ExecStart=/home/pi/rpi4mame/scripts/autostart.sh
>Restart=on-abort
>RestartSec=5
>TTYPath=/dev/tty1
>StandardInput=tty
>
>[Install]
>WantedBy=multi-user.target

## Start attractplus or mame from push buttons

Install triggerhappy

sudo apt install triggerhappy

Identify trigger events

```
thd --dump /dev/input/event*
```

push the buttons and read the result

>EV_KEY  BTN_SELECT      1       /dev/input/event1
>EV_KEY  BTN_GAMEPAD     1       /dev/input/event1
>EV_KEY  BTN_X   1       /dev/input/event1
>EV_KEY  BTN_B   1       /dev/input/event1
>EV_KEY  BTN_WEST        1       /dev/input/event1

Stop analysis by typing `Ctrl+C`

Create the trigger configuration file

```
sudo nano /etc/triggerhappy/triggers.d/rpi4mame.conf
```

>BTN_GAMEPAD+BTN_SELECT  1       /home/pi/rpi4mame/scripts/start.mame.sh
>BTN_X+BTN_SELECT        1       /home/pi/rpi4mame/scripts/start.attract.sh
>BTN_B+BTN_SELECT        1       /usr/bin/amixer set PCM 5%+
>BTN_WEST+BTN_SELECT     1       /usr/bin/amixer set PCM 5%-

Create mame start script

```
sudo nano /home/pi/rpi4mame/scripts/start.mame.sh
```

>su - pi <<!
>welcome
>/usr/local/bin/mame >/dev/null 2>/dev/null

```
sudo nano /home/pi/rpi4mame/scripts/start.attract.sh
```

>su - pi <<!
>welcome
>/usr/local/bin/attractplus --loglevel silent >/dev/null 2>&1

Restart triggerhappy service

```
sudo systemctl restart triggerhappy.service
```

Using Front Left Button and First button at the same time will start Mame.
Using Front Left Button and Fourth button at the same time will start AttractPlus.
