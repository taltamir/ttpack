//used to set the default values for the various ttpack scripts

void set_default(string prop, string val)
{
	//this function is used to configure default values. it only makes a change if the current value is nothing
	if(!property_exists(prop))
	{
		print(prop+ " has no value set. setting it to the default value of " +val);
		set_property(prop,val);
	}
}

void settings_tt_login()
{
	//configure default settings on first run for tt_login.ash script
	set_default("tt_login_pvp", "true");
	set_default("tt_login_chocolateEat", "true");
	set_default("tt_login_auto", "false");
	set_default("tt_login_chocolateMaxPricePerAdv", "100");
	set_default("tt_login_startQuestLTT", "true");
	set_default("tt_login_startQuestLTTDifficulty", "3");
	
	if(get_property("tt_login_chocolateMaxPricePerAdv").to_int() < 1)
	{
		set_property("tt_login_chocolateMaxPricePerAdv", 100);
	}
	if(get_property("tt_login_startQuestLTTDifficulty").to_int() < 1 || get_property("tt_login_startQuestLTTDifficulty").to_int() > 3)
	{
		set_property("tt_login_startQuestLTTDifficulty", 3);
	}
}

void settings_tt_logout()
{
	set_default("tt_logout_pvp_aftercore", "false");
	set_default("tt_logout_pvp_ascend", "false");
	set_default("tt_logout_pvp_overdrunk", "true");
}

void settings_greygoo()
{
	//configure default settings on first run for greygoo.ash script
	set_default("greygoo_galaktikQuest", "true");
	set_default("greygoo_foodHardcoreUnlock", "true");
	set_default("greygoo_foodSoftcoreUnlock", "true");
	set_default("greygoo_fortuneHardcore", "true");
	set_default("greygoo_fortuneSoftcore", "true");
	set_default("greygoo_oddJobs", "false");
	set_default("greygoo_fightGoo", "true");
}

void settings_plevel()
{
	//configure default settings on first run for plevel.ash script
	set_default("plevel_mpa", "500");
}

void settings_aftercore()
{
	//configure default settings on first run for aftercore.ash script
	set_default("aftercore_fatLootToken", "true");
	set_default("aftercore_iceHouseAMC", "true");
	set_default("aftercore_guildUnlock", "false");
	set_default("aftercore_meatFarm", "false");
	set_default("aftercore_useAstralLeftovers", "true");
	set_default("aftercore_buyExpensive", "false");
	set_default("aftercore_buyExpensiveLimit", "100000");
	set_default("aftercore_getChefstaff", "false");
	set_default("aftercore_eatSurpriseEggs", "false");
	set_default("aftercore_consumeAll", "false");
}

void settings_qpvp()
{
	set_default("qpvp_maximize", "item");
	set_default("qpvp_reward", "flowers");
	if( !($strings[flowers,loot,fame] contains get_property("qpvp_reward")) )
	{
		print("invalid string detected in qpvp_reward. resetting to default value","red");
		set_property("qpvp_reward", "flowers");
	}
}

void tt_initialize()
{
	//initialize settings defaults for all associated scripts
	tt_depreciate();				//remove depreciated settings
	tt_settingsUpgrade();			//upgrade settings from old format to new format
	settings_tt_login();			//initialize default settings for tt_login
	settings_tt_logout();			//initialize default settings for tt_logout
	settings_greygoo();				//initialize default settings for greygoo
	settings_plevel();				//initialize default settings for plevel
	settings_aftercore();			//initialize default settings for aftercore
	settings_qpvp();				//initialize default settings for qpvp
}
