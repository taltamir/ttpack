//This script should be set to auto run on login

import <ttpack/tt_util.ash>

void tt_login_settings_defaults()
{
	//set defaults
	if(get_property("tt_login_pvp") == "")
	{
		set_property("tt_login_pvp", true);
	}
}

void tt_login_settings_print()
{
	//print current settings status
	print();
	print("Current settings for tt_login:", "blue");
	print("tt_login_pvp = " + get_property("tt_login_pvp"), "blue");
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
	print();
}

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

void fortuneReply()
{
	//replies to all zatara fortune teller requests with whatever you configured as mafia's default

	buffer page = visit_url("clan_viplounge.php?preaction=lovetester");
	string [int][int] request_array = page.group_string("(clan_viplounge.php\\?preaction=testlove&testlove=\\d*)\">(.*?)</a>");

	foreach i in request_array
	{
		string response_url = request_array[i][1].replace_string("preaction\=testlove","preaction\=dotestlove") + "&pwd&option=1&q1=" + get_property("clanFortuneReply1") + "&q2=" + get_property("clanFortuneReply2") + "&q3=" + get_property("clanFortuneReply3");
		
		visit_url(response_url);
		print("Response sent to " + request_array[i][2] + ".", "green");
	}
}

void boxingDaycare()
{
	if(get_property("daycareOpen") == "false")
	{
		return;		//do not have IOTM
	}

	//checks to see if you scavenged exactly 0 times today. Meaning the scavenging is free. If so, then perform 1 scavenge
	if (get_property("_daycareGymScavenges").to_int() == 0)
	{
		visit_url("place.php?whichplace=town_wrong&action=townwrong_boxingdaycare");
		run_choice(3);
		run_choice(2);
	}
	
	//checks to see if you recruited exactly 0 times today. Meaning it costs 100 meat. If so, then perform 1 recruit toddlers
	if (get_property("_daycareRecruits").to_int() == 0 && my_meat() > 10000)
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
	//start pretentious artist quest
	if(get_property("questM02Artist") == "unstarted")
	{
		visit_url("place.php?whichplace=town_wrong&action=townwrong_artist_noquest");
		visit_url("place.php?whichplace=town_wrong&action=townwrong_artist_noquest&getquest=1");
		visit_url("place.php?whichplace=town_wrong&action=townwrong_artist_quest");
	}
	
	// start meatsmith quest if unstarted.
	if(get_property("questM23Meatsmith") == "unstarted")
	{
		visit_url("shop.php?whichshop=meatsmith");
		visit_url("shop.php?whichshop=meatsmith&action=talk");
		run_choice(1);
	}
	
	// start doc galactic quest if unstarted.
	if(get_property("questM24Doc") == "unstarted")
	{
		visit_url("shop.php?whichshop=doc");
		visit_url("shop.php?whichshop=doc&action=talk");
		run_choice(1);
	}	
	
	// start armorer and legerer pie quest if unstarted.
	if(get_property("questM25Armorer") == "unstarted")
	{
		visit_url("shop.php?whichshop=armory&action=talk");
		run_choice(1);		//start the quest
		run_choice(3);		//avoid getting stuck here when mafia is wrong about the quest being unstarted
	}
	
	//start the guild acceptance quest.
	if(my_class() == $class[Sauceror] || my_class() == $class[Pastamancer])
	{
		if(get_property("questG07Myst") == "unstarted")
		{
			visit_url("guild.php?place=challenge");
		}
	}
	if(my_class() == $class[Disco Bandit] || my_class() == $class[Accordion Thief])
	{
		if(get_property("questG08Moxie") == "unstarted")
		{
			visit_url("guild.php?place=challenge");
		}
	}
	if(my_class() == $class[Turtle Tamer] || my_class() == $class[Seal Clubber])
	{
		if(get_property("questG09Muscle") == "unstarted")
		{
			visit_url("guild.php?place=challenge");
		}
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
	
	//variable _glitchMonsterFights counts how many glitch monsters you fought today. can you fight more than 1?
	if (get_property("_glitchMonsterFights").to_int() == 0)
	{
		visit_url("inv_eat.php?&pwd&which=3&whichitem=10207"); 		//start fight with %monster%
		run_combat();												//finish combat using ccs
	}
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
	if(get_property("spacegateAlways") == "false")
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
	if(!can_interact())		//test if you have unrestricted mall access. which means aftercore, after ronin, or casual.
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
	if(get_property("_internetPrintScreenButtonBought") == "false")
	{
		buy($coinmaster[Internet Meme Shop],1,$item[print screen button]);
	}

	//execute the OCD inventory script
	if(have_shop())
	{
		cli_execute("OCDInv.ash");
	}
}

void aftercore()
{
	//do some stuff in aftercore only. We do not want to do these in postronin or casual.
	if(!in_aftercore())
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

void main()
{
	tt_login_settings_defaults();			//set default settings if needed.
	pvpEnable();							//breaks the hippy stone to enable PVP fighting
	songboomSetting(2);						//set boombox to food if available.
	fortuneReply();							//replies to all zatara fortune requests with mafia configured responses
	cli_execute("tt_fortuneask.ash");		//calls on external script called fortuneask, to ask 3 daily fortunes from clanmates.
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
	setSnojo();								//set snojo control panel to match your class.
	cli_execute("breakfast");				//run mafia's built in "breakfast" script. doesn't eat food, just performs tasks
	milkOfMagnesium();						//uses milk of magnesium as appropriate.
	glitchmon();							//fight glitch monster
	auto_beachUseFreeCombs();				//use free beach combs
	
	tt_login_settings_print();				//print current settings.
	print("login script finished", "green");
}