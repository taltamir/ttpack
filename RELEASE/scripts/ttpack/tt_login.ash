//This script should be set to auto run on login

import <scripts/ttpack/util/tt_util.ash>

void pvpEnable()
{
	if(!get_property("tt_login_pvp").to_boolean())
	{
		return;
	}
	if(!hippy_stone_broken())
	{
		visit_url("peevpee.php?action=smashstone&pwd&confirm=on&shatter=Smash+that+Hippy+Crap%21"); 	//break hippy stone
		visit_url("peevpee.php?action=pledge&place=fight&pwd"); 										//pledge allegiance
	}
}

void boxingDaycare()
{
	if(get_property("daycareOpen") == "false")
	{
		return;		//do not have IOTM
	}

	//checks to see if you scavenged exactly 0 times today. Meaning the scavenging is free. If so, then perform 1 scavenge
	if(get_property("_daycareGymScavenges").to_int() == 0)
	{
		visit_url("place.php?whichplace=town_wrong&action=townwrong_boxingdaycare");
		run_choice(3);
		run_choice(2);
	}
	
	//checks to see if you recruited exactly 0 times today. Meaning it costs 100 meat. If so, then perform 1 recruit toddlers
	if(get_property("_daycareRecruits").to_int() == 0 && my_meat() > 10000)
	{
		visit_url("place.php?whichplace=town_wrong&action=townwrong_boxingdaycare");
		run_choice(3);
		run_choice(1);
	}
}

void KGB()
{
	if(item_amount($item[Kremlin's Greatest Briefcase]) == 0)
	{
		return;
	}
	
	if(!get_property("_kgbLeftDrawerUsed").to_boolean() || !get_property("_kgbRightDrawerUsed").to_boolean())
	{
		//ezandora script will do: unlockCrank(); unlockMartiniHose(); openLeftDrawer(); openRightDrawer(); unlockButtons();
		cli_execute("briefcase unlock");
	}
	if(get_property("_kgbDispenserUses").to_int() < 3)
	{
		cli_execute("briefcase epic");			//ezandora script collects 3x epic drinks
	}
}

void startQuests()
{
	//pretentious artist quest
	if(quest_unstarted("questM02Artist"))
	{
		visit_url("place.php?whichplace=town_wrong&action=townwrong_artist_noquest");
		visit_url("place.php?whichplace=town_wrong&action=townwrong_artist_noquest&getquest=1");
		visit_url("place.php?whichplace=town_wrong&action=townwrong_artist_quest");
	}
	
	//meatsmith quest
	if(quest_unstarted("questM23Meatsmith"))
	{
		visit_url("shop.php?whichshop=meatsmith");
		visit_url("shop.php?whichshop=meatsmith&action=talk");
		run_choice(1);
	}
	
	//doc galaktik quest
	if(quest_unstarted("questM24Doc"))
	{
		visit_url("shop.php?whichshop=doc");
		visit_url("shop.php?whichshop=doc&action=talk");
		run_choice(1);
	}	
	
	//armorer and legerer pie quest
	if(quest_unstarted("questM25Armorer"))
	{
		visit_url("shop.php?whichshop=armory&action=talk");
		run_choice(1);		//start the quest
		run_choice(3);		//avoid getting stuck here when mafia is wrong about the quest being unstarted
	}
	
	//guild unlock quest
	if(my_class() == $class[Sauceror] || my_class() == $class[Pastamancer])
	{
		if(quest_unstarted("questG07Myst"))
		{
			visit_url("guild.php?place=challenge");
		}
	}
	if(my_class() == $class[Disco Bandit] || my_class() == $class[Accordion Thief])
	{
		if(quest_unstarted("questG08Moxie"))
		{
			visit_url("guild.php?place=challenge");
		}
	}
	if(my_class() == $class[Turtle Tamer] || my_class() == $class[Seal Clubber])
	{
		if(quest_unstarted("questG09Muscle"))
		{
			visit_url("guild.php?place=challenge");
		}
	}
	
	//start sea quest
	if(quest_unstarted("questS01OldGuy"))
	{
		visit_url("place.php?whichplace=sea_oldman&action=oldman_oldman");
	}
	
	//start LT&T quest.
	//tracking issue https://kolmafia.us/showthread.php?25027-LTT-is-not-listed-in-the-IOTM-tracking-preference-page&p=157520#post157520
	visit_url("place.php?whichplace=town_right");		//workaround for telegraphOfficeAvailable not updating when you break standard
	if(get_property("tt_login_startQuestLTT").to_boolean() && get_property("telegraphOfficeAvailable").to_boolean() && quest_unstarted("questLTTQuestByWire") && !get_property("_tt_login_lttQuestStartedToday").to_boolean())
	{
		set_property("_tt_login_lttQuestStartedToday", true);		//temporary? workaround until mafia tracks ltt better.
		int target = get_property("tt_login_startQuestLTTDifficulty").to_int();
		visit_url("place.php?whichplace=town_right&action=townright_ltt");
		run_choice(target);
	}
}

void setSnojo()
{
	if(!get_property("snojoAvailable").to_boolean())
	{
		return;		//don't have snojo
	}
	
	string current_setting = get_property("snojoSetting");
	boolean mus_class = my_class() == $class[Turtle Tamer] || my_class() == $class[Seal Clubber];
	boolean mys_class = my_class() == $class[Sauceror] || my_class() == $class[Pastamancer];
	boolean mox_class = my_class() == $class[Disco Bandit] || my_class() == $class[Accordion Thief];
	
	//set snowjo to match your class
	if(mus_class && current_setting != "MUSCLE")
	{
		visit_url("place.php?whichplace=snojo&action=snojo_controller");
		run_choice(1);
	}
	if(mys_class && current_setting != "MYSTICALITY")
	{
		visit_url("place.php?whichplace=snojo&action=snojo_controller");
		run_choice(2);
	}
	if(mox_class && current_setting != "MOXIE")
	{
		visit_url("place.php?whichplace=snojo&action=snojo_controller");
		run_choice(3);
	}
}

void milkOfMagnesium()
{
	if(get_property("_milkOfMagnesiumUsed").to_boolean())
	{
		return;		//already used today
	}
	if(!can_eat())
	{
		return;
	}
	if(my_fullness() > fullness_limit())
	{
		return;		//if you exceed the fullness limit then you cannot benefit from milk today. consuming it will be a waste
	}
	
	if(can_interact() || creatable_amount($item[milk of magnesium]) > 0)
	{
		retrieve_item(1,$item[milk of magnesium]);
	}

	if(item_amount($item[milk of magnesium]) > 0)
	{
		use(1, $item[milk of magnesium]);
	}
}

void glitchmon()
{
	//automatically fight glitch monster
	// https://kol.coldfront.net/thekolwiki/index.php/Glitch_season_reward_name
	if(item_amount($item[\[glitch season reward name\]]) == 0)
	{
		return;		//do not have item
	}
	if(get_property("_glitchMonsterFights").to_int() > 0)
	{
		return;		//only 1 fight per day allowed
	}
	
	//_glitchMonsterFights counts how many glitch monsters you fought today. can only fight 1/day.
	visit_url("inv_eat.php?&pwd&which=3&whichitem=10207"); 		//start fight with %monster%
	run_combat();												//finish combat using ccs
}

void requestSandwich()
{
	if(!auto_have_skill($skill[Request Sandwich]))
	{
		return;		//don't have the skill
	}
	
	//need a while loop because the skill has a high failure chance. failures do not count against your usage limit.
	while(!get_property("_requestSandwichSucceeded").to_boolean() &&  my_mp() > 5)
	{
		use_skill(1,$skill[Request Sandwich]);
	}
}

void carboLoad()
{
	if(!auto_have_skill($skill[Canticle of Carboloading]))
	{
		return;		//don't have the skill
	}
	if(get_property("_carboLoaded").to_boolean())
	{
		return;		//already cast today
	}
	use_skill(1,$skill[Canticle of Carboloading]);
}

void bittycar()
{
	if(get_property("_bittycar") != "meatcar" && item_amount($item[BittyCar MeatCar]) > 0)
	{
		use(1, $item[BittyCar MeatCar]);
	}
}

void raindoh()
{
	tt_closetTakeAll($item[Can of Rain-Doh]);		//I don't know how but it somehow ends up in the closet. This takes all of it out of closet.

	if(item_amount($item[Can of Rain-Doh]) > 0 && item_amount($item[Empty Rain-Doh can]) == 0)
	{
		use(1, $item[Can of Rain-Doh]);
	}
}

void guildManual()
{
	if(get_property("_guildManualUsed").to_boolean())
	{
		return;		//already used today
	}
	
	if(item_amount($item[Manual of Transmission]) > 0)
	{
		use(1, $item[Manual of Transmission]);
	}
	if(item_amount($item[Manual of Dexterity]) > 0)
	{
		use(1, $item[Manual of Dexterity]);
	}	
	if(item_amount($item[Manual of Labor]) > 0)
	{
		use(1, $item[Manual of Labor]);
	}
}

void discoKnife()
{
	if(!auto_have_skill($skill[That's Not a Knife]))
	{
		return;		//don't have the skill
	}
	if(get_property("_discoKnife").to_boolean())
	{
		return;		//already used today
	}

	//closet competing knives (otherwise it just wastes MP for no results)
	tt_closetPutAll($item[boot knife]);
	tt_closetPutAll($item[broken beer bottle]);
	tt_closetPutAll($item[sharpened spoon]);
	tt_closetPutAll($item[candy knife]);
	tt_closetPutAll($item[soap knife]);
	
	use_skill(1,$skill[That's Not a Knife]);
}

void spaceGate()
{
	if(!get_property("spacegateAlways").to_boolean())	//only check permanent ownership and not dayticket. latter does not allow acquiring gear
	{
		return;
	}
	if(!is_unrestricted($item[Spacegate access badge]))
	{
		return;
	}
	if(my_path() == "Kingdom of Exploathing")
	{
		return;
	}

	tt_closetTakeAll($item[alien gemstone]);		//uncloset them to turn in. pvprotect keeps closetting them
	visit_url("place.php?whichplace=spacegate&action=sg_tech");		//turn in your research items.

	//acquire all the spacegate gear
	foreach it in $items[geological sample kit, botanical sample kit, zoological sample kit, exo-servo leg braces, filter helmet, rad cloak, high-friction boots, gate transceiver]
	{
		retrieve_item(1,it);
	}
}

void postStuff()
{
	//do some stuff in casual, postronin, or aftercore
	if(!can_interact())		//are we not in any of: aftercore, after ronin, or casual
	{
		return;
	}
	
	//acquire a 4-d camera if you have not used one today yet.
	if(tt_isRich() && get_property("_cameraUsed") == "false")
	{
		retrieve_item(1, $item[4-d camera]);
	}
	
	//Use 3 meteoride-ade (+5 pvp fights ea. at no organ space. max 3 per day. worth ~6k meat each in mall)
	if(tt_isRich() && (get_property("_meteoriteAdesUsed").to_int() < 3))
	{
		int qty = 3 - get_property("_meteoriteAdesUsed").to_int();
		use(qty, $item[Meteorite-Ade]);
	}
	
	//use up to 3 mojo filters. max 3 per day.
	if(tt_isRich() && get_property("currentMojoFilters").to_int() < 3)
	{
		int qty = 3-get_property("currentMojoFilters").to_int();	//3 max uses per day
		qty = min(qty, my_spleen_use());							//reduces spleen use rather than expand spleen size. so don't overuse
		if(my_spleen_use() > spleen_limit())
		{
			qty = 0;			//if current spleen exceeds limit (ed aftercore) do not waste filters.
		}
		
		if(qty > 0)
		{
			use(qty, $item[mojo filter]);
		}
	}
	
	//If you have not done so yet, buy your daily print screen button. can be sold for good profit
	//if(get_property("_internetPrintScreenButtonBought") == "false" && item_amount($item[bacon]) >= 111)
	//{
	//	buy($coinmaster[Internet Meme Shop],1,$item[print screen button]);
	//}

	//execute the OCD inventory script
	if(have_shop())
	{
		cli_execute("OCDInv.ash");
	}
}

void aftercore()
{
	//do some stuff in aftercore only. We do not want to do these in postronin or casual.
	if(!inAftercore())
	{
		return;
	}
	
	//use daily pirate bellow
	if(have_skill($skill[Pirate Bellow]) && get_property("_pirateBellowUsed") == "false")
	{
		use_skill(1,$skill[Pirate Bellow]);
	}

	//use daily glenn's golden dice
	if(get_property("_glennGoldenDiceUsed") == "false" && (item_amount($item[Glenn's golden dice]) > 0))
	{
		use(1, $item[Glenn's golden dice]);
	}
}

void eatChocolate()
{
	//will automatically buy and eat chocolate based on price per adv gained.
	
	if(!can_interact())		//are we not in any of: aftercore, after ronin, or casual
	{
		return;
	}
	if(!get_property("tt_login_chocolateEat").to_boolean())
	{
		return;
	}
	if(in_gnoob())
	{
		return;	//gelatinous noob cannot use chocolate
	}
	
	int maxPricePerAdv = get_property("tt_login_chocolateMaxPricePerAdv").to_int();
	if(maxPricePerAdv > 20000)
	{
		print("For some reason your chocolate max price per adv is set above 20\,000 meat. This is madness... skipping", "red");
		return;
	}
	
	//eat class specific chocolate.
	int class_chocolate_consumed = get_property("_chocolatesUsed").to_int();
	if(class_chocolate_consumed < 3)
	{
		item chocolate_item;
		int qty_goal = 0;
		if(isGuildClass())
		{
			if(my_class() == $class[seal clubber])			chocolate_item = $item[chocolate seal-clubbing club];
			if(my_class() == $class[turtle tamer])			chocolate_item = $item[chocolate turtle totem];
			if(my_class() == $class[pastamancer])			chocolate_item = $item[chocolate pasta spoon];
			if(my_class() == $class[sauceror])				chocolate_item = $item[chocolate saucepan];
			if(my_class() == $class[disco bandit])			chocolate_item = $item[chocolate disco ball];
			if(my_class() == $class[accordion thief])		chocolate_item = $item[chocolate stolen accordion];
			
			int chocolate_value = mall_price(chocolate_item);
			if(maxPricePerAdv > (chocolate_value / 3))		qty_goal++;		//first chocolate gives 3 adv
			if(maxPricePerAdv > (chocolate_value / 2))		qty_goal++;		//second chocolate gives 2 adv
			if(maxPricePerAdv > chocolate_value)			qty_goal++;		//third chocolate gives 1 adv
		}
		else	//non guild classes should find the cheapest of the 6 chocolates
		{
			chocolate_item = $item[chocolate seal-clubbing club];
			int chocolate_value = mall_price(chocolate_item);
			foreach it in $items[chocolate turtle totem, chocolate pasta spoon, chocolate saucepan, chocolate disco ball, chocolate stolen accordion]
			{
				if(mall_price(it) < mall_price(chocolate_item))
				{
					chocolate_item = it;
					chocolate_value = mall_price(it);
				}
			}
			
			if(maxPricePerAdv > (chocolate_value / 2))		qty_goal++;		//first chocolate gives 2 adv
			if(maxPricePerAdv > chocolate_value)			qty_goal++;		//second chocolate gives 1 adv
		}
		
		int will_eat = qty_goal - class_chocolate_consumed;
		if(will_eat > 0)
		{
			use(will_eat, chocolate_item);
		}
	}
	
	//eat [fancy chocolate sculpture].
	int sculpture_chocolate_consumed = get_property("_chocolateSculpturesUsed").to_int();
	if(sculpture_chocolate_consumed < 3)
	{
		item chocolate_item = $item[fancy chocolate sculpture];
		
		int chocolate_value = mall_price(chocolate_item);
		int qty_goal = 0;
		if(maxPricePerAdv > (chocolate_value / 5))		qty_goal++;		//first chocolate gives 5 adv
		if(maxPricePerAdv > (chocolate_value / 3))		qty_goal++;		//second chocolate gives 3 adv
		if(maxPricePerAdv > chocolate_value)			qty_goal++;		//third chocolate gives 1 adv
		
		int will_eat = qty_goal - sculpture_chocolate_consumed;
		if(will_eat > 0)
		{
			use(will_eat, chocolate_item);
		}
	}
	
	//eat [LOV Extraterrestrial Chocolate].
	int love_chocolate_consumed = get_property("_loveChocolatesUsed").to_int();
	if(love_chocolate_consumed < 3)
	{
		item chocolate_item = $item[LOV Extraterrestrial Chocolate];
		
		int chocolate_value = 20000;									//traded via sellbot.
		int qty_goal = 0;
		if(maxPricePerAdv > (chocolate_value / 3))		qty_goal++;		//first chocolate gives 3 adv
		if(maxPricePerAdv > (chocolate_value / 2))		qty_goal++;		//second chocolate gives 2 adv
		if(maxPricePerAdv > chocolate_value)			qty_goal++;		//third chocolate gives 1 adv
		
		int will_eat = qty_goal - love_chocolate_consumed;
		if(will_eat > 0)
		{
			use(will_eat, chocolate_item);
		}
	}
}

void fullAuto()
{
	if(!get_property("tt_login_auto").to_boolean())
	{
		return;
	}
	if(my_path() == "Grey Goo")
	{
		cli_execute("greygoo.ash");
	}
	else
	{
		cli_execute("autoscend.ash");
	}
}

void main()
{
	tt_initialize();						//initialize settings if needed
	pvpEnable();							//breaks the hippy stone to enable PVP fighting
	songboomSetting(2);						//set boombox to food if available.
	cli_execute("tt_fortune.ash");			//reply and send zatara fortune teller requests
	boxingDaycare();						//perform free scavenge and 100 meat worth of recruit toddlers
	KGB();									//daily collections from kremlin greatest briefcase
	bittycar();								//activate your bittycar meatcar if available.
	raindoh();								//unpack a can of rain-doh if available
	guildManual();							//use manual of transmission/dexterity/labor
	carboLoad();							//use daily carboloading if available.
	requestSandwich();						//repeatedly casts request sandwich until you get one.
	discoKnife();							//summon a disco bandit knife
	spaceGate();							//get spacegate equipment and turn in alien stuff
	postStuff();							//do various things in aftercore/postronin/casual
	aftercore();							//do aftercore only thing. we do not want this in casual/postronin
	startQuests();							//start quests (no adv spent)
	L9_leafletQuest();						//do the level 9 leaflet quest if needed.
	setSnojo();								//set snojo control panel to match your class.
	cli_execute("breakfast");				//run mafia's built in "breakfast" script. doesn't eat food, just performs tasks
	milkOfMagnesium();						//uses milk of magnesium as appropriate.
	glitchmon();							//fight glitch monster
	auto_beachUseFreeCombs();				//use free beach combs
	eatChocolate();							//size 0 special consumables.

	print("login script finished", "green");
	
	fullAuto();								//if configured to. run autoscend or another appropriate script to fully automate a run.
}