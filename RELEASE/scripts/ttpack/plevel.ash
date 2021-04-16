//power level to a specified target level.

import <scripts/ttpack/util/tt_util.ash>

item MAGAZINE = $item[GameInformPowerDailyPro magazine];
item WALKTHROUGH = $item[GameInformPowerDailyPro walkthru];

boolean pl_fortuneCollect()
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
	
	//TODO add collecting poolshark SRs for permanent bonus to pool skill
	if(lastsr != $location[The Sleazy Back Alley])		//can not get the same SR twice. so do not waste it
	{
		goal = $location[The Sleazy Back Alley];	//grab epic drink
	}
	else
	{
		goal = $location[The Haunted Pantry];		//grab epic food
	}
	
	return autoAdv(goal);
}

float price_per_adv(item it)
{
	int duration = numeric_modifier(it, "effect duration");
	int price = auto_mall_price(it);
	if(duration < 1 || price < 1) return -1;
	return price / duration;
}

boolean[item] effect_to_items(effect ef)
{
	//this function tells you which items can be used to provide an effect.
	boolean[item] retval;
	item it;
	foreach s in ef.all
	{
		if(s.contains_text("use 1 "))
		{
			it = to_item(s.replace_string("use 1 ", ""));
			retval[it] = true;
		}
	}
	return retval;
}

item best_potion(effect ef)
{
	//determines the best (in terms of meat per adv) mall buyable potion available to produce effect ef
	//if none exists returns $item[none]
	//TODO also check NPC store items
	item retval = $item[none];
	float best_cost = -1;
	foreach it in effect_to_items(ef)
	{
		if(!auto_is_valid(it)) continue;
		if(can_use(it) != "") continue;					//specifies why you can not use an item. "" means you can use it.
		if(!it.tradeable || !it.usable) continue;		//it is not tradeable or not useable. skip it
		if(it.fullness + it.inebriety + it.spleen > 0) continue;		//it requires organ space. skip it
		if(it.levelreq > my_level()) continue;			//it can not be used due to level requirement. skip it
		if(auto_mall_price(it) > get_property("autoBuyPriceLimit").to_int()) continue;		//it is too expensive. skip.
		float cost = price_per_adv(it);
		if(cost == -1) continue;		//it cannot be priced. what is wrong with it? skip it and go to next item.
		
		if(cost > 0 && (best_cost == -1 || cost < best_cost))
		{
			retval = it;
			best_cost = cost;
		}
	}
	return retval;
}

float total_buff_cost()
{
	//returns the current cost per adv of all buffs currently applied. currently only counts potions. TODO calculate skills too.
	float retval = 0;
	foreach ef in $effects[]
	{
		if(have_effect(ef) == 0) continue;		//I do not have this effect so skip to next effect.
		item it = best_potion(ef);
		if(it != $item[none])
		{
			retval += price_per_adv(it);
		}
	}
	return retval;
}

void pl_buff_mainstat(int target)
{
	//buffs mainstat up to a target value. once target is exceeded we stop
	
	int bonus(item it, stat s)
	{
		//returns the expect bonus to buffed primestat you will recieve from consuming item it.
		if(have_effect(effect_modifier(it, "effect")) > 0)
		{
			return 0;	//we already have this buff. we will not gain any extra bonus for extending its duration
		}
		
		int bonus_percent = my_basestat(s) * (numeric_modifier(effect_modifier(it, "effect"), s.to_string() + " percent") / 100);
		int bonus_flat = numeric_modifier(effect_modifier(it, "effect"), s.to_string());
		return bonus_percent + bonus_flat;
	}
	
	//wear suitable equipment
	addToMaximize("50" +my_primestat().to_string());
	equipMaximizedGear();
	
	//todo buff using skills. this can be hardcoded
	foreach ef in $effects[					//all-stat bonuses
	Big,									//+20% all. 1.5 MP/adv
	Stevedave's Shanty of Superiority,		//+10% all. song. 30 MP (duration varies).
	Leash of Linguini						//+5 familiar weight. 1.2 MP/adv
	//Song of Bravado						//+15% all. 10MP per adv. too expensive. do not use until exact calculations are added.
	] { buffMaintain(ef, 0, 1, 1); }
	
	switch(my_primestat())					//mainstat only bonuses
	{
	case $stat[muscle]:
		foreach ef in $effects[
		Quiet Determination,				//+25% mus. facial expression. 1 MP/adv
		Rage of the Reindeer,				//+10% mus. +10 weapon dmg. 1 MP/adv
		Power Ballad of the Arrowsmith,		//+10 mus. +20 maxHP. song. 5 MP (duration varies).
		Seal Clubbing Frenzy,				//+2 mus. 0.2 MP/adv
		Patience of the Tortoise,			//+1 mus. +3 maxHP. 0.2 MP/adv
		] { buffMaintain(ef, 0, 1, 1); }
		break;
	case $stat[mysticality]:
		foreach ef in $effects[
		Quiet Judgement,					//+25% mys. facial expression. 1 MP/adv
		The Magical Mojomuscular Melody,	//+10 mys. +20 maxMP. song. 3 MP (duration varies).
		Pasta Oneness,						//+2 mys. 0.2 MP/adv
		Saucemastery,						//+1 mys. +3 maxMP. 0.2 MP/adv
		] { buffMaintain(ef, 0, 1, 1); }
		break;
	case $stat[moxie]:
		foreach ef in $effects[
		Quiet Desperation,					//+25% mox. facial expression. 1 MP/adv
		The Moxious Madrigal,				//+10 mox. song. 2 MP (duration varies).
		Disco State of Mind,				//+2 mox. 0.2 MP/adv
		Mariachi Mood,						//+1 mox. +3 maxHP. 0.2 MP/adv
		] { buffMaintain(ef, 0, 1, 1); }
		break;
	}
	
	//try to buff using potions
	while(my_buffedstat(my_primestat()) < target)
	{
		//float x = 1/2 = 0. You need to convert the int to float before performing division. float x = 1.0/2 = 0.5.
		//so use float to store all values. even integer values
		item best_item = $item[none];
		float best_value = 0;	//value = bonus/cost. track this seperately to avoid divide by zero
		float best_bonus = 0;
		float best_cost = 0;
		foreach it in $items[]
		{
			if(!auto_is_valid(it)) continue;
			if(can_use(it) != "") continue;					//specifies why you can not use an item. "" means you can use it.
			if(!it.tradeable || !it.usable) continue;		//it is not tradeable or not useable. skip it
			if(it.fullness + it.inebriety + it.spleen > 0) continue;		//it requires organ space. skip it
			if(it.levelreq > my_level()) continue;			//it can not be used due to level requirement. skip it
			
			//calculate buff bonus. if any
			float bonus = bonus(it, my_primestat());
			float to_target = target - my_buffedstat(my_primestat());
			if(bonus > to_target) bonus = to_target;		//if we are only 10 short of goal and it provides +100. count it as providing 10.
			if(bonus < 1) continue;			//it does not provide a bonus to my primestat. skip it and go to next item.
			
			//calculate price. mallchecks are delayed until this point to minimize mall hits for things that we do not want for other reasons.
			if(auto_mall_price(it) > get_property("autoBuyPriceLimit").to_int()) continue;		//it is too expensive. skip.
			float cost = price_per_adv(it);
			if(cost == -1) continue;		//it cannot be priced. what is wrong with it? skip it and go to next item.
			
			if((bonus/cost) > best_value)
			{
				best_item = it;
				best_cost = cost;
				best_bonus = bonus;
				best_value = bonus/cost;
			}
		}
		
		if(best_item == $item[none])
		{
			print("could not find an item to consume for a buff despite not reaching the target of " +target);
			break;
		}
		float adv_cost = (auto_mall_price(MAGAZINE) / 30) + get_property("plevel_mpa").to_int() + total_buff_cost();
		float adv_value = my_buffedstat(my_primestat()) / adv_cost;
		print("best item = " +best_item+ ". cost per adv = " +best_cost+ ". mainstat bonus = " +best_bonus+ ". value = " +best_value);
		print("cost of an adventure = magazine cost + mpa + total current buff cost = " +adv_cost+ ". value = " + adv_value);
		if(best_value < adv_value)
		{
			print("I have not reached target buff of " +target+ ". But the best item I found costs more meat than just using more magazines. So I am giving up", "red");
			break;
		}
		if(!retrieve_item(1, best_item))
		{
			abort("Mysteriously failed to acquire the item [" +best_item+ "]");
		}
		if(!use(1, best_item))
		{
			abort("Mysteriously failed to apply buff using the item [" +best_item+ "]");
		}
	}
}

void use_gameinform_magazine()
{
	//uses a gameinform magazine to unlock gameinform dungeon.
	if(item_amount(WALKTHROUGH) > 0) return;	//already have an unfinished gameinform dungeon

	retrieve_item(1, MAGAZINE);
	//using gameinform magazine opens a mini window (not considered a choiceAdventure) where you need to click [Read it] to actually read it.
	//you can navigate away from that mini window.
	use(1, MAGAZINE);												//"use" in inventory
	visit_url("inv_use.php?pwd=&confirm=Yep.&whichitem=6174");		//press [Read it] button
	run_choice(1);													//press [Awesome!] button
	
	set_property("_gameinform_zonesFinished", "0");		//internal tracking because mafia does not track gameinform progress.
}

boolean pl_gameinform()
{
	//powerlevel in gameinform dungeon
	use_gameinform_magazine();		//unlocks the gameinform dungeon if needed by acquiring and using a gameinform magazine
	pl_buff_mainstat(10000);		//buff mainstat. to a max value of 10,000
	
	print("last encounter = " +get_property("lastEncounter"), "blue");
	print("adventuring in video game dungeon", "blue");
	boolean advResult = false;
	switch(get_property("_gameinform_zonesFinished").to_int())
	{
	case 0:
		advResult = autoAdv($location[Video Game Level 1]);
		if(!advResult)
		{
			set_property("_gameinform_zonesFinished", "1");
			return true;
		}
		break;
	case 1:
		advResult = autoAdv($location[Video Game Level 2]);
		if(!advResult)
		{
			set_property("_gameinform_zonesFinished", "2");
			return true;
		}
		break;
	case 2:
		advResult = autoAdv($location[Video Game Level 3]);
		if(get_property("lastEncounter") == "A Gracious Maze")
		{
			visit_url("place.php?pwd&whichplace=faqdungeon");
			return true;
		}
		if(!advResult)
		{
			set_property("_gameinform_zonesFinished", "3");
			return true;
		}
		break;
	}
	
	return advResult;
}

void pl_fortuneConsume()
{
	if(contains_text(get_counters("Fortune Cookie", 0, 200), "Fortune Cookie"))
	{
		return;
	}

	// Try to consume a Lucky Lindy
	if(inebriety_left() > 0 && canDrink($item[Lucky Lindy]) && my_meat() >= npc_price($item[Lucky Lindy]))
	{
		if(autoDrink(1, $item[Lucky Lindy]))
		{
			return;
		}
	}

	// Try to consume a Fortune Cookie
	if(fullness_left() > 0 && canEat($item[Fortune Cookie]) && my_meat() >= npc_price($item[Fortune Cookie]))
	{
		// Eat a spaghetti breakfast if still consumable
		if(canEat($item[Spaghetti Breakfast]) && item_amount($item[Spaghetti Breakfast]) > 0 && my_fullness() == 0 && my_level() >= 10)
		{
			if(!autoEat(1, $item[Spaghetti Breakfast]))
			{
				return;
			}
		}

		buyUpTo(1, $item[Fortune Cookie], npc_price($item[Fortune Cookie]));
		if(autoEat(1, $item[Fortune Cookie]))
		{
			return;
		}
	}
}

boolean pl_doTasks()
{
	auto_interruptCheck();
	//pl_fortuneConsume();	//consume fortune cookie or lucky lindy to find out semirare. disabled until setting is made for it
	
	if(my_adventures() == 0)
	{
		print("out of adventures");
		return false;
	}
	if(my_familiar() == $familiar[Stooper])
	{
		auto_log_info("Avoiding stooper stupor...", "blue");
		use_familiar($familiar[Mosquito]);
	}
	if(my_inebriety() > inebriety_limit())
	{
		auto_log_warning("I am overdrunk", "red");
		return false;
	}
	if(my_meat() < 10000)
	{
		auto_log_warning("I am way too poor to powerlevel. I only have " +my_meat()+ " meat.", "red");
		return false;
	}
	
	resetState();
	handleFamiliar($familiar[hovering sombrero]);
	
	if(pl_fortuneCollect()) return true;
	if(LX_freeCombats(true)) return true;
	if(pl_gameinform()) return true;
	
	return false;
}

void pl_start(int target_level)
{
	//This also should set our path too.
	string page = visit_url("main.php");
	page = visit_url("api.php?what=status&for=4", false);
	
	initializeSettings();		//initialize autoscend once per ascension.
	
	backupSetting("printStackOnAbort", true);
	backupSetting("promptAboutCrafting", 0);
	backupSetting("breakableHandling", 4);
	backupSetting("dontStopForCounters", true);
	backupSetting("afterAdventureScript", "scripts/autoscend/auto_post_adv.ash");
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
	
	//primary loop
	try
	{
		while(my_level() < target_level && pl_doTasks());
	}
	finally
	{	
		restoreAllSettings();
	}
}

void main(int target_level)
{
	tt_initialize();		//configures ttpack settings to default values on first run and removes depreciated settings.
	
	if(!can_interact())
	{
		abort("We appear to still be in run. This script is designed for aftercore or casual only.");
	}
	
	try
	{
		pl_start(target_level);
	}
	finally
	{
		if(my_level() >= target_level)
		{
			print("Power leveling was a success. We are now level " +my_level()+ " and our target was " +target_level,"blue");
		}
		else
		{
			print("Power leveling failed to reach target. We are now level " +my_level()+ " and our target was " +target_level,"red");
		}
	}
}