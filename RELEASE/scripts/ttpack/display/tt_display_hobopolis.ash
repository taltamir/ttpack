//DO NOT RUN THIS FILE

void hobo_settings()
{
	boolean new_setting_added = false;
	
	//set defaults
	if(get_property("tt_display_hobopolis_zapDailyLimit") == "" || get_property("tt_display_hobopolis_zapDailyLimit").to_int() < 0)
	{
		new_setting_added = true;
		set_property("tt_display_hobopolis_zapDailyLimit", 1);
	}

	//print current settings status
	print("tt_display_hobopolis_zapDailyLimit = " + get_property("tt_display_hobopolis_zapDailyLimit"), "blue");
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
	
	if(new_setting_added)
	{
		abort("Settings have been configured to default. Please verify they are correct before running me again");
	}
}

boolean hobo_zapping()
{
	if(get_property("tt_display_hobopolis_zapDailyLimit").to_int() >= get_property("_zapCount").to_int())
	{
		print("Daily zap limit reached");
		return false;
	}
	if(my_ascensions() > get_property("lastZapperWand").to_int())
	{
		print("You do not have a zap wand");
		return false;
	}
	
	return false;	
}

void manageHoboItems()
{
	hobo_settings();
	hobo_zapping();
}