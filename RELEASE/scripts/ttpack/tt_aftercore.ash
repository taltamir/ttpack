import <scripts/ttpack/util/tt_util.ash>

//public prototypes
void tt_settings_print();
void tt_chooseFamiliar();
boolean tt_iceHouseAMC();
boolean tt_convert_hatchling_into_familiar(item hatchling, familiar adult);
void tt_acquireFamiliars();
boolean tt_dailyDungeon();
boolean tt_fatLootToken();
boolean tt_meatFarm();
void tt_help();

void tt_settings_defaults()
{
	boolean new_setting_added = false;
	
	//set defaults
	if(get_property("tt_aftercore_fatLootToken") == "")
	{
		new_setting_added = true;
		set_property("tt_aftercore_fatLootToken", true);
	}
	if(get_property("tt_aftercore_iceHouseAMC") == "")
	{
		new_setting_added = true;
		set_property("tt_aftercore_iceHouseAMC", true);
	}
	if(get_property("tt_aftercore_guildUnlock") == "")
	{
		new_setting_added = true;
		set_property("tt_aftercore_guildUnlock", false);
	}
	if(get_property("tt_aftercore_meatFarm") == "")
	{
		new_setting_added = true;
		set_property("tt_aftercore_meatFarm", false);
	}
	if(get_property("tt_aftercore_useAstralLeftovers") == "")
	{
		new_setting_added = true;
		set_property("tt_aftercore_useAstralLeftovers", true);
	}
	if(get_property("tt_aftercore_buyStuff") == "")
	{
		new_setting_added = true;
		set_property("tt_aftercore_buyStuff", true);
	}
	if(get_property("tt_aftercore_eatSurpriseEggs") == "")
	{
		new_setting_added = true;
		set_property("tt_aftercore_eatSurpriseEggs", false);
	}
	
	if(new_setting_added)
	{
		tt_help();
		tt_settings_print();
		abort("Settings have been configured to default. Please verify they are correct before running me again");
	}
}

void tt_settings_print()
{
	//print current settings status
	print();
	print("Current settings for tt_aftercore:", "blue");
	tt_printSetting("tt_aftercore_fatLootToken", "Farm fat loot tokens if you still need more to buy the skills and familiars");
	tt_printSetting("tt_aftercore_iceHouseAMC", "Automatically capture AMC gremlin in the ice house");
	tt_printSetting("tt_aftercore_guildUnlock", "Unlock your guild");
	tt_printSetting("tt_aftercore_meatFarm", "Farm some meat. Currently terrible at it.");
	tt_printSetting("tt_aftercore_useAstralLeftovers", "Use leftover astral drink/food");
	tt_printSetting("tt_aftercore_buyStuff", "Allow buying some useful things");
	tt_printSetting("tt_aftercore_eatSurpriseEggs", "Automatically fill stomach with [lucky surprise egg] and [spooky surprise egg]");
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
	print();
}

void tt_chooseFamiliar()
{
	tt_acquireFamiliars();	//get familiars.
	
	if(have_familiar($familiar[Lil\' Barrel Mimic]));
	{
		use_familiar($familiar[Lil\' Barrel Mimic]);
	}
}

void tt_useAstralLeftovers()
{
	if(!get_property("tt_aftercore_useAstralLeftovers").to_boolean())
	{
		return;
	}
	
	int drink_amt = min(inebriety_left(),item_amount($item[astral pilsner]));
	if(drink_amt > 0)
	{
		autoDrink(drink_amt, $item[astral pilsner]);
	}
	
	int food_amt = min(fullness_left(),item_amount($item[astral hot dog]));
	if(food_amt > 0)
	{
		autoEat(food_amt, $item[astral hot dog]);
	}
}

void tt_eatSurpriseEggs()
{
	if(!get_property("tt_aftercore_eatSurpriseEggs").to_boolean())
	{
		return;
	}
	
	int food_amt = fullness_left();
	int spooky_amt = 0;
	int lucky_amt = 0;
	while(food_amt > 0)
	{
		if(lucky_amt < spooky_amt)
		{
			lucky_amt++;
			food_amt--;
		}
		else
		{
			spooky_amt++;
			food_amt--;
		}
	}
	
	if(lucky_amt > 0)
	{
		retrieve_item(lucky_amt, $item[lucky surprise egg]);
		retrieve_item(lucky_amt, $item[lucky surprise egg]);		//sometimes you need to give the command twice for it to work
		lucky_amt = min(item_amount($item[lucky surprise egg]), lucky_amt);
		eat(lucky_amt, $item[lucky surprise egg]);
	}
	if(spooky_amt > 0)
	{
		retrieve_item(spooky_amt, $item[spooky surprise egg]);
		retrieve_item(spooky_amt, $item[spooky surprise egg]);		//sometimes you need to give the command twice for it to work
		spooky_amt = min(item_amount($item[spooky surprise egg]), spooky_amt);
		eat(spooky_amt, $item[spooky surprise egg]);
	}
}

void tt_buyStuff()
{
	if(!get_property("tt_aftercore_buyStuff").to_boolean())
	{
		return;
	}
	
	tt_acquire($item[mafia pinky ring]);
}

boolean tt_iceHouseAMC()
{
	if(!get_property("tt_aftercore_iceHouseAMC").to_boolean())
	{
		return false;
	}
	
	//2020-05-17 refresh icehouse status. mafia often thinks it is empty when it is not. maybe because it is out of standard?
	//http://127.0.0.1:60083/museum.php?action=icehouse
	return false;
}

boolean tt_convert_hatchling_into_familiar(item hatchling, familiar adult)
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
	tt_convert_hatchling_into_familiar($item[tiny barrel], $familiar[Lil\' Barrel Mimic]);

	//Gelatinous Cubeling familiar costs 27 fat loot tokens and significantly improves doing daily dungeon in run.
	//we only want to buy it from vending machine. do not spend meat on it in mall
	if(!have_familiar($familiar[Gelatinous Cubeling]) && item_amount($item[dried gelatinous cube]) < 1 && item_amount($item[fat loot token]) > 26)
	{
		buy($coinmaster[Vending Machine], 1, $item[dried gelatinous cube]);
	}
	tt_convert_hatchling_into_familiar($item[dried gelatinous cube], $familiar[Gelatinous Cubeling]);
	
	//Levitating Potato blocks enemy attacks and is very cheap.
	//no point in mallbuying it despite the low price. since early on you are limited in meat availability.
	if(!have_familiar($familiar[Levitating Potato]) && item_amount($item[potato sprout]) < 1 && item_amount($item[fat loot token]) > 0)
	{
		buy($coinmaster[Vending Machine], 1, $item[potato sprout]);
	}
	tt_convert_hatchling_into_familiar($item[potato sprout], $familiar[Levitating Potato]);
	
	//If you don't already have leprechaun you are a new account so poor that it is worth spending ~2 full to save ~18k meat
	while(!have_familiar($familiar[Leprechaun]) && item_amount($item[leprechaun hatchling]) < 1 && fullness_left() > 0 && retrieve_item(1, $item[bowl of lucky charms]))
	{
		eat(1, $item[bowl of lucky charms]);
	}
	tt_convert_hatchling_into_familiar($item[leprechaun hatchling], $familiar[Leprechaun]);
	
	//attack familiar that is very easy to get.
	if(!have_familiar($familiar[Ragamuffin Imp]) && !get_property("demonSummoned").to_boolean() && item_amount($item[pile of smoking rags]) < 1 && display_amount($item[pile of smoking rags]) < 1)
	{
		cli_execute("summon Tatter");
	}
	tt_convert_hatchling_into_familiar($item[pile of smoking rags], $familiar[Ragamuffin Imp]);
	
	//easy attack familiar
	if(!have_familiar($familiar[Howling Balloon Monkey]))
	{
		retrieve_item(1, $item[balloon monkey]);
	}
	tt_convert_hatchling_into_familiar($item[balloon monkey], $familiar[Howling Balloon Monkey]);
	
	//delevel enemy cheaply
	if(!have_familiar($familiar[barrrnacle]))
	{
		retrieve_item(1, $item[Barrrnacle]);
	}
	tt_convert_hatchling_into_familiar($item[barrrnacle], $familiar[Barrrnacle]);
	
	//stat gains cheaply
	if(!have_familiar($familiar[Blood-Faced Volleyball]))
	{
		retrieve_item(1, $item[blood-faced volleyball]);
	}
	tt_convert_hatchling_into_familiar($item[blood-faced volleyball], $familiar[Blood-Faced Volleyball]);
	
	//meat, MP/HP, confuse, or attack cheaply
	if(!have_familiar($familiar[Cocoabo]))
	{
		retrieve_item(1, $item[cocoa egg]);
	}
	tt_convert_hatchling_into_familiar($item[cocoa egg], $familiar[Cocoabo]);
	
	//initiative and hot damage
	if(!have_familiar($familiar[Cute Meteor]))
	{
		retrieve_item(1, $item[cute meteoroid]);
	}
	tt_convert_hatchling_into_familiar($item[cute meteoroid], $familiar[Cute Meteor]);
	
	//initiative for in standard runs
	if(!have_familiar($familiar[Oily Woim]))
	{
		tt_acquire($item[woim]);
	}
	tt_convert_hatchling_into_familiar($item[woim], $familiar[Oily Woim]);
	
	//get an egg every ascension. if you didn't eat it then get the familiar.
	tt_convert_hatchling_into_familiar($item[grue egg], $familiar[Grue]);
	
	//nemesis quest familiars
	tt_convert_hatchling_into_familiar($item[adorable seal larva], $familiar[Adorable Seal Larva]);		//seal clubber
	tt_convert_hatchling_into_familiar($item[untamable turtle], $familiar[Untamed Turtle]);				//turtle tamer
	tt_convert_hatchling_into_familiar($item[macaroni duck], $familiar[Animated Macaroni Duck]);		//pastamancer
	tt_convert_hatchling_into_familiar($item[friendly cheez blob], $familiar[Pet Cheezling]);			//sauceror
	tt_convert_hatchling_into_familiar($item[unusual disco ball], $familiar[Autonomous Disco Ball]);	//disco bandit
	tt_convert_hatchling_into_familiar($item[stray chihuahua], $familiar[Mariachi Chihuahua]);			//accordion thief
	
	//quest items that are familiar hatchlings
	tt_convert_hatchling_into_familiar($item[reassembled blackbird], $familiar[Reassembled Blackbird]);	//every ascension
	tt_convert_hatchling_into_familiar($item[mosquito larva], $familiar[Mosquito]);						//every ascension
	tt_convert_hatchling_into_familiar($item[black kitten], $familiar[Black Cat]);						//bad moon
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
	if(!get_property("tt_aftercore_fatLootToken").to_boolean())
	{
		return false;
	}

	tt_acquireFamiliars();			//in case we can buy cubeling
	
	int tokens_needed = 73;
	if(have_familiar($familiar[Gelatinous Cubeling]))
	{
		tokens_needed -= 27;
	}
	if(have_familiar($familiar[Levitating Potato]))
	{
		tokens_needed -= 1;
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
	if(tokens_needed >= item_amount($item[Fat Loot Token]))
	{
		return false;
	}
	
	if(tt_dailyDungeon()) return true;
	
	return false;
}

boolean tt_guild()
{
	if(!get_property("tt_aftercore_guildUnlock").to_boolean())
	{
		return false;
	}
	
	return LX_guildUnlock();	//autoscend function
}

boolean tt_meatFarm()
{
	if(!get_property("tt_aftercore_meatFarm").to_boolean())
	{
		return false;
	}

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
	//main loop of tt_aftercore. returning true resets the loop. returning false exits the loop
	
	if(!auto_unreservedAdvRemaining())
	{
		print("Not enough reserved adventures. Done for today", "red");
		return false;
	}
	
	tt_chooseFamiliar();
	
	if(tt_iceHouseAMC()) return true;
	if(tt_fatLootToken()) return true;
	if(tt_guild()) return true;
	if(tt_meatFarm()) return true;
	return false;
}

boolean tt_doSingleTask(string command)
{
	//this is a primary loop. returning true resets the loop. returning false exits the loop
	
	if(!auto_unreservedAdvRemaining())
	{
		print("Not enough reserved adventures. Done for today", "red");
		return false;
	}
	
	tt_chooseFamiliar();
	
	if(command == "amc")
	{
		return tt_iceHouseAMC();
	}
	if(command == "token")
	{
		if(get_property("dailyDungeonDone").to_boolean())
		{
			print("You already did daily dungeon today and it is currently the only supported source of tokens", "red");
			return false;
		}
		return tt_dailyDungeon();
		
		//TODO add other sources of token
	}
	if(command == "guild")
	{
		return tt_guild();
	}
	if(command == "meat")
	{
		return tt_meatFarm();
	}
	
	return false;
}

void tt_help()
{
	print("Welcome to tt_aftercore");
	print("To use type in gCLI:");
	print("tt_aftercore [goal]");
	print("Currently supported options for [goal]:");
	print("help = display available commands");
	print("config = display configuration");
	print("auto = automatically does all the things based on your configuration");
	print("guild = unlock your guild");
	print("token = gets a single fat loot token if possible");
	print("amc = traps an AMC gremlin in the ice house. currently unimplemented");
	print("meat = meatfarms. currently terrible at it");
}

void main(string command)
{	
	if(!inAftercore())
	{
		abort("Detected that king has not been liberated. This script should only be run in aftercore");
	}
	command = to_lower_case(command);
	
	tt_settings_defaults();
	
	tt_useAstralLeftovers();
	tt_eatSurpriseEggs();
	
	if(command == "help" || command == "" || command == "0");
	{
		tt_help();
	}
	if(command == "config")
	{
		tt_settings_print();
	}
	if(command == "auto")
	{
		try
		{
			backupSetting("dontStopForCounters", true);
			while(tt_doTasks());
		}
		finally
		{
			restoreAllSettings();
			tt_settings_print();
		}
	}
	if($strings[guild, token, amc, meat] contains command)
	{
		try
		{
			backupSetting("dontStopForCounters", true);
			while(tt_doSingleTask(command));
		}
		finally
		{
			restoreAllSettings();
			tt_settings_print();
		}
	}
}