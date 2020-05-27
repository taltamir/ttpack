import <scripts/ttpack/util/tt_util.ash>

//public prototypes
void tt_chooseFamiliar();
boolean tt_iceHouse();
boolean tt_getFamiliarFromItem(item hatchling, familiar adult);
void tt_acquireFamiliars();
boolean tt_dailyDungeon();
boolean tt_fatLootToken();
boolean tt_meatFarm();

void tt_chooseFamiliar()
{
	tt_acquireFamiliars();	//get familiars.
	
	if(have_familiar($familiar[Lil\' Barrel Mimic]));
	{
		use_familiar($familiar[Lil\' Barrel Mimic]);
	}
}

boolean tt_iceHouse()
{
	//2020-05-17 refresh icehouse status. mafia often thinks it is empty when it is not. maybe because it is out of standard?
	//http://127.0.0.1:60083/museum.php?action=icehouse
	return false;
}

boolean tt_getFamiliarFromItem(item hatchling, familiar adult)
{
	//This functions converts an item named hatchling into a familiar named adult.
	
	//TODO return false if no terrarium installed in camp
	
	if(have_familiar(adult))
	{
		return true;
	}
	if(item_amount(hatchling) == 0)
	{
		return false;
	}
	
	print("Trying to acquire familiar [" + adult + "]", "blue");
	visit_url("inv_familiar.php?pwd=&which=3&whichitem=" + hatchling.to_int());
	
	if(have_familiar(adult))
	{
		print("Successfully acquired familiar [" + adult + "]", "blue");
		return true;
	}
	print("Failed to convert the familiar hatchling [" + hatchling + "] into the familiar [" + adult + "]", "red");
	return false;
}

void tt_acquireFamiliars()
{
	//TODO auto acquire terrarium

	//Very cheap IOTM derivative that is very useful. providing MP/HP regen, and your main source of early food.
	if(!have_familiar($familiar[Lil\' Barrel Mimic]))
	{
		tt_acquire($item[tiny barrel]);
	}
	tt_getFamiliarFromItem($item[tiny barrel], $familiar[Lil\' Barrel Mimic]);

	//Gelatinous Cubeling familiar costs 27 fat loot tokens and significantly improves doing daily dungeon in run.
	//we only want to buy it from vending machine. do not spend meat on it in mall
	if(!have_familiar($familiar[Gelatinous Cubeling]) && item_amount($item[dried gelatinous cube]) < 1 && item_amount($item[fat loot token]) > 26)
	{
		buy($coinmaster[Vending Machine], 1, $item[dried gelatinous cube]);
	}
	tt_getFamiliarFromItem($item[dried gelatinous cube], $familiar[Gelatinous Cubeling]);
	
	//If you don't already have leprechaun you are a new account so poor that it is worth spending ~2 full to save ~18k meat
	while(!have_familiar($familiar[Leprechaun]) && item_amount($item[leprechaun hatchling]) < 1 && fullness_left() > 0 && retrieve_item(1, $item[bowl of lucky charms]))
	{
		eat(1, $item[bowl of lucky charms]);
	}
	tt_getFamiliarFromItem($item[leprechaun hatchling], $familiar[Leprechaun]);
	
	//attack familiar that is very easy to get.
	if(!have_familiar($familiar[Ragamuffin Imp]) && !get_property("demonSummoned").to_boolean() && item_amount($item[pile of smoking rags]) < 1 && display_amount($item[pile of smoking rags]) < 1)
	{
		cli_execute("summon Tatter");
	}
	tt_getFamiliarFromItem($item[pile of smoking rags], $familiar[Ragamuffin Imp]);
	
	//easy attack familiar
	if(!have_familiar($familiar[Howling Balloon Monkey]))
	{
		retrieve_item(1, $item[balloon monkey]);
	}
	tt_getFamiliarFromItem($item[balloon monkey], $familiar[Howling Balloon Monkey]);
	
	//delevel enemy cheaply
	if(!have_familiar($familiar[barrrnacle]))
	{
		retrieve_item(1, $item[Barrrnacle]);
	}
	tt_getFamiliarFromItem($item[barrrnacle], $familiar[Barrrnacle]);
	
	//stat gains cheaply
	if(!have_familiar($familiar[Blood-Faced Volleyball]))
	{
		retrieve_item(1, $item[blood-faced volleyball]);
	}
	tt_getFamiliarFromItem($item[blood-faced volleyball], $familiar[Blood-Faced Volleyball]);
	
	//meat, MP/HP, confuse, or attack cheaply
	if(!have_familiar($familiar[Cocoabo]))
	{
		retrieve_item(1, $item[cocoa egg]);
	}
	tt_getFamiliarFromItem($item[cocoa egg], $familiar[Cocoabo]);
	
	//initiative and hot damage
	if(!have_familiar($familiar[Cute Meteor]))
	{
		retrieve_item(1, $item[cute meteoroid]);
	}
	tt_getFamiliarFromItem($item[cute meteoroid], $familiar[Cute Meteor]);
	
	//initiative for in standard runs
	if(!have_familiar($familiar[Oily Woim]))
	{
		tt_acquire($item[woim]);
	}
	tt_getFamiliarFromItem($item[woim], $familiar[Oily Woim]);
	
	//get an egg every ascension. if you didn't eat it then get the familiar.
	tt_getFamiliarFromItem($item[grue egg], $familiar[Grue]);
	
	//nemesis quest familiars
	tt_getFamiliarFromItem($item[adorable seal larva], $familiar[Adorable Seal Larva]);		//seal clubber
	tt_getFamiliarFromItem($item[untamable turtle], $familiar[Untamed Turtle]);				//turtle tamer
	tt_getFamiliarFromItem($item[macaroni duck], $familiar[Animated Macaroni Duck]);		//pastamancer
	tt_getFamiliarFromItem($item[friendly cheez blob], $familiar[Pet Cheezling]);			//sauceror
	tt_getFamiliarFromItem($item[unusual disco ball], $familiar[Autonomous Disco Ball]);	//disco bandit
	tt_getFamiliarFromItem($item[stray chihuahua], $familiar[Mariachi Chihuahua]);			//accordion thief
	
	//quest items that are familiar hatchlings
	tt_getFamiliarFromItem($item[reassembled blackbird], $familiar[Reassembled Blackbird]);	//every ascension
	tt_getFamiliarFromItem($item[mosquito larva], $familiar[Mosquito]);						//every ascension
	tt_getFamiliarFromItem($item[black kitten], $familiar[Black Cat]);						//bad moon
}

boolean tt_dailyDungeon()
{
	if(get_property("dailyDungeonDone").to_boolean())
	{
		return false;
	}
	
	//try to acquire the 3 important items for daily dungeon.
	if(!tt_acquire($item[eleven-foot pole]) || !tt_acquire($item[Pick-O-Matic lockpicks]) || !tt_acquire($item[ring of Detect Boring Doors]))
	{
		return false;		//if we failed to acquire all 3 we want to return false so we can go meatfarming instead.
	}
	
	set_property("choiceAdventure689",1);		//get fat loot token at room 15
	set_property("choiceAdventure690",2);		//using boring door to skip from 5th to 8th room
	set_property("choiceAdventure691",2);		//using boring door to skip from 10th to 13th room
	set_property("choiceAdventure692",11);		//use lockpicks
	set_property("choiceAdventure693",2);		//avoid trap with eleven-foot pole
	
	string maximizer_string = "-combat";
	if(get_property("_lastDailyDungeonRoom").to_int() == 4 || get_property("_lastDailyDungeonRoom").to_int() == 9)
	{
		maximizer_string += ",equip ring of Detect Boring Doors";
	}
	if(my_class() != $class[sauceror] && my_class() != $class[pastamancer])
	{
		maximizer_string += ",effective";
	}
	print("Maximizing: " + maximizer_string, "blue");
	maximize(maximizer_string, false);
	
	return adv1($location[The Daily Dungeon], -1, "");
}

boolean tt_fatLootToken()
{
	tt_acquireFamiliars();			//in case we can buy cubeling
	
	int tokens_needed = 72;
	if(have_familiar($familiar[Gelatinous Cubeling]))
	{
		tokens_needed -= 27;
	}
	if(have_skill($skill[Singer\'s Faithful Ocelot]) || item_amount($item[Spellbook: Singer\'s Faithful Ocelot]) > 0)
	{
		tokens_needed -= 15;
	}
	if(have_skill($skill[Drescher\'s Annoying Noise]) || item_amount($item[Spellbook: Drescher\'s Annoying Noise]) > 0)
	{
		tokens_needed -= 15;
	}
	if(have_skill($skill[Walberg\'s Dim Bulb]) || item_amount($item[Spellbook: Walberg\'s Dim Bulb]) > 0)
	{
		tokens_needed -= 15;
	}
	if(tokens_needed == 0)
	{
		return false;
	}
	
	if(tt_dailyDungeon()) return true;
	
	return false;
}

boolean tt_meatFarm()
{
	//castle in the sky NCs
	set_property("choiceAdventure675", 1);
	set_property("choiceAdventure676", 4);
	set_property("choiceAdventure677", 4);
	set_property("choiceAdventure678", 2);
	set_property("currentMood", "meat");

	string maximizer_string = "meat,effective";
	if(tt_acquire($item[mafia thumb ring]))
	{
		maximizer_string += ",+equip mafia thumb ring";
	}
	maximize(maximizer_string, false);

	return adv1($location[The Castle in the Clouds in the Sky (Top Floor)], -1, "");
}

boolean tt_doTasks()
{
	//main loop of tt_aftercore. returning true resets the loop. returning false exists the loop
	
	tt_chooseFamiliar();
	
	if(tt_iceHouse()) return true;
	if(tt_fatLootToken()) return true;
	if(tt_meatFarm()) return true;
	return false;
}

void main()
{
	if(!inAftercore())
	{
		abort("Detected that king has not been liberated. This script should only be run in aftercore");
	}
	
	try
	{
		backupSetting("dontStopForCounters", true);
		
		//main loop is doTasks which is run as part of the while.
		while(auto_unreservedAdvRemaining() && tt_doTasks());
	}
	finally
	{
		restoreAllSettings();
	}
}