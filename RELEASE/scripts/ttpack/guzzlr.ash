//do guzzlr quests

import <scripts/ttpack/util/tt_util.ash>

//public prototype start
void guzzlr_settings_print();

//public prototype end

item GUZZLRBUCK = $item[Guzzlrbuck];
item GUZZLR_TABLET = $item[Guzzlr tablet];
item GUZZLR_COCKTAIL_SET = $item[Guzzlr cocktail set];
item GUZZLR_SHOES = $item[Guzzlr shoes];
item GUZZLR_PANTS = $item[Guzzlr pants];
item GUZZLR_HAT = $item[Guzzlr hat];
boolean [item] GUZZLR_COCKTAILS = $items[Steamboat, Ghiaccio Colada, Nog-on-the-Cob, Sourfinger, Buttery Boy];

void guzzlr_settings_defaults()
{
	boolean new_setting_added = false;
	
	//set defaults
	if(get_property("guzzlr_deliverBronze") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_deliverBronze", true);
	}
	if(get_property("guzzlr_maxMeatCostBronze") == "" || get_property("guzzlr_maxMeatCostBronze").to_int() < 1)
	{
		new_setting_added = true;
		set_property("guzzlr_maxMeatCostBronze", 5000);
	}
	if(get_property("guzzlr_deliverGold") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_deliverGold", true);
	}
	if(get_property("guzzlr_maxMeatCostGold") == "" || get_property("guzzlr_maxMeatCostGold").to_int() < 1)
	{
		new_setting_added = true;
		set_property("guzzlr_maxMeatCostGold", 10000);
	}
	if(get_property("guzzlr_deliverPlatinum") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_deliverPlatinum", true);
	}
	if(get_property("guzzlr_maxMeatCostPlatinum") == "" || get_property("guzzlr_maxMeatCostPlatinum").to_int() < 1)
	{
		new_setting_added = true;
		set_property("guzzlr_maxMeatCostPlatinum", 15000);
	}
	if(get_property("guzzlr_abandonTooExpensive") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_abandonTooExpensive", false);
	}
	if(get_property("guzzlr_deliverInrun") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_deliverInrun", false);
	}
	if(get_property("guzzlr_treatCasualAsAftercore") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_treatCasualAsAftercore", false);
	}
	if(get_property("guzzlr_treatPostroninAsAftercore") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_treatPostroninAsAftercore", true);
	}
	if(get_property("guzzlr_abandonPlatinumForcedAftercore") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_abandonPlatinumForcedAftercore", false);
	}
	if(get_property("guzzlr_abandonPlatinumForcedInrun") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_abandonPlatinumForcedInrun", false);
	}
	if(get_property("guzzlr_autoFamiliar") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_autoFamiliar", true);
	}
	if(get_property("guzzlr_manualFamiliar") == "")
	{
		new_setting_added = true;
		set_property("guzzlr_manualFamiliar", false);
	}
	
	if(new_setting_added)
	{
		guzzlr_settings_print();
		abort("Settings have been configured to default. Please verify they are correct before running me again");
	}
}

void guzzlr_settings_print()
{
	//print current settings status
	print();
	print("Current settings for guzzlr:", "blue");
	tt_printSetting("guzzlr_deliverBronze");
	tt_printSetting("guzzlr_maxMeatCostBronze");
	tt_printSetting("guzzlr_deliverGold");
	tt_printSetting("guzzlr_maxMeatCostGold");
	tt_printSetting("guzzlr_deliverPlatinum", "Platinum will not be taken if you already used your 1 per day abandon");
	tt_printSetting("guzzlr_maxMeatCostPlatinum", "The maximum allowed price for cold wad and if needed a dayticket or access items");
	tt_printSetting("guzzlr_abandonTooExpensive", "When true will automatically abandon deliveries that are too expensive. When false will abort instead");
	tt_printSetting("guzzlr_deliverInrun", "Set to false to disable doing deliveries during a run");
	tt_printSetting("guzzlr_treatCasualAsAftercore");
	tt_printSetting("guzzlr_treatPostroninAsAftercore");
	tt_printSetting("guzzlr_abandonPlatinumForcedAftercore", "Override all other settings for the purpose of starting the day by taking a platinum delivery and immediately aborting it");
	tt_printSetting("guzzlr_abandonPlatinumForcedInrun", "Override all other settings for the purpose of starting the day by taking a platinum delivery and immediately aborting it");
	tt_printSetting("guzzlr_autoFamiliar", "Automatically switch familiar using autoscend code to IOTM familiars that still have items to drop today and when out of that to +item drop familiars");
	tt_printSetting("guzzlr_manualFamiliar", "Automatically switch to a single manually specified familiar");
	tt_printSetting("guzzlr_manualFamiliarChoice", "The name of the familiar you want to manually switch to");
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
	print();
}

int guzzlr_QuestTier()
{
	if(quest_unstarted("questGuzzlr"))
	{
		return 0;
	}
	
	string mafia_tier = get_property("guzzlrQuestTier");
	int my_tier = 0;
	
	if(mafia_tier == "bronze") my_tier = 1;
	if(mafia_tier == "gold") my_tier = 2;
	if(mafia_tier == "platinum") my_tier = 3;
	
	return my_tier;
}

boolean guzzlr_QuestStart(int tier)
{
	//returns true if successfully started the quest or if the quest is already started on the desired target
	if(tier > 3 || tier < 1)
	{
		abort("Error: " + tier + "is not a valid tier for boolean guzzlr_QuestStart(int tier)");
	}
	if(!quest_unstarted("questGuzzlr"))		//already started. just compare it to desired target
	{
		return tier == guzzlr_QuestTier();
	}
	
	if(tier == 3 && (get_property("_guzzlrPlatinumDeliveries").to_int() > 0 || get_property("_guzzlrQuestAbandoned").to_boolean()))
	{
		return false;		//already started max today or already abandoned a quest today.
	}
	if(tier == 2 && get_property("_guzzlrGoldDeliveries").to_int() > 2)
	{
		return false;		//already started max today
	}
	
	print("Taking a tier " + tier + " delivery", "blue");
	//choices: 2 = bronze 3 = gold 4 = platinum 5 = change your mind and not take a quest
	visit_url("inventory.php?tap=guzzlr", false);
	run_choice(tier+1);
	
	return tier == guzzlr_QuestTier();
}

item accessItem()
{
	location goal = get_property("guzzlrQuestLocation").to_location();
	
	//The Worm Wood. you get there via a potion called [tiny bottle of absinthe] which gives 10 turns of access.
	if($locations[The Mouldering Mansion, The Rogue Windmill, The Stately Pleasure Dome] contains goal)
	{
		return $item[tiny bottle of absinthe];
	}
	
	//A Transporter Booth. you get there via an item called [transporter transponder] which gives 30 turns of access.
	if($locations[Domed City of Ronaldus, Domed City of Grimacia, Hamburglaris Shield Generator] contains goal)
	{
		return $item[transporter transponder];
	}
	
	//Spring Break Beach. you get there via a dayticket
	if($locations[The Fun-Guy Mansion, Sloppy Seconds Diner, The Sunken Party Yacht] contains goal)
	{
		return $item[one-day ticket to Spring Break Beach];
	}
	
	//Dinseylandfill. you get there via a dayticket
	if($locations[Barf Mountain, Pirates of the Garbage Barges, The Toxic Teacups, Uncle Gator\'s Country Fun-Time Liquid Waste Sluice] contains goal)
	{
		return $item[one-day ticket to Dinseylandfill];
	}
	
	//That 70s Volcano. you get there via a dayticket
	if($locations[The SMOOCH Army HQ, The Velvet \/ Gold Mine, LavaCo&trade; Lamp Factory, The Bubblin\' Caldera] contains goal)
	{
		return $item[one-day ticket to That 70s Volcano];
	}
	
	//Conspiracy Island. you get there via a dayticket
	if($locations[The Deep Dark Jungle, The Mansion of Dr. Weirdeaux, The Secret Government Laboratory] contains goal)
	{
		return $item[one-day ticket to Conspiracy Island];
	}
	
	//The Glaciest. you get there via a dayticket
	if($locations[The Ice Hotel, VYKEA, The Ice Hole] contains goal)
	{
		return $item[One-day ticket to The Glaciest];
	}
	
	abort("Could not determine which access item matches the location [" + goal + "]. Please report this so it can be added");
	return $item[none];
}

boolean platinumZoneAvailable()
{
	//Checks if you already have access to a t3 zone
	if(guzzlr_QuestTier() != 3)
	{
		return false;
	}

	item access_item = accessItem();
	
	if(access_item == $item[tiny bottle of absinthe])
	{
		if(have_effect($effect[Absinthe-Minded]) > 0)
		{
			return true;
		}
		return false;
	}
	if(access_item == $item[transporter transponder])
	{
		if(have_effect($effect[Transpondent]) > 0)
		{
			return true;
		}
		return false;
	}
	if(access_item == $item[one-day ticket to Spring Break Beach])
	{
		if(get_property("sleazeAirportAlways").to_boolean() || get_property("_sleazeAirportToday").to_boolean())
		{
			return true;
		}
		return false;
	}
	if(access_item == $item[one-day ticket to Dinseylandfill])
	{
		if(get_property("stenchAirportAlways").to_boolean() || get_property("_stenchAirportToday").to_boolean())
		{
			return true;
		}
		return false;
	}
	if(access_item == $item[one-day ticket to That 70s Volcano])
	{
		if(get_property("hotAirportAlways").to_boolean() || get_property("_hotAirportToday").to_boolean())
		{
			return true;
		}
		return false;
	}
	if(access_item == $item[one-day ticket to Conspiracy Island])
	{
		if(get_property("spookyAirportAlways").to_boolean() || get_property("_spookyAirportToday").to_boolean())
		{
			return true;
		}
		return false;
	}
	if(access_item == $item[One-day ticket to The Glaciest])
	{
		if(get_property("coldAirportAlways").to_boolean() || get_property("_coldAirportToday").to_boolean())
		{
			return true;
		}
		return false;
	}
	
	abort("Could not determine whether the platinum zone that goes with  [" + access_item + "] is available or not. Please report this so it can be added");
	return false;
}

boolean accessZoneViaItem()
{
	//this function is used to unlock platinum delivery zones via an item. either a day ticket or a potion that gives an effect that gives temporary access
	if(guzzlr_QuestTier() != 3)
	{
		return false;		//not doing a platinum quest
	}
	if(platinumZoneAvailable())
	{
		return true;		//already have access
	}

	item access_item = accessItem();
	tt_acquire(access_item);
	use(1, access_item);
	if(platinumZoneAvailable()) return true;
	abort("Failed to unlock zone using [" + access_item + "]");
	return false;	//need a return false even after abort.
}

boolean abandonQuest()
{
	//returns true if quest is successfully abandoned.
	if(get_property("_guzzlrQuestAbandoned").to_boolean())
	{
		return false; //can only abandon one a day
	}
	if(quest_unstarted("questGuzzlr"))
	{
		return true;
	}
	
	visit_url("inventory.php?tap=guzzlr", false);
	run_choice(1);	//abandon quest
	run_choice(5);	//exit menu
	
	//workaround for mafia bug. while this workaround exists verification is broken and it assumes success.
	//https://kolmafia.us/showthread.php?24954-Guzzlr-tablet-May-Item-of-the-month&p=157648&viewfull=1#post157648
	set_property("questGuzzlr", "unstarted");
	set_property("guzzlrQuestTier", "");
	
	if(quest_unstarted("questGuzzlr"))
	{
		return true;
	}
	return false;
}

void abandonPlatinum()
{
	if(get_property("_guzzlrQuestAbandoned").to_boolean() || get_property("_guzzlrPlatinumDeliveries").to_int() > 0)
	{
		return;
	}
	if(guzzlr_QuestStart(3))
	{
		if(!abandonQuest())		//try to abandon quest
		{
			abort("Failed to abandon platinum quest");
		}
	}
}


boolean guzzlr_deliverLoop()
{
	//return true when changes are made to restart the loop.
	//return false to end the loop.
	
	//acquireHP();
	
	//familiar switching
	if(get_property("guzzlr_autoFamiliar").to_boolean())			//want to use auto familiar chooice.
	{
		handleFamiliar("item");		//autoscend familiar choosing. item dropping familiars then familiars that give +item drop
		use_familiar(to_familiar(get_property("auto_familiarChoice")));		//actually change to the familiar
	}
	else if(get_property("guzzlr_manualFamiliar").to_boolean())		//want to use a manually specified familiar
	{
		familiar fam = to_familiar(get_property("guzzlr_manualFamiliarChoice"));
		if(fam == $familiar[none])
		{
			abort("Tried to use a manually chosen familiar but failed to convert it from a name to a familiar");
		}
		use_familiar(fam);
	}	
	
	//disabled for now. set outfit and mood yourself.
	/*
	resetMaximize();
	if(possessEquipment(GUZZLR_SHOES)) autoEquip(GUZZLR_SHOES);
	if(possessEquipment(GUZZLR_PANTS)) autoEquip(GUZZLR_PANTS);
	if(possessEquipment(GUZZLR_HAT)) autoEquip(GUZZLR_HAT);
	//TODO add mafia thumb ring for easy turngen
	providePlusCombat(25);
	*/
	
	//start best quest
	if(quest_unstarted("questGuzzlr") && get_property("guzzlr_deliverPlatinum").to_boolean())
	{
		guzzlr_QuestStart(3);		//platinum
	}
	if(quest_unstarted("questGuzzlr") && get_property("guzzlr_deliverGold").to_boolean())
	{
		guzzlr_QuestStart(2);		//gold
	}
	if(quest_unstarted("questGuzzlr") && get_property("guzzlr_deliverBronze").to_boolean())
	{
		guzzlr_QuestStart(1);		//bronze
	}
	if(guzzlr_QuestTier() == 0)
	{
		abort("Failed to start guzzlr quest for some reason");
	}
	
	//get some data
	item drink;
	int drink_price;
	if(guzzlr_QuestTier() == 3)
	{
		drink = $item[Ghiaccio Colada];
		drink_price = auto_mall_price($item[cold wad]);
	}
	else
	{
		drink = get_property("guzzlrQuestBooze").to_item();
		drink_price = auto_mall_price(drink);
	}
	location goal = get_property("guzzlrQuestLocation").to_location();
	
	//abandon or abort if quest is too expensive
	int max_cost_bronze = get_property("guzzlr_maxMeatCostBronze").to_int();
	int max_cost_gold = get_property("guzzlr_maxMeatCostGold").to_int();
	int max_cost_platinum = get_property("guzzlr_maxMeatCostPlatinum").to_int();
	boolean abandon_too_expensive = get_property("guzzlr_abandonTooExpensive").to_boolean();
	
	if((guzzlr_QuestTier() == 1 && drink_price > max_cost_bronze) || (guzzlr_QuestTier() == 2 && drink_price > max_cost_gold))
	{
		if(abandon_too_expensive)
		{
			print("The booze [" + drink + "] is too expensive. abandoning delivery", "blue");
			if(abandonQuest()) return true;
		}
		abort("The drink [" + drink + "] is too expensive");
	}
	if(guzzlr_QuestTier() == 3)
	{
		item access_item = accessItem();
		int price_access_item = auto_mall_price(access_item);
		int price_sum = drink_price;
		if(!platinumZoneAvailable())
		{
			price_sum += price_access_item;
			if(access_item == $item[tiny bottle of absinthe])
			{
				price_sum += 2*price_access_item;		//guesstimate needing 3 tiny bottle of absinthe per delivery
			}
		}
		
		if(max_cost_platinum < price_sum)
		{
			if(abandon_too_expensive)
			{
				print("The access item [" + access_item + "] is too expensive. abandoning delivery", "blue");
				if(abandonQuest()) return true;
			}
			abort("The access item [" + access_item + "] is too expensive");
		}
		if(!is_unrestricted(access_item))
		{
			print("The access item [" + access_item + "] is restricted in your path. abandoning delivery", "blue");
			if(abandonQuest()) return true;
			abort("The access item [" + access_item + "] is restricted in your path and we failed to abandon delivery");
		}
	}
	
	//acquire and use access item if needed.
	accessZoneViaItem();
	
	//acquire drink
	if(item_amount(drink) == 0)
	{
		if(guzzlr_QuestTier() == 3)
		{
			tt_acquire($item[cold wad]);
			create(drink);
		}
		else
		{
			tt_acquire(drink);
		}
	}
	if(item_amount(drink) == 0)
	{
		abort("Failed to acquire the booze [" + drink + "]");
	}
	
	if(adv1(goal, -1, "")) return true;
	abort("Failed to adventure in [" + goal + "]");
	return false;
}

void guzzlr_deliver(int adv_to_use)
{
	backupSetting("promptAboutCrafting", 0);
	backupSetting("breakableHandling", 4);
	backupSetting("dontStopForCounters", true);
	backupSetting("choiceAdventureScript", "scripts/autoscend/auto_choice_adv.ash");
	backupSetting("printStackOnAbort", true);
	
	int adv_initial = my_session_adv();
	
	//primary loop
	int adv_spent = 0;
	try
	{
		while(adv_to_use > adv_spent && my_adventures() > 0 && guzzlr_deliverLoop())
		{
			adv_spent = my_session_adv() - adv_initial;
		}
	}
	finally
	{	
		restoreAllSettings();
	}
}

void guzzlr_aftercore(int adv_to_use)
{
	if(get_property("guzzlr_abandonPlatinumForcedAftercore").to_boolean())
	{
		abandonPlatinum();
	}
	guzzlr_deliver(adv_to_use);
}

void guzzlr_inrun(int adv_to_use)
{
	if(get_property("guzzlr_abandonPlatinumForcedInrun").to_boolean())
	{
		abandonPlatinum();
	}
	if(!get_property("guzzlr_deliverInrun").to_boolean())
	{
		return;		//delivering in run is disabled
	}
	guzzlr_deliver(adv_to_use);
}

void main(int adv_to_use)
{
	if(!possessEquipment($item[Guzzlr tablet]))
	{
		abort("I can't find a guzzlr tablet");
	}
	if(my_adventures() == 0)
	{
		abort("You don't have any adventures");
	}
	
	guzzlr_settings_defaults();
	
	boolean inrun = true;
	if(inPostRonin() && get_property("guzzlr_treatPostroninAsAftercore").to_boolean())
	{
		inrun = false;
	}
	else if(inCasual() && get_property("guzzlr_treatCasualAsAftercore").to_boolean())
	{
		inrun = false;
	}
	else if(inAftercore())
	{
		inrun = false;
	}
	
	try
	{
		if(inrun)
		{
			guzzlr_inrun(adv_to_use);
		}
		else
		{
			guzzlr_aftercore(adv_to_use);
		}
	}
	finally
	{
		guzzlr_settings_print();
	}
}