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
	if(get_property("greygoo_fightGoo") == "")
	{
		new_setting_added = true;
		set_property("greygoo_fightGoo", true);
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
	tt_printSetting("greygoo_fightGoo", "fight the goo monsters");
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
	print();
}

boolean greygooAdv(location loc)
{
	if(!zone_isAvailable(loc, true)){
		auto_log_warning("Can't get to " + loc + " right now.", "red");
		return false;
	}

	set_property("nextAdventure", loc);
	
	equipMaximizedGear();
	autoChooseFamiliar(loc);
	preAdvUpdateFamiliar(loc);

	// adv1 can erroneously return false for "choiceless" non-combats
	// see https://kolmafia.us/showthread.php?25370-adv1-returns-false-for-quot-choiceless-quot-choice-adventures
	// undo all this when (if?) that ever gets fixed
	string previousEncounter = get_property("lastEncounter");
	int turncount = my_turncount();
	boolean advReturn = adv1(loc, -1, "");
	if (!advReturn)
	{
		auto_log_debug("adv1 returned false for some reason. Did we actually adventure though?", "blue");
		if (get_property("lastEncounter") != previousEncounter)
		{
			auto_log_debug(`Looks like we may have adventured, lastEncounter was {previousEncounter}, now {get_property("lastEncounter")}`, "blue");
			advReturn = true;
		}
		if (my_turncount() > turncount)
		{
			auto_log_debug(`Looks like we may have adventured, turncount was {turncount}, now {my_turncount()}`, "blue");
			advReturn = true;
		}
	}
	
	if(have_effect($effect[Beaten Up]) > 0)
	{
		abort("We got beaten up");
	}
	
	return advReturn;
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
		return greygooAdv($location[Madness Bakery]);
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
	
	return greygooAdv(goal);
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

boolean greygoo_fightGoo()
{
	if(!get_property("greygoo_fightGoo").to_boolean())
	{
		return false;
	}

	buffMaintain($effect[blood bubble], 0, 1, 1);
	
	boolean advResult = false;
	
	switch(get_property("_greygoo_zonesFinished").to_int())
	{
	case 0:
		//fight 11 scaling monsters in [The Goo-Bedecked Beanstalk].
		//scaling: Combat Initiative / 3
		provideInitiative(1000,true);
		
		advResult = greygooAdv($location[The Goo-Bedecked Beanstalk]);
		if(get_property("lastEncounter") == "You Don't Find Jack")
		{
			set_property("_greygoo_zonesFinished", "1");
		}
		break;
	case 1:
		//fight 11 scaling monsters in [The Goo-Coated Knob].
		//scaling: 3 * (Sleaze Resistance) * (1 + (Food drop% / 100))
		addToMaximize("30 sleaze res,10 food drop");
		
		advResult = greygooAdv($location[The Goo-Coated Knob]);
		if(get_property("lastEncounter") == "Goo-Gone")
		{
			set_property("_greygoo_zonesFinished", "2");
		}
		break;
	case 2:
		//fight 11 scaling monsters in [The Goo-Spewing Bat Hole].
		//scaling: 4 * (Stench Resistance) * (1 + (-Combat Chance%) / 100)
		addToMaximize("40 stench res");
		providePlusNonCombat(30);
		
		advResult = greygooAdv($location[The Goo-Spewing Bat Hole]);
		if(get_property("lastEncounter") == "The Hole Is No Longer a Hole")
		{
			set_property("_greygoo_zonesFinished", "3");
		}
		break;
	case 3:
		//fight 11 scaling monsters in [The Goo-Girded Garves].
		//scaling: 4 * (Spooky Resistance) * (1 + (+Combat Chance%) / 100)
		addToMaximize("40 spooky res");
		providePlusCombat(30);
		
		advResult = greygooAdv($location[The Goo-Girded Garves]);
		if(get_property("lastEncounter") == "Un-Unquiet")
		{
			set_property("_greygoo_zonesFinished", "4");
		}
		break;
	case 4:
		//fight 11 scaling monsters in [The Goo-Shrouded Palindome].
		//scaling: Monster Level
		addToMaximize("10 ml");
		
		advResult = greygooAdv($location[The Goo-Shrouded Palindome]);
		if(get_property("lastEncounter") == "No More Goo, Geromon")
		{
			set_property("_greygoo_zonesFinished", "5");
		}
		break;
	case 5:
		//fight 11 scaling monsters in [The Goo-Splattered Tower Ruins].
		//scaling: sqrt(Maximum MP)
		addToMaximize("10 mp");
		
		advResult = greygooAdv($location[The Goo-Splattered Tower Ruins]);
		if(get_property("lastEncounter") == "Doubly Abandoned")
		{
			set_property("_greygoo_zonesFinished", "6");
		}
		break;
	case 6:
		//fight 11 scaling monsters in [The Goo-Choked Fun House].
		//scaling: sqrt(Maximum HP)
		addToMaximize("10 hp");
		
		advResult = greygooAdv($location[The Goo-Choked Fun House]);
		if(get_property("lastEncounter") == "No More Fun")
		{
			set_property("_greygoo_zonesFinished", "7");
		}
		break;
	case 7:
		//fight 1 scaling monsters in [Prism of Goo].
		//scaling: Prismatic Damage
		addToMaximize("10 prismatic dmg");
		
		//advResult = greygooAdv($location[Prism of Goo]);
		set_property("_greygoo_zonesFinished", "8");
		abort("Please manually fight A Prism of Goo and then run me again");
		break;
	case 8:
		//fight scaling monsters in [The Goo Fields].
		//scaling: enemies defeated here
		
		advResult = greygooAdv($location[The Goo Fields]);
		break;
	}
	
	return advResult;
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
	
	resetState();
	
	if(my_hp() < my_maxhp() * 0.8)
	{
		acquireHP();
	}
	int mp_target = min(my_maxmp() * 0.9, 200);		//0.9 multiplier to avoid wastage
	if(my_mp() < mp_target)
	{
		acquireMP(mp_target);
	}
	
	if(greygoo_fortuneCollect()) return true;
	if(greygoo_guild()) return true;
	if(greygoo_bakery()) return true;
	if(greygoo_fightGoo()) return true;
	
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
	backupSetting("hpAutoRecovery", -0.05);
	backupSetting("hpAutoRecoveryTarget", -0.05);
	backupSetting("mpAutoRecovery", -0.05);
	backupSetting("mpAutoRecoveryTarget", -0.05);
	backupSetting("manaBurningTrigger", -0.05);
	backupSetting("manaBurningThreshold", -0.05);
	backupSetting("autoAbortThreshold", -0.05);
	
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