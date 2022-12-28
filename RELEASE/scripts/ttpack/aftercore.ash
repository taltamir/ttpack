import <scripts/ttpack/util/tt_util.ash>

//public prototypes
void tt_chooseFamiliar();
boolean tt_iceHouseAMC();
boolean tt_guild(boolean override);
boolean tt_dailyDungeon();
boolean tt_fatLootToken();
boolean tt_meatFarm();
void tt_help();

void tt_chooseFamiliar()
{
	familiar familiar_target_100 = get_property("auto_100familiar").to_familiar();
	if(familiar_target_100 != $familiar[none])		//do not break 100 familiar runs. yes, even in aftercore.
	{
		handleFamiliar(familiar_target_100);
		use_familiar(familiar_target_100);
	}
	else
	{
		handleFamiliar("drop");		//autoscend familiar choosing. choose a familiar that drops items
		if(!get_property("_auto_thisLoopHandleFamiliar").to_boolean())	//if could not find a drop familiar
		{
			handleFamiliar("meat");
		}
		use_familiar(get_property("auto_familiarChoice").to_familiar());
	}
}

void tt_useAstralLeftovers()
{
	if(!get_property("aftercore_useAstralLeftovers").to_boolean())
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

void tt_consumeAll()
{
	if(!get_property("aftercore_consumeAll").to_boolean())
	{
		return;
	}
	if(my_familiar() == $familiar[Stooper])
	{
		use_familiar($familiar[none]);
	}
	cli_execute("CONSUME ALL");
}

boolean tt_aroundTheWorld()
{
	//do the repeatable quest [Around the World Quest] to get the drink with the same name
	boolean has_trap = item_amount($item[Spanish fly trap]) > 0;
	boolean has_drink = item_amount($item[around the world]) > 0;
	location orcplace = $location[Frat House];
	
	//start the quest by getting [I Just Wanna Fly] or [Me Just Want Fly] noncombat adv
	//if(!has_trap && !has_drink &&)
	
	return false;
}

boolean tt_usedBlood()
{
	//get 1 quest item [bottle of used blood] for making a [Staff of Blood and Pudding]
	//see noncombat handling is done in aftercore_choice_adv.ash
	if(!gbool("_aftercoreGetUsedBlood")) return false;
	if(item_amount($item[bottle of used blood]) > 0) return false;
	
	if(item_amount($item[Vampire heart]) == 0 && possessEquipment($item[wooden stakes]))
		autoForceEquip($item[wooden stakes]);
		
	location loc = $location[The Spooky Forest];
	providePlusNonCombat(25, loc);
	return autoAdv(loc);
}

boolean aftercore_getChefstaff(boolean override)
{
	if(!get_property("aftercore_getChefstaff").to_boolean() && !override)
	{
		return false;
	}
	if(my_meat() < 1000000)
		return false;		//too poor
	if(!($classes[pastamancer, sauceror] contains my_class()))
		return false;	//no rodrick access
	
	if(override)	//override should also apply to unlocking guild store
	{
		if(tt_guild(true)) return true;
	}
	
	item it;
	item[item] missing;		//syntax is staffname[component]
		
	//cheap basic staves we can just easily mallbuy the parts of
	if(retrieve_new($item[Staff of the Short Order Cook])) return true;
	if(retrieve_new($item[Staff of the Midnight Snack])) return true;
	
	//while very cheap. one of the ingredients is a quest item you must acquire yourself
	it = $item[Staff of Blood and Pudding];
	if(!possessEquipment(it))
	{
		if(item_amount($item[bottle of used blood]) > 0)
		{
			remove_property("_aftercoreGetUsedBlood");
			if(retrieve_new(it)) return true;
		}
		else
		{
			set_property("_aftercoreGetUsedBlood", true);
			if(tt_usedBlood()) return true;	//do the quest to get the booze
			missing[$item[bottle of used blood]] = it;		//if we can not adventure for some reason
		}
	}
	
	//more cheap basic staves
	if(retrieve_new($item[Staff of the Teapot Tempest])) return true;
	if(retrieve_new($item[Staff of the Greasefire])) return true;
	if(retrieve_new($item[Staff of the Electric Range])) return true;

	it = $item[Staff of the Black Kettle];
	if(!possessEquipment(it))
	{
		if(item_amount($item[around the world]) > 1) 	//do not use last one. having 1 in inventory shortens the quest
		{
			if(retrieve_new(it)) return true;
		}
		else missing[$item[around the world]] = it;
		//TODO
		//acquisition currently disabled due to missing mafia tracking
		//else if(tt_aroundTheWorld()) return true;	//do the quest to get the booze
	}
	
	it = $item[Staff of the Soupbone];
	if(!possessEquipment(it))
	{
		boolean has_rib = item_amount($item[rib of the Bonerdagon]) > 0;
		boolean has_balls = item_amount($item[Glass Balls of the Goblin King]) > 0;
		if(!has_rib) missing[$item[rib of the Bonerdagon]] = it;
		if(!has_balls) missing[$item[Glass Balls of the Goblin King]] = it;
		if(has_rib && has_balls)
		{
			if(retrieve_new(it)) return true;
		}
	}
	
	//TODO
	//[Staff of Holiday Sensations]
	
	it = $item[Staff of the Walk-In Freezer];
	if(!possessEquipment(it))
	{
		try_retrieve($item[ram stick]);
		try_retrieve(3, $item[cold hi mein]);
		try_retrieve($item[icy mushroom wine]);
		try_retrieve(10, $item[cold wad]);
		try_retrieve($item[frozen feather]);
		if(retrieve_item(it)) return true;
	}
	
	it = $item[Staff of the Grand Flamb&eacute;];
	if(!possessEquipment(it))
	{
		try_retrieve($item[smoldering staff]);
		try_retrieve(3, $item[hot hi mein]);
		try_retrieve($item[flaming mushroom wine]);
		try_retrieve(10, $item[hot wad]);
		try_retrieve($item[flaming feather]);
		if(retrieve_item(it)) return true;
	}
	
	it = $item[Staff of the Kitchen Floor];
	if(!possessEquipment(it))
	{
		try_retrieve($item[linoleum staff]);
		try_retrieve(3, $item[stinky hi mein]);
		try_retrieve($item[stinky mushroom wine]);
		try_retrieve(10, $item[stench wad]);
		try_retrieve($item[fetid feather]);
		if(retrieve_new(it)) return true;
	}
	
	it = $item[Staff of the Grease Trap];
	if(!possessEquipment(it))
	{
		try_retrieve($item[giant cheesestick]);
		try_retrieve(3, $item[sleazy hi mein]);
		try_retrieve($item[flat mushroom wine]);
		try_retrieve(10, $item[sleaze wad]);
		try_retrieve($item[flirtatious feather]);
		if(retrieve_new(it)) return true;
	}
	
	//TODO
	//[Staff of the Scummy Sink]
	//[Staff of the Deepest Freeze]
	//[Staff of the Roaring Hearth]
	//[Staff of Kitchen Royalty]
	//[Staff of Frozen Lard]. items must be malled. ~100k meat
	//[Staff of the Peppermint Twist]. core item is 5 million at mall
	
	if(override)
	{
		foreach com, staff in missing
		{
			print("[" +staff+ "] cannot be crafted due to not having [" +com+ "].", "red");
		}
	}
	
	return false;
}

void aftercore_buyExpensive()
{
	if(!gbool("aftercore_buyExpensive"))
		return;
	
	foreach it in $items[mafia pinky ring, mafia thumb ring]
	{
		int lim = gint("aftercore_buyExpensiveLimit");
		if(possessEquipment(it)) continue;		//already owned. skip to next
		if(retrieve_price(it) > lim) continue;		//exceeds max price. skip to next
		if(my_meat() < 1000000 + retrieve_price(it)) break;		//not enough meat. stop so we can save enough meat
		tt_acquire(it,retrieve_price(it));
	}
}

boolean tt_acquireFamiliars()
{
	getTerrarium();
	if(!checkTerrarium())
	{
		return false;
	}
	
	hatchList();				//hatch common familiars whose hatchlings drop naturally.
	acquireFamiliars();			//acquire common familiars then hatch them.
	acquireFamiliarsCasual();	//acquire more common familiars then hatch them.

	if(LX_acquireFamiliarLeprechaun()) return true;
	
	//rugamuffing imp currently disabled until I add it with a user toggleable setting to autoscend.
	/*
	//attack familiar that is very easy to get.
	if(!have_familiar($familiar[Ragamuffin Imp]) && !get_property("demonSummoned").to_boolean() && item_amount($item[pile of smoking rags]) < 1 && display_amount($item[pile of smoking rags]) < 1)
	{
		cli_execute("summon Tatter");
	}
	hatchFamiliar($familiar[Ragamuffin Imp]);
	*/
	
	return false;
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
		return false;		//do not even try to do the daily dungeon without the 3 tools
	}
	
	backupSetting("betweenBattleScript", "scripts/autoscend/auto_pre_adv.ash");
	boolean retval = LX_dailyDungeonToken();
	restoreSetting("betweenBattleScript");
	return retval;
}

boolean tt_fatLootToken(boolean override)
{
	if(!get_property("aftercore_fatLootToken").to_boolean() && !override)
	{
		return false;
	}

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
	if(!override && item_amount($item[Fat Loot Token]) >= tokens_needed)
	{
		return false;
	}
	
	print("tokens needed = " + tokens_needed + ". Tokens available = " + item_amount($item[Fat Loot Token]));
	
	if(tt_dailyDungeon()) return true;
	
	return false;
}

boolean tt_iceHouseAMC(boolean override)
{
	if(!get_property("aftercore_iceHouseAMC").to_boolean() && !override)
	{
		return false;
	}
	
	//2020-05-17 refresh icehouse status. mafia often thinks it is empty when it is not. maybe because it is out of standard?
	//http://127.0.0.1:60083/museum.php?action=icehouse
	return false;
}

boolean tt_guild(boolean override)
{
	if(!get_property("aftercore_guildUnlock").to_boolean() && !override)
	{
		return false;
	}
	
	return LX_guildUnlock();	//autoscend function
}

void tt_meatItemBuff(effect eff, item it, float duration, float bonus)
{
	if(have_effect(eff) > 0)
	{
		return;
	}
	
	//average combat base meat is 112.5 meat. does not account for queue manipulation like -combat and sniff
	float bonus_meat = 112.5 * bonus / 100;
	float price_per_adv = mall_price(it) / duration;
	float profit = bonus_meat - price_per_adv;
	
	//line below is for debugging. only enable temporarily while testing.
	//print("[" + it + "] bonus_meat = " + bonus_meat + ". price_per_adv = " + price_per_adv + ". profit = " + profit + ".");
	
	if(profit < 0) return;
	
	if(retrieve_item(1, it))
	{
		use(1, it);
	}
}

boolean tt_meatFarm(boolean override)
{
	if(!get_property("aftercore_meatFarm").to_boolean() && !override)
	{
		return false;
	}

	//castle in the sky top floor NCs
	set_property("choiceAdventure675", 1);
	set_property("choiceAdventure676", 4);
	set_property("choiceAdventure677", 4);
	set_property("choiceAdventure678", 2);
	
	//castle in the sky basement NCs
	set_property("choiceAdventure669", 1);
	set_property("choiceAdventure670", 4);
	set_property("choiceAdventure671", 1);
	
	//get some +meat buffs
	shrugAT($effect[Polka of Plenty]);
	buffMaintain($effect[Polka of Plenty], 0, 1, 1);		//+50% meat drop song
	buffMaintain($effect[Disco Leer], 0, 1, 1);				//+10% meat drop facial expression
	
	float sauce_potion_duration = 5;
	if(my_class() == $class[Sauceror]) sauce_potion_duration +=5;
	if(have_skill($skill[Impetuous Sauciness])) sauce_potion_duration +=5;

	tt_meatItemBuff($effect[Cranberry Cordiality], $item[Meat-inflating powder], sauce_potion_duration, 10);
	tt_meatItemBuff($effect[Big Meat Big Prizes], $item[Meat-inflating powder], 20, 50);
	tt_meatItemBuff($effect[Fortunate Resolve], $item[resolution: be luckier], 20, 10);

	string maximizer_string = "meat,effective";
	if(possessEquipment($item[mafia thumb ring]))
	{
		maximizer_string += ",+equip mafia thumb ring";
	}
	maximize(maximizer_string, false);

	return autoAdv($location[The Castle in the Clouds in the Sky (Basement)]);
}

boolean tt_doTasks()
{
	//main loop of aftercore. returning true resets the loop. returning false exits the loop
	auto_interruptCheck();
	resetState();
	tt_chooseFamiliar();
	if(out_of_adv()) return false;
	
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
	
	if(tt_acquireFamiliars()) return true;
	if(LX_freeCombats(true)) return true;
	if(tt_iceHouseAMC(false)) return true;
	if(tt_fatLootToken(false)) return true;
	if(tt_guild(false)) return true;
	if(aftercore_getChefstaff(false)) return true;
	if(tt_meatFarm(false)) return true;
	return false;
}

boolean tt_doSingleTask(string command)
{
	//this is a primary loop. returning true resets the loop. returning false exits the loop
	auto_interruptCheck();
	resetState();
	tt_chooseFamiliar();
	if(out_of_adv()) return false;
	
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
	
	if(tt_acquireFamiliars()) return true;
	if(command == "amc")
	{
		return tt_iceHouseAMC(true);
	}
	if(command == "token")
	{
		if(get_property("dailyDungeonDone").to_boolean())
		{
			print("You already did daily dungeon today and it is currently the only supported source of tokens", "red");
			return false;
		}
		return tt_fatLootToken(true);
		
		//TODO add other sources of token
	}
	if(command == "guild")
	{
		return tt_guild(true);
	}
	if(command == "meat")
	{
		return tt_meatFarm(true);
	}
	if(command == "nemesis")
	{
		return LX_NemesisQuest();
	}
	if(command == "staff")
	{
		return aftercore_getChefstaff(true);
	}
	
	return false;
}

void tt_help()
{
	print("Welcome to aftercore");
	print("To use type in gCLI:");
	print("aftercore [goal]");
	print("Currently supported options for [goal]:");
	print("auto = automatically does all the things based on your configuration");
	print("guild = unlock your guild");
	print("token = gets a single fat loot token if possible");
	print("amc = traps an AMC gremlin in the ice house. currently unimplemented");
	print("meat = meatfarms. currently terrible at it");
	print("nemesis = do nemesis quest. partially implemented");
	print("anything else = show this menu");
}

void main(string command)
{	
	if(!inAftercore())
	{
		abort("Detected that king has not been liberated. This script should only be run in aftercore");
	}
	command = to_lower_case(command);
	
	tt_initialize();
	
	backupSetting("printStackOnAbort", true);
	backupSetting("promptAboutCrafting", 0);
	backupSetting("breakableHandling", 4);
	backupSetting("dontStopForCounters", true);
	backupSetting("choiceAdventureScript", "scripts/ttpack/util/aftercore_choice_adv.ash");
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
	backupSetting("currentMood", "apathetic");
	backupSetting("logPreferenceChange", "true");
	backupSetting("logPreferenceChangeFilter", "maximizerMRUList,testudinalTeachings,auto_maximize_current");
	
	initializeDay(my_daycount());
	horseDark();
	auto_voteSetup();
	
	tt_useAstralLeftovers();
	tt_eatSurpriseEggs();
	tt_consumeAll();
	aftercore_buyExpensive();
	
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
		}
	}
	else if($strings[guild, token, amc, meat, nemesis, staff] contains command)
	{
		try
		{
			backupSetting("dontStopForCounters", true);
			while(tt_doSingleTask(command));
		}
		finally
		{
			restoreAllSettings();
		}
	}
	else tt_help();		//print instructions.
}
