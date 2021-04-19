//do some stuff in a grey goo ascension.

import <scripts/ttpack/util/tt_util.ash>

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

boolean greygoo_food()
{
	if(in_hardcore())
	{
		if(!get_property("greygoo_foodHardcoreUnlock").to_boolean())
		{
			return false;
		}
	}
	else if(!get_property("greygoo_foodSoftcoreUnlock").to_boolean())
	{
		return false;
	}
	
	//unlock [typical tavern]
	if(L2_mosquito()) return true;
	if(internalQuestStatus("questL03Rat") == 0)		//tavern quest started by visiting council. but never talked to bart ender
	{
		visit_url("tavern.php?place=barkeep");		//talk to him once to unlock his booze selling.
	}
	
	//unlock [madeline's baking supply]
	set_property("auto_doArmory", true);
	if(LX_armorySideQuest()) return true;

	//unlocking hippy store. not really worth it.
	/*
	if(my_level() > 5)		//both for combat strength and to unlock forest to allow adventuring in that zone
	{
		if(LX_hippyBoatman()) return true;		//unlock island
	}
	//can't use autoscend functions here. so need to write a function for acquiring a hippy outfit by fighting hippies in camp
	*/
	
	return false;
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
	
	if(lastsr != $location[The Sleazy Back Alley])		//can not get the same SR twice. so do not waste it
	{
		goal = $location[The Sleazy Back Alley];	//grab epic drink
	}
	else
	{
		goal = $location[The Haunted Pantry];		//grab epic food
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

void greygoo_consume()
{
	if(my_adventures() > 11)
	{
		return;
	}
	while(fullness_left() > 0 && my_adventures() < 12)
	{
		int initial = fullness_left();
		auto_autoConsumeOne("eat", false);
		if(initial == fullness_left()) return;
	}
	if(my_adventures() > 11)
	{
		return;
	}
	while(inebriety_left() > 0)
	{
		int initial = inebriety_left();
		auto_autoConsumeOne("drink", false);
		if(initial == inebriety_left()) return;
	}
}

boolean oddJobs(int target)
{
	//use odd jobs board for roughly ~100 meat per adv and some stats.
	//choice 1 == costs 3 adv and balanced stats
	//choice 2 == costs 10 adv and mus focus stats
	//choice 3 == costs 10 adv and mys focus stats
	//choice 4 == costs 10 adv and mox focus stats
	if(target < 1 || target > 4)
	{
		abort("oddJobs has been given an invalid target");
	}

	int adv_needed = 10;
	if (target == 1)
	{
		adv_needed = 3;
	}
	if(my_adventures() < adv_needed)
	{
		auto_log_warning("oddJobs does not have enough adv left to do desired oddjob");
		return false;
	}

	int start_adv = my_adventures();
	visit_url("place.php?whichplace=town&action=town_oddjobs");
	run_choice(target);

	if(my_adventures() == start_adv - adv_needed)
	{
		cli_execute("auto_post_adv.ash");
		return true;
	}
	abort("oddJobs() error detected. target = " +target+ ". start_adv = " +start_adv+ ". adventures = " +my_adventures()+ ".");
	return false;
}

boolean greygoo_oddJobs()
{
	//do a single oddjob for ~100/adv and some stats
	if(!get_property("greygoo_oddJobs").to_boolean())
	{
		return false;
	}
	if(my_adventures() < 10)
	{
		while(my_meat() > 1000 && auto_autoConsumeOne("drink", false));		//try to fill up on drink
		while(my_meat() > 1000 && auto_autoConsumeOne("eat", false));		//try to fill up on food
		if((my_adventures() < 10 && my_daycount() < 3 ) || my_adventures() < 3)
		{
			return false;
		}
	}
	
	int target = 1;		//choice 1 == costs 3 adv and balanced stats
	if(my_adventures() > 9)
	{
		if($classes[Seal Clubber, Turtle Tamer] contains my_class())
		{
			target = 2;		//choice 2 == costs 10 adv and mus focus stats
		}
		if($classes[Pastamancer, Sauceror] contains my_class())
		{
			target = 3;		//choice 3 == costs 10 adv and mys focus stats
		}
		if($classes[Disco Bandit, Accordion Thief] contains my_class())
		{
			target = 4;		//choice 4 == costs 10 adv and mox focus stats
		}
	}
	
	return oddJobs(target);
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
		//fight 11 scaling monsters in [The Goo-Coated Knob].
		//scaling: 3 * (Sleaze Resistance) * (1 + (Food drop% / 100))
		addToMaximize("30 sleaze res,10 food drop");
		
		advResult = greygooAdv($location[The Goo-Coated Knob]);
		if(get_property("lastEncounter") == "Goo-Gone")
		{
			set_property("_greygoo_zonesFinished", "1");
		}
		break;
	case 1:
		//fight 11 scaling monsters in [The Goo-Spewing Bat Hole].
		//scaling: 4 * (Stench Resistance) * (1 + (-Combat Chance%) / 100)
		addToMaximize("40 stench res");
		providePlusNonCombat(30);
		
		advResult = greygooAdv($location[The Goo-Spewing Bat Hole]);
		if(get_property("lastEncounter") == "The Hole Is No Longer a Hole")
		{
			set_property("_greygoo_zonesFinished", "2");
		}
		break;
	case 2:
		//fight 11 scaling monsters in [The Goo-Girded Garves].
		//scaling: 4 * (Spooky Resistance) * (1 + (+Combat Chance%) / 100)
		addToMaximize("40 spooky res");
		providePlusCombat(30);
		
		advResult = greygooAdv($location[The Goo-Girded Garves]);
		if(get_property("lastEncounter") == "Un-Unquiet")
		{
			set_property("_greygoo_zonesFinished", "3");
		}
		break;
	case 3:
		//fight 11 scaling monsters in [The Goo-Shrouded Palindome].
		//scaling: Monster Level
		addToMaximize("10 ml");
		
		advResult = greygooAdv($location[The Goo-Shrouded Palindome]);
		if(get_property("lastEncounter") == "No More Goo, Geromon")
		{
			set_property("_greygoo_zonesFinished", "4");
		}
		break;
	case 4:
		//fight 11 scaling monsters in [The Goo-Splattered Tower Ruins].
		//scaling: sqrt(Maximum MP)
		addToMaximize("10 mp");
		
		advResult = greygooAdv($location[The Goo-Splattered Tower Ruins]);
		if(get_property("lastEncounter") == "Doubly Abandoned")
		{
			set_property("_greygoo_zonesFinished", "5");
		}
		break;
	case 5:
		//fight 11 scaling monsters in [The Goo-Choked Fun House].
		//scaling: sqrt(Maximum HP)
		addToMaximize("10 hp");
		
		advResult = greygooAdv($location[The Goo-Choked Fun House]);
		if(get_property("lastEncounter") == "No More Fun")
		{
			set_property("_greygoo_zonesFinished", "6");
		}
		break;
	case 6:
		//fight 11 scaling monsters in [The Goo-Bedecked Beanstalk].
		//scaling: Combat Initiative / 3
		provideInitiative(200,true);
		
		advResult = greygooAdv($location[The Goo-Bedecked Beanstalk]);
		if(get_property("lastEncounter") == "You Don't Find Jack")
		{
			set_property("_greygoo_zonesFinished", "7");
		}
		break;
	case 7:
		//fight 1 scaling monsters in [Prism of Goo].
		//scaling: Prismatic Damage
		addToMaximize("10 prismatic dmg");
		
		string page = visit_url("place.php?whichplace=greygoo&action=goo_prism");
		if(contains_text(page, "<b>Combat"))
		{
			run_combat();
			set_property("_greygoo_zonesFinished", "8");
		}
		else abort("Failed to start Prism of Goo fight. please do so manually");
		break;
	case 8:
		//fight scaling monsters in [The Goo Fields].
		//scaling: enemies defeated here
		
		addToMaximize("effective");		//need a weapon that can deal damage for [grey goo torus]
		advResult = greygooAdv($location[The Goo Fields]);
		break;
	}
	
	return advResult;
}

boolean greygoo_doTasks()
{
	auto_interruptCheck();
	greygoo_fortuneConsume();
	greygoo_consume();
	councilMaintenance();
	cli_execute("refresh quests");		//greygoo has broken tracking verified for: questL02Larva && questM19Hippy
	
	if(my_adventures() == 0)
	{
		print("out of adventures");
		return false;
	}
	if(my_familiar() == $familiar[Stooper])
	{
		auto_log_info("Avoiding stooper stupor...", "blue");
		familiar fam = (is100FamRun() ? get_property("auto_100familiar").to_familiar() : $familiar[Mosquito]);
		use_familiar(fam);
	}
	if(my_inebriety() > inebriety_limit())
	{
		auto_log_warning("I am overdrunk", "red");
		return false;
	}
	
	resetState();
	
	if(greygoo_fortuneCollect()) return true;
	if(my_level() < 3)	//do oddjobs early if level is very low
	{
		if(greygoo_oddJobs()) return true;
	}
	if(my_meat() < 300)
	{
		if(greygoo_oddJobs()) return true;
	}
	if(LX_galaktikSubQuest()) return true;
	if(LX_guildUnlock()) return true;
	if(greygoo_food()) return true;
	if(LX_freeCombats(true)) return true;
	if(greygoo_oddJobs()) return true;
	if(greygoo_fightGoo()) return true;
	
	if(inebriety_left() == 0 && my_adventures() < 11)		//checks that we reached here because we are done rather than due to some problem.
	{
		auto_drinkNightcap();		//drink nightcap
	}
	
	return false;
}

void greygoo_start()
{
	//This also should set our path too.
	string page = visit_url("main.php");
	page = visit_url("api.php?what=status&for=4", false);
	
	initializeSettings();		//initialize autoscend once per ascension.
	
	backupSetting("printStackOnAbort", true);
	backupSetting("promptAboutCrafting", 0);
	backupSetting("breakableHandling", 4);
	backupSetting("dontStopForCounters", true);
	backupSetting("choiceAdventureScript", "scripts/autoscend/auto_choice_adv.ash");
	backupSetting("betweenBattleScript", "scripts/autoscend/auto_pre_adv.ash");
	backupSetting("battleAction", "custom combat script");
	backupSetting("maximizerCombinationLimit", "10000");
	backupSetting("hpAutoRecovery", -0.05);
	backupSetting("hpAutoRecoveryTarget", -0.05);
	backupSetting("mpAutoRecovery", -0.05);
	backupSetting("mpAutoRecoveryTarget", -0.05);
	backupSetting("manaBurningTrigger", -0.05);
	backupSetting("manaBurningThreshold", -0.05);
	backupSetting("autoAbortThreshold", -0.05);
	
	initializeDay(my_daycount());
	horseDark();
	auto_voteSetup();
	
	if(get_property("greygoo_galaktikQuest").to_boolean())
	{
		set_property("auto_doGalaktik", true);
	}
	
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
	
	tt_initialize();		//configures ttpack settings to default values on first run and removes depreciated settings.
	
	try
	{
		greygoo_start();
	}
	finally
	{
		equipRollover();
		if(my_daycount() < 3)
		{
			print("You are currently on day " +my_daycount()+ " out of 3 of this grey goo run","red");
		}
		else
		{
			print("You are done with this grey goo ascension. please enter the astral gash","blue");
		}
	}
}