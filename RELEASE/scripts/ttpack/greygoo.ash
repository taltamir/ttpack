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
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
	print();
}

boolean greygoo_guild(boolean override)
{
	if(!get_property("greygoo_guildUnlock").to_boolean() && !override)
	{
		return false;
	}
	if($classes[Seal Clubber, Turtle Tamer] contains my_class())
	{
		return false;	//muscle classes cannot unlock guild in grey goo
	}
	
	return LX_guildUnlock();	//autoscend function
}

boolean greygoo_doTasks()
{
	consumeStuff();
	
	if(my_adventures() == 0)
	{
		print("out of adventures");
		return false;
	}
	
	if(greygoo_guild(false)) return true;
	
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