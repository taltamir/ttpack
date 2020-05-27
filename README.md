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
