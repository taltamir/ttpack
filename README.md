# ttpack
A collection of KoL scripts by taltamir

discussion thread: https://kolmafia.us/showthread.php?25048

## Installation

Run this command in the gCLI:
```
svn checkout https://github.com/taltamir/ttpack/trunk/RELEASE/
```
Will require [a recent build of KoLMafia](http://builds.kolmafia.us/job/Kolmafia/lastSuccessfulBuild/).

## Uninstall

Run this command in the gCLI:
```
svn delete ttpack
```

## getmu.ash
A script to farm Mu familiar from the Tall Grass Garden
https://kol.coldfront.net/thekolwiki/index.php/Mu

Run this command in the gCLI:
```
getmu X
```
Where X = fertilizer you want to use.

Or you can click on it from the dropdown scripts menu to be asked how many fertilizers you want to use.

This script will use the indicated amount of fertilizer (or how much you have in inventory, whichever is lesser) to try to farm a Mu in your tall grass. It currently can only use the strategy of raising the grass to 7 growth and then harvesting it 7 times to 0.
Warning: it takes a while. If you are doing thousands of fertilizer then it will take hours.
I managed to get 1 mu thus far for 1/3rd the mall price.

## dpills.ash
Script specific discussion thread: https://kolmafia.us/showthread.php?24434

A script to farm (equal amount of) Distention pill and synthetic Dog hair pill
https://kol.coldfront.net/thekolwiki/index.php/Distention_pill
https://kol.coldfront.net/thekolwiki/index.php/Synthetic_dog_hair_pill

Run from gCLI via
```
dpills X
```
X = adventures farming pills

Or you can click on it from the dropdown scripts menu to be asked how many fights you want.

Note: You are expected to have set an appropriate mood, ccs, and outfit ahead of time.

## blackpudding.ash

Farm fights againt black pudding for Awwww, Yeah trophy.
https://kol.coldfront.net/thekolwiki/index.php/Black_pudding_(monster)
https://kol.coldfront.net/thekolwiki/index.php/Awwww,_Yeah

The trophy requires you to defeat 240 black puddings (the monster). You do this by eating roughly 450 black puddings (the food) which is trash food of size 3. Every time you try to eat the food, there is a 35% chance that you will fight the monster, and a 65% chance that you will eat the food.

There is a trick with the dark gyffte path. If a vampyre tries to eat a pudding there is a 35% chance of them fighting the monster, and a 65% chance of them harmlessly being told vampyres only eat blood. So if you have 240 adventures, you can do this trophy in one day by just repeatedly attempting to eat it.

Run from gCLI via
```
blackpudding X
```
X = black puddings to fight

Or you can click on it from the dropdown scripts menu to be asked how many fights you want.
The script will repeatedly attempt to eat puddings until the quantity you specified has been reached.
