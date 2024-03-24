# Introduction
Scripts pour installer tous les logiciels afin de faire fonctionner MAME ainsi que le Front-End AttractMode+ avec le thème ArcadeFlow sur un Raspberry.

# Utilisation des scripts.
Il faut tout d'abord clôner ce repository ainsi que le repository [bash-tools](https://github.com/fxlevy/bash_tools) dans le dossier d'accueil de votre utlisateur.
Lancez ensuite depuis le dosser rpi4mame, le script 'install.sh' et suivre la procédure.

Cet outil est entièrement piloté et fonctionne par l'intermédiaire d'un écran de sélection de taches sur le même principe de fonctionnement que l'outil 'raspi-config'.
Il est diponible en Anglais et en Français.
Le choix de la langue se fait à partir de l'écran de sélection des taches.

Ces scripts sont actuellement conçus pour fonctionner uniquement avec un Raspberry Pi 5 du fait de l'optimisation pour le Cortex A76.
Mais il peut facilement être adapté afin de fonctionner sur d'autres modèles.

Ces scripts permettent d'installer de maniière simple et optimisé les logiciels suivants dans leur dernières versions:
- SDL2
- SDL TrueType Fonts.
- MAME
- SFML
- AttractMode Plus
- Le thème ArcadeFlow pour AttractMode.

Ces mêmes scripts permettent aussi de mettre à jour les logiciels s'ils ont déjà été installés avec ces scripts.

Ils ont été conçus sur la base de la méthode et des scripts [How to make a dedicated MAME Appliance on a Raspberry Pi 4/Pi 400](https://gist.github.com/sonicprod#how-to-make-a-dedicated-mame-appliance-on-a-raspberry-pi-4pi-400) élaborés par [@sonicprod](https://gist.github.com/sonicprod).

Un grand merci à lui.

# Outils de configuration des logiciels.

Un deuxième script 'setup.sh' est également disponible dans ce repository.
Il est en cours de construction et devra permettre de configurer ces logiciels.
Cependant, en explorant le dossier templates, vous trouverez des fichiers qui vous aiderons à configurer ces logiciels en attendant que ce script soit opérationnel.
