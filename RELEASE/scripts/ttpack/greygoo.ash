//do some stuff in a grey goo ascension.

import <scripts/ttpack/util/tt_util.ash>

//public prototype start
void greygoo_settings_print();

//public prototype end

void greygoo_settings_defaults()
{
	boolean new_setting_added = false;
	
	//set defaults
	if(get_property("greygoo_guildUnlock") == "")
	{
		new_setting_added = true;
		set_property("greygoo_guildUnlock", false);
	}
	if(get_property("greygoo_bakeryHardcoreUnlock") == "")
	{
		new_setting_added = true;
		set_property("greygoo_bakeryHardcoreUnlock", true);
	}
	if(get_property("greygoo_bakerySoftcoreUnlock") == "")
	{
		new_setting_added = true;
		set_property("greygoo_bakerySoftcoreUnlock", true);
	}
	if(get_property("greygoo_fortuneHardcore") == "")
	{
		new_setting_added = true;
		set_property("greygoo_fortuneHardcore", true);
	}
	if(get_property("greygoo_fortuneSoftcore") == "")
	{
		new_setting_added = true;
		set_property("greygoo_fortuneSoftcore", true);
	}
	
	if(new_setting_added)
	{
		greygoo_settings_print();
		abort("Settings have been configured to default. Please verify they are correct before running me again");
	}
}

void greygoo_settings_print()
{
	//print current settings status
	print();
	print("Current settings for greygoo:", "blue");
	tt_printSetting("greygoo_guildUnlock", "unlock your class guild");
	tt_printSetting("greygoo_bakeryHardcoreUnlock", "unlock madness bakery if in hardcore");
	tt_printSetting("greygoo_bakerySoftcoreUnlock", "unlock madness bakery if not in hardcore");
	tt_printSetting("greygoo_fortuneHardcore", "consume fortune cookie and lucky lindy in hardcore");
	tt_printSetting("greygoo_fortuneSoftcore", "consume fortune cookie and lucky lindy not in hardcore");
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
	print();
}

boolean greygoo_bakery()
{
	if(in_hardcore())
	{
		if(!get_property("greygoo_bakeryHardcoreUnlock").to_boolean())
		{
			return false;
		}
	}
	else if(!get_property("greygoo_bakerySoftcoreUnlock").to_boolean())
	{
		return false;
	}
	
	if(startArmorySubQuest()) return true;
	
	if(internalQuestStatus("questM25Armorer") > -1 && internalQuestStatus("questM25Armorer") < 4)
	{
		set_property("choiceAdventure1061", 1);	//try to enter office
		return adv1($location[Madness Bakery], -1, "");
	}
	
	if(internalQuestStatus("questM25Armorer") == 4)		//got no-handed pie. need to turn it in.
	{
		print("finishing quest [Lending a Hand (and a Foot)]");
		visit_url("shop.php?whichshop=armory");
		run_choice(2);		//give no-handed pie to finish the quest
	}
	return false;
}

boolean greygoo_guild()
{
	if(!get_property("greygoo_guildUnlock").to_boolean())
	{
		return false;
	}
	if($classes[Seal Clubber, Turtle Tamer] contains my_class())
	{
		return false;	//muscle classes cannot unlock guild in grey goo
	}
	
	return LX_guildUnlock();	//autoscend function
}

boolean greygoo_fortuneCollect()
{
	if(!contains_text(get_counters("Fortune Cookie", 0, 0), "Fortune Cookie"))
	{
		return false;	//semirare not currently about to happen
	}
	
	//Semi-rare Handler
	print("Semi rare time!", "blue");
	cli_execute("counters");

	location goal;
	location lastsr = get_property("semirareLocation").to_location();
	
	if(lastsr != $location[The Outskirts of Cobb\'s Knob])		//can not get the same SR twice. so do not waste it
	{
		goal = $location[The Outskirts of Cobb\'s Knob];
	}
	else
	{
		int food_amt = item_amount($item[tasty tart]);
		int drink_amt = item_amount($item[distilled fortified wine]);
		
		if(food_amt < drink_amt)
		{
			goal = $location[The Haunted Pantry];		//grab epic food
		}
		else
		{
			goal = $location[The Sleazy Back Alley];	//grab epic drink
		}
	}
	
	return adv1(goal, -1, "");
}

boolean greygoo_fortuneConsume()
{
	if(in_hardcore())
	{
		if(!get_property("greygoo_fortuneHardcore").to_boolean())
		{
			return false;
		}
	}
	else if(!get_property("greygoo_fortuneSoftcore").to_boolean())
	{
		return false;
	}
	if(contains_text(get_counters("Fortune Cookie", 0, 200), "Fortune Cookie"))
	{
		return false;
	}
	if(!contains_text(get_counters("Semirare window begin", 0, 200), "Semirare window begin"))
	{
		return false;	//we missed the start of the SR range. do not use fortune cookie
	}

	// Try to consume a Lucky Lindy
	if (inebriety_left() > 0 && canDrink($item[Lucky Lindy]) && my_meat() >= npc_price($item[Lucky Lindy]))
	{
		if (autoDrink(1, $item[Lucky Lindy]))
		{
			return true;
		}
	}

	// Try to consume a Fortune Cookie
	if (fullness_left() > 0 && canEat($item[Fortune Cookie]) && my_meat() >= npc_price($item[Fortune Cookie]))
	{
		// Eat a spaghetti breakfast if still consumable
		if (canEat($item[Spaghetti Breakfast]) && item_amount($item[Spaghetti Breakfast]) > 0 && my_fullness() == 0 && my_level() >= 10)
		{
			if (!autoEat(1, $item[Spaghetti Breakfast]))
			{
				return false;
			}
		}

		buyUpTo(1, $item[Fortune Cookie], npc_price($item[Fortune Cookie]));
		if (autoEat(1, $item[Fortune Cookie]))
		{
			return true;
		}
	}

	return false;
}

boolean greygoo_doTasks()
{
	greygoo_fortuneConsume();
	consumeStuff();
	
	if(my_adventures() == 0)
	{
		print("out of adventures");
		return false;
	}
	
	if(greygoo_fortuneCollect()) return true;
	if(greygoo_guild()) return true;
	if(greygoo_bakery()) return true;
	
	return false;
}

void greygoo_start()
{
	//This also should set our path too.
	string page = visit_url("main.php");
	page = visit_url("api.php?what=status&for=4", false);
	
	backupSetting("printStackOnAbort", true);
	backupSetting("promptAboutCrafting", 0);
	backupSetting("breakableHandling", 4);
	backupSetting("dontStopForCounters", true);
	backupSetting("afterAdventureScript", "");
	backupSetting("betweenBattleScript", "");
	backupSetting("choiceAdventureScript", "scripts/autoscend/auto_choice_adv.ash");
	backupSetting("battleAction", "custom combat script");
	backupSetting("maximizerCombinationLimit", "10000");
	
	//primary loop
	try
	{
		while(greygoo_doTasks());
	}
	finally
	{	
		restoreAllSettings();
	}
}

void main()
{
	if(my_path() != "Grey Goo")
	{
		abort("I am not in Grey Goo");
	}
	
	greygoo_settings_defaults();
	
	try
	{
		greygoo_start();
	}
	finally
	{
		greygoo_settings_print();
	}
}