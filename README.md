# ttpack

A collection of KoL scripts by taltamir

discussion thread: https://kolmafia.us/showthread.php?25048

If there is a file in the pack that you see that is lacking a description here. Then it is probably still in beta and not entirely ready for release to the public. Please do not run it unless you examined the code and know exactly what it does.

## Dependencies
When installed it will also install the following dependencies:
```
https://github.com/Loathing-Associates-Scripting-Society/autoscend/branches/beta/RELEASE/
https://github.com/Ezandora/Briefcase/branches/Release/
https://github.com/soolar/CONSUME.ash/trunk/RELEASE/
https://svn.code.sf.net/p/rlbond86-mafia-scripts/code/auto_mushroom/trunk/
```

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

Script specific discussion thread: https://kolmafia.us/showthread.php?25051

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

Script specific discussion thread: https://kolmafia.us/showthread.php?23764

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

## guzzlr.ash

Script specific discussion thread: https://kolmafia.us/showthread.php?25050

Automate guzzlr deliveries and potentially starting and then immediately dropping a platinum delivery for the purpose of getting a daily cocktail set
https://kol.coldfront.net/thekolwiki/index.php/Guzzlr_cocktail_set

Script is highly configurable. Example settings:
```
Current settings for guzzlr:
guzzlr_deliverBronze = true
guzzlr_maxMeatCostBronze = 5000
guzzlr_deliverGold = true
guzzlr_maxMeatCostGold = 10000
guzzlr_deliverPlatinum = true
^Platinum will not be taken if you already used your 1 per day abandon
guzzlr_maxMeatCostPlatinum = 15000
^The maximum allowed price for cold wad and if needed a dayticket or access items
guzzlr_abandonTooExpensive = true
^When true will automatically abandon deliveries that are too expensive. When false will abort instead
guzzlr_deliverInrun = false
^Set to false to disable doing deliveries during a run
guzzlr_treatCasualAsAftercore = false
guzzlr_treatPostroninAsAftercore = true
guzzlr_abandonPlatinumForcedAftercore = false
^Override all other settings for the purpose of starting the day by taking a platinum delivery and immediately aborting it
guzzlr_abandonPlatinumForcedInrun = false
^Override all other settings for the purpose of starting the day by taking a platinum delivery and immediately aborting it
```

Run from gCLI via:
```
guzzlr X
```
X = adv to spend

To just show the current settings and explanation on what the settings do:
```
guzzlr 0
```

Or you can click on it from the dropdown scripts menu to be asked how many adv you want to spend.

The script will then take guzzlr and perform guzzlr deliveries based on your configuration

Note: You are expected to have set an appropriate mood, ccs, and outfit ahead of time.

## tt_display

Manage collections of things in your display case. there is a tt in front of it to distinguish it from mafia's built in display management (that can search for an item, add, or remove).

To use type in gCLI:
```
tt_display [goal]
Currently supported options     for [goal]:
figurines = display tiny plastic and die casted figurines.     A set of collectors items with several associated trophies
hobopolis =     auto zap hobopolis gear 1/day if you have a zapwand. display excess gear
hobo     = same as hobopolis
crimbo2019 = display and count the rare drops from     crimbo2019. display the counts and their mall values
crimbo19 = same as     crimbo2019
```

Each goal has its own separate configuration which will come up the first time you run it and every subsequent time you run it too.

### tt_display figurines

Helps you manage tiny plastic figurines and die-cast figurines
https://kol.coldfront.net/thekolwiki/index.php/Tiny_Plastic

Will place figurines into display case, remove excess if you want that, will mallbuy missing figurines based on price configurations. For currently dropping figurines it will also tell you how to acquire more from the game directly without mallbuying.

Has plenty of internal configuration options which will show up the first time you run it:
[code]
tt_display_figurines_displayTarget
tt_display_figurines_displayRemoveExcess
tt_display_figurines_takeFromMyStore
tt_display_figurines_mallbuyCurrent
tt_display_figurines_mallbuyCurrentMaxPrice
tt_display_figurines_mallbuyObsolete
tt_display_figurines_mallbuyObsoleteMaxPrice
[/code]

### tt_display hobopolis

Mostly incomplete script. At the moment it can zap (default 1 zap a day) hobopolis gear for you.

### tt_display crimbo2019

Old script to display crimbo 2019 items and count them. making sure you have all of them
