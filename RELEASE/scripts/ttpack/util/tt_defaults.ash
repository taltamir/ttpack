//used to set the default values for the various ttpack scripts

void tt_login_settings_defaults()
{
	//set defaults
	if(get_property("tt_login_pvp") == "")
	{
		set_property("tt_login_pvp", true);
	}
	if(get_property("tt_login_chocolateEat") == "")
	{
		set_property("tt_login_chocolateEat", true);
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

void tt_initialize()
{
	//initialize settings defaults for all associated scripts
	tt_depreciate();						//remove depreciated settings
	tt_login_settings_defaults();			//initialize default settings for tt_login
}