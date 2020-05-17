//DO NOT RUN THIS FILE

void hobo_settings()
{
	boolean new_setting_added = false;
	
	//set defaults
	if(get_property("tt_display_hobopolis_allowZapping") == "")
	{
		new_setting_added = true;
		set_property("tt_display_hobopolis_allowZapping", true);
	}

	//print current settings status
	print("tt_display_hobopolis_allowZapping = " + get_property("tt_display_hobopolis_allowZapping"), "blue");
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
	
	if(new_setting_added)
	{
		abort("Settings have been configured to default. Please verify they are correct before running me again");
	}
}

void manageHoboItems()
{
	hobo_settings();
}