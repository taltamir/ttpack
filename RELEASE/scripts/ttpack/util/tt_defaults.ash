//used to set the default values for the various ttpack scripts

void settings_tt_login()
{
	//configure default settings on first run for tt_login.ash script
	if(get_property("tt_login_pvp") == "")
	{
		set_property("tt_login_pvp", true);
	}
	if(get_property("tt_login_chocolateEat") == "")
	{
		set_property("tt_login_chocolateEat", true);
	}
	if(get_property("tt_login_auto") == "")
	{
		set_property("tt_login_auto", false);
	}
	if(get_property("tt_login_chocolateMaxPricePerAdv") == "" || get_property("tt_login_chocolateMaxPricePerAdv").to_int() < 1)
	{
		set_property("tt_login_chocolateMaxPricePerAdv", 100);
	}
	if(get_property("tt_login_startQuestLTT") == "")
	{
		set_property("tt_login_startQuestLTT", true);
	}
	if(get_property("tt_login_startQuestLTTDifficulty") == "" || get_property("tt_login_startQuestLTTDifficulty").to_int() < 1 || get_property("tt_login_startQuestLTTDifficulty").to_int() > 3)
	{
		set_property("tt_login_startQuestLTTDifficulty", 3);
	}
}

void settings_greygoo()
{
	//configure default settings on first run for greygoo.ash script
	if(get_property("greygoo_galaktikQuest") == "")
	{
		set_property("greygoo_galaktikQuest", true);
	}
	if(get_property("greygoo_foodHardcoreUnlock") == "")
	{
		set_property("greygoo_foodHardcoreUnlock", true);
	}
	if(get_property("greygoo_foodSoftcoreUnlock") == "")
	{
		set_property("greygoo_foodSoftcoreUnlock", true);
	}
	if(get_property("greygoo_fortuneHardcore") == "")
	{
		set_property("greygoo_fortuneHardcore", true);
	}
	if(get_property("greygoo_fortuneSoftcore") == "")
	{
		set_property("greygoo_fortuneSoftcore", true);
	}
	if(get_property("greygoo_oddJobs") == "")
	{
		set_property("greygoo_oddJobs", false);
	}
	if(get_property("greygoo_fightGoo") == "")
	{
		set_property("greygoo_fightGoo", true);
	}
}

void tt_initialize()
{
	//initialize settings defaults for all associated scripts
	tt_depreciate();				//remove depreciated settings
	settings_tt_login();			//initialize default settings for tt_login
}