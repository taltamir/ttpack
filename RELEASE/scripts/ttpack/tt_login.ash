//This script should be set to auto run on login

void closetPutAll(item it)
{
int qty = item_amount(it);
if (qty > 0)
	{
	print("putting in closet " + qty + " " + it);
	put_closet(qty, it);
	}
}

void closetTakeAll(item it)
{
int qty = closet_amount(it);
if (qty > 0)
	{
	print("taking from closet " + qty + " " + it);
	take_closet(qty, it);
	}
}

boolean isRich()
{
	if(my_meat() > 1000000) return true;
	else return false;
}

void pvpEnable()
{
if(!hippy_stone_broken())
	{
	visit_url("peevpee.php?action=smashstone&pwd&confirm=on&shatter=Smash+that+Hippy+Crap%21"); 	//break hippy stone
	visit_url("peevpee.php?action=pledge&place=fight&pwd"); 										//pledge allegiance
	}
}

void boombox()
{
//check if boombox is set to off. also mafia errors out if you try to switch to already selected song so don't do that.
if((get_property("boomBoxSong") != "Food Vibrations") && (my_path() != "Bees Hate You") && (get_property("_boomBoxSongsLeft") > "0") && item_amount($item[SongBoom&trade; BoomBox]) > 0)
	cli_execute("boombox 2");			//set boombox to food.
}

void fortuneReply()
{
//replies to all zatara fortune teller requests with whatever you configured as mafia's default

buffer page = visit_url("clan_viplounge.php?preaction=lovetester");

string [int][int] request_array = page.group_string("(clan_viplounge.php\\?preaction=testlove&testlove=\\d*)\">(.*?)</a>");

foreach i in request_array {
	string response_url = request_array[i][1].replace_string("preaction\=testlove","preaction\=dotestlove") + "&pwd&option=1&q1=" + get_property("clanFortuneReply1") + "&q2=" + get_property("clanFortuneReply2") + "&q3=" + get_property("clanFortuneReply3");
	visit_url(response_url);
	print("Response sent to " + request_array[i][2] + ".", "green");
}
}

void boxingDaycare()
{
// check to make sure you actually have a daycare
if(get_property("daycareOpen") == "false")
{
	return;
}

//checks to see if you scavenged exactly 0 times today. Meaning the scavenging is free. If so, then perform 1 scavenge operation.
if (get_property("_daycareGymScavenges").to_int() == 0) 
	{
	visit_url("place.php?whichplace=town_wrong&action=townwrong_boxingdaycare"); run_choice(3); run_choice(2);
	}
}

void KGB()
{
cli_execute("briefcase unlock");		//unlock the briefcase using ezandora script (must be installed seperately)
cli_execute("briefcase collect");		//collect 3x epic drinks using ezandora script (must be installed seperately)
cli_execute("briefcase collect");		//need to be run twice on first day. harmless on future days
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
		run_choice(3);		//if quest already started & mafia failed to recognize it, this avoid being stuck here
	}
	
//start the mysticality guild acceptance quest.
if((get_property("questG07Myst") == "unstarted") && ((my_class() == $class[Sauceror]) || (my_class() == $class[Pastamancer])))
	{
		visit_url("guild.php?place=challenge");
	}

//start the moxie guild acceptance quest.
if((get_property("questG08Moxie") == "unstarted") && ((my_class() == $class[Disco Bandit]) || (my_class() == $class[Accordion Thief])))
	{
		visit_url("guild.php?place=challenge");
	}

//start the muscle guild acceptance quest.
if((get_property("questG09Muscle") == "unstarted") && ((my_class() == $class[Turtle Tamer]) || (my_class() == $class[Seal Clubber])))
	{
		visit_url("guild.php?place=challenge");
	}
}

void setSnojo()
{
//set snowjo to match your class
visit_url("place.php?whichplace=snojo&action=snojo_controller");
if((my_class() == $class[Turtle Tamer]) || (my_class() == $class[Seal Clubber]))
	run_choice(1);
if((my_class() == $class[Sauceror]) || (my_class() == $class[Pastamancer]))
	run_choice(2);
if((my_class() == $class[Disco Bandit]) || (my_class() == $class[Accordion Thief]))
	run_choice(3);
}

void mom()
{
//use milk of magnesium as appropriate
//if mall is unrestricted and none consumed, consume 1. Let mafia handle acquisition.
if(can_interact() && get_property("_milkOfMagnesiumUsed") == "false" && my_fullness() < fullness_limit())
	{
	use(1, $item[milk of magnesium]);
	}

//if still not consumed and one is in inventory, consume it
if(get_property("_milkOfMagnesiumUsed") == "false" && item_amount($item[milk of magnesium]) > 0 && my_fullness() < fullness_limit())
	{
	use(1, $item[milk of magnesium]);
	}
}

void glitchmon()
{
//automatically fight glitch monster

if (get_property("_glitchMonsterFights") == "0")
	{
	visit_url("inv_eat.php?&pwd&which=3&whichitem=10207"); 		//start fight with %monster%
	string discard = run_combat();								//finish combat using ccs, don't print the battle to gCLI
	}

//variable _glitchMonsterFights counts how many glitch monsters you fought today. can you fight more than 1?
}

void requestSandwich()
{
//cast request sandwich until you get one
if (have_skill($skill[Request Sandwich]))
	{
	while (get_property("_requestSandwichSucceeded") == "false" &&  my_mp() > 5)
		{
		use_skill(1,$skill[Request Sandwich]);
		}
	}
}

void carboLoad()
{
//cast canticle of carboloading if available and not cast yet today.
if(have_skill($skill[Canticle of Carboloading]) && get_property("_carboLoaded") == "false")
	{
	use_skill(1,$skill[Canticle of Carboloading]);
	}
}

void bittycar()
{
if((get_property("_bittycar") != "meatcar") && (item_amount($item[BittyCar MeatCar]) > 0))
	{
	use(1, $item[BittyCar MeatCar]);
	}
}

void raindoh()
{
closetTakeAll($item[Can of Rain-Doh]);		//I don't know how but it somehow ends up in the closet. This takes all of it out of closet.

if((item_amount($item[Can of Rain-Doh]) > 0) && (item_amount($item[Empty Rain-Doh can]) < 1))
	{
	use(1, $item[Can of Rain-Doh]);
	}
}

void guildManual()
{
if((get_property("_guildManualUsed") == "false") && (item_amount($item[Manual of Transmission]) > 0))
	{
	use(1, $item[Manual of Transmission]);
	}
	
if((get_property("_guildManualUsed") == "false") && (item_amount($item[Manual of Dexterity]) > 0))
	{
	use(1, $item[Manual of Dexterity]);
	}
	
if((get_property("_guildManualUsed") == "false") && (item_amount($item[Manual of Labor]) > 0))
	{
	use(1, $item[Manual of Labor]);
	}
}

void discoKnife()
{
//cast the disco knife skill if available and not cast yet today. closet competing knives (otherwise it just wastes MP for no results)
if(have_skill($skill[That's Not a Knife]) && get_property("_discoKnife") == "false")
	{
	closetPutAll($item[boot knife]);
	closetPutAll($item[broken beer bottle]);
	closetPutAll($item[sharpened spoon]);
	closetPutAll($item[candy knife]);
	closetPutAll($item[soap knife]);
	use_skill(1,$skill[That's Not a Knife]);
	}
}

void spaceGate()
{
// check to make sure you actually have a spacegate & can access it
if(get_property("spacegateAlways") == "false" || my_path() == "Kingdom of Exploathing")
{
	return;
}

//alien gemstone keeps on ending in the closet. take it out so it can be redeemed for research
closetTakeAll($item[alien gemstone]);

//visit spacegate R&D to turn in your research items.
visit_url("place.php?whichplace=spacegate&action=sg_tech");

//acquire all the spacegate gear
cli_execute("acquire geological sample kit; acquire botanical sample kit; acquire zoological sample kit; acquire exo-servo leg braces; acquire filter helmet; acquire rad cloak; acquire high-friction boots; acquire gate transceiver; ");
}

void aftercore()
{
	//acquire a 4-d camera if you have not used one today yet.
	if(isRich() && get_property("_cameraUsed") == "false")
	{
		retrieve_item(1, $item[4-d camera]);
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

	//If you have not done so yet, buy your daily print screen button.
	if(get_property("_internetPrintScreenButtonBought") == "false")
	{
		buy($coinmaster[Internet Meme Shop],1,$item[print screen button]);
	}
		
	//Use 3 meteoride-ade (+5 pvp fights ea. at no organ space. max 3 per day. worth ~6k meat each in mall)
	if(isRich() && (get_property("_meteoriteAdesUsed") < 3))
	{
		//multiuse to minmize hits. 3 different ifs because get property always return a string so I can't do math on it.
		if(get_property("_meteoriteAdesUsed")==0)
			use(3, $item[Meteorite-Ade]);
		if(get_property("_meteoriteAdesUsed")==1)
			use(2, $item[Meteorite-Ade]);
		if(get_property("_meteoriteAdesUsed")==2)
			use(1, $item[Meteorite-Ade]);
	}

	//use up to 3 mojo filters. max 3 per day.
	//don't waste them if spleen is over max (ex: after ed run)
	if(isRich() && (get_property("currentMojoFilters") < 3) && my_spleen_use() <= spleen_limit())
	{
		//how many mojo filters we can still use today
		int qty = 3-get_property("currentMojoFilters").to_int();

		//is there anything to use them one?
		if(qty > my_spleen_use())
			qty = my_spleen_use();

		//multiuse mojo filters.
		use(qty, $item[mojo filter]);
	}

	//execute the OCD inventory script
	if(have_shop())
	{
		cli_execute("OCDInv.ash");
	}
}

void automate()
{
	if(my_path() != "Pocket Familiars") 	//some paths don't have familiars which will cause this script to error out
		cli_execute("familiar none");		//set familiar to none to avoid question by autoscend.
	if(item_amount($item[Beach Comb]) > 0)	//check that you actually have the beach comb
		cli_execute("combbeach free");		//run free beach combs for sea grapes
//	cli_execute("autoscend.ash");			//run autoscend
}

void main()
{
	pvpEnable();							//breaks the hippy stone to enable PVP fighting
	boombox();								//set boombox to food.
	fortuneReply();							//replies to all outstanding zatara fortune consultation requests with mafia default (configurable via mafia)
	cli_execute("tt_fortuneask.ash");			//calls on external script called fortuneask, to ask 3 daily fortunes from clanmates.
	boxingDaycare();						//perform one free scavenge in boxing daycare
	if (item_amount($item[Kremlin's Greatest Briefcase]) > 0)
		KGB();								//do stuff with kremlin greatest briefcase, assuming ezandora's KGB script is installed.
	bittycar();								//activate your bittycar meatcar if available.
	raindoh();								//unpack a can of rain-doh if available
	guildManual();							//use manual of transmission/dexterity/labor
	carboLoad();							//use daily carboloading if available.
	requestSandwich();						//repeatedly casts request sandwich until you get one.
	discoKnife();							//summon a disco bandit knife
	spaceGate();							//get spacegate equipment and turn in alien stuff
	if(can_interact())						//test if you have mall access, which means aftercore, after ronin, or casual.
		aftercore();						//if yes then do some daily aftercore stuff
	startQuests();							//start various quests
	setSnojo();								//set snojo to match your class.
	cli_execute("breakfast");				//run mafia's built in breakfast script (doesn't actually eat food. just performs daily tasks)
	mom();									//uses milk of magnesium as appropriate.
	glitchmon();							//fight glitch monster
	print();
	print("login script finished", "green");
//	if(!can_interact())						//if you don't have mall access (thus still in run)
//		{
//		print("detected in run = calling autoscend", "green");
//		print();
//		automate();							//fully automate a run
//		}
}