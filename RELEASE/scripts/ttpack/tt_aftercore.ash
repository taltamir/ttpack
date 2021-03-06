import <scripts/ttpack/util/tt_util.ash>

//public prototypes
void tt_chooseFamiliar();
boolean tt_iceHouseAMC();
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

void tt_consumeAll()
{
	if(!get_property("tt_aftercore_consumeAll").to_boolean())
	{
		return;
	}
	
	cli_execute("CONSUME ALL");
}

void tt_buyStuff()
{
	if(!get_property("tt_aftercore_buyStuff").to_boolean())
	{
		return;
	}
	
	tt_acquire($item[mafia pinky ring]);
	tt_acquire($item[mafia thumb ring]);
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
	if(!get_property("tt_aftercore_fatLootToken").to_boolean() && !override)
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
	if(!get_property("tt_aftercore_iceHouseAMC").to_boolean() && !override)
	{
		return false;
	}
	
	//2020-05-17 refresh icehouse status. mafia often thinks it is empty when it is not. maybe because it is out of standard?
	//http://127.0.0.1:60083/museum.php?action=icehouse
	return false;
}

boolean tt_guild(boolean override)
{
	if(!get_property("tt_aftercore_guildUnlock").to_boolean() && !override)
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
	if(!get_property("tt_aftercore_meatFarm").to_boolean() && !override)
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
	//main loop of tt_aftercore. returning true resets the loop. returning false exits the loop
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
	
	return false;
}

void tt_help()
{
	print("Welcome to tt_aftercore");
	print("To use type in gCLI:");
	print("tt_aftercore [goal]");
	print("Currently supported options for [goal]:");
	print("auto = automatically does all the things based on your configuration");
	print("guild = unlock your guild");
	print("token = gets a single fat loot token if possible");
	print("amc = traps an AMC gremlin in the ice house. currently unimplemented");
	print("meat = meatfarms. currently terrible at it");
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
	backupSetting("currentMood", "apathetic");
	backupSetting("logPreferenceChange", "true");
	backupSetting("logPreferenceChangeFilter", "maximizerMRUList,testudinalTeachings,auto_maximize_current");
	
	initializeDay(my_daycount());
	horseDark();
	auto_voteSetup();
	
	tt_useAstralLeftovers();
	tt_eatSurpriseEggs();
	tt_consumeAll();
	
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
	else if($strings[guild, token, amc, meat] contains command)
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