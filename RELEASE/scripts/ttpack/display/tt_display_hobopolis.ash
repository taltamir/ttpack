//DO NOT RUN THIS FILE. it is being imported by ttpack/tt_display.ash

//prototype
void hobo_settings_print();

void hobo_settings_defaults()
{
	//set defaults for any unconfigured settings.
	
	boolean new_setting_added = false;

	if(get_property("tt_display_hobopolis_zapDailyLimit") == "" || get_property("tt_display_hobopolis_zapDailyLimit").to_int() < 0)
	{
		new_setting_added = true;
		set_property("tt_display_hobopolis_zapDailyLimit", 1);
	}

	//abort if new defaults configured and let the user go over them first.
	if(new_setting_added)
	{
		hobo_settings_print();
		abort("Settings have been configured to default. Please verify they are correct before running me again");
	}
}

void hobo_settings_print()
{
	//print current settings status
	print();
	print("Current settings for tt_display_hobopolis:", "blue");
	tt_printSetting("tt_display_hobopolis_zapDailyLimit");
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
}

boolean zapLimitReached()
{
	return get_property("tt_display_hobopolis_zapDailyLimit").to_int() >= get_property("_zapCount").to_int();
}

boolean haveZapWand()
{
	return my_ascensions() == get_property("lastZapperWand").to_int();
}

void zap_hobo_set(item it1, item it2, item it3)
{
	if(zapLimitReached())
	{
		return;
	}
	
	int amt_it1 = item_amount(it1) + closet_amount(it1) + display_amount(it1) + equipped_amount(it1);
	int amt_it2 = item_amount(it2) + closet_amount(it2) + display_amount(it2) + equipped_amount(it2);
	int amt_it3 = item_amount(it3) + closet_amount(it3) + display_amount(it3) + equipped_amount(it3);
	
	//find smallest amount
	int min_amt = min(amt_it1,amt_it2);
	min_amt = min(min_amt,amt_it3);
	
	//find largest amount. we want item too since this will be the zapped item.
	int max_amt = amt_it1;
	item max_item = it1;
	if(amt_it2 > max_amt)
	{
		max_amt = amt_it2;
		max_item = it2;
	}
	if(amt_it3 > max_amt)
	{
		max_amt = amt_it3;
		max_item = it3;
	}
	
	//need at least a difference of 2 between min and max item for zapping to make sense.
	if(max_amt - min_amt >= 2)
	{
		return;
	}
	
	if(item_amount(max_item) == 0)
	{
		if(closet_amount(max_item) > 0)
		{
			take_closet(1, max_item);
		}
		else if(display_amount(max_item) > 0)
		{
			take_display(1, max_item);
		}
		else if(equipped_amount(max_item) > 0)
		{
			cli_execute("unequip all");
		}
	}
	if(item_amount(max_item) > 0)
	{
		cli_execute("zap " + max_item);
	}
}

boolean hobo_zapping()
{
	//zapping hobopolis outfits
	
	if(zapLimitReached())
	{
		return false;
	}
	if(!haveZapWand())
	{
		print("You do not have a zap wand");
		return false;
	}
	
	item it1;
	item it2;
	item it3;
	
	//Frosty's outfit. cold
	it1 = $item[Frosty\'s old silk hat];
	it2 = $item[Frosty\'s nailbat];
	it3 = $item[Frosty\'s carrot];
	zap_hobo_set(it1,it2,it3);
	
	//Zombo's outfit. spooky
	it1 = $item[Zombo\'s skullcap];
	it2 = $item[Zombo\'s shield];
	it3 = $item[Zombo\'s grievous greaves];
	zap_hobo_set(it1,it2,it3);
	
	//Chester's outfit. sleaze
	it1 = $item[Chester\'s cutoffs];
	it2 = $item[Chester\'s bag of candy];
	it3 = $item[Chester\'s moustache];
	zap_hobo_set(it1,it2,it3);
	
	//Ol' Scratch's outfit. hot
	it1 = $item[Ol\' Scratch\'s stovepipe hat];
	it2 = $item[Ol\' Scratch\'s ash can];
	it3 = $item[Ol\' Scratch\'s ol\' britches];
	zap_hobo_set(it1,it2,it3);
	
	//Oscus's outfit. stench
	it1 = $item[Oscus\'s dumpster waders];
	it2 = $item[Wand of Oscus];
	it3 = $item[Oscus\'s pelt];
	zap_hobo_set(it1,it2,it3);
	
	//Hodgman's outfit.
	it1 = $item[Hodgman\'s porkpie hat];
	it2 = $item[Hodgman\'s lobsterskin pants];
	it3 = $item[Hodgman\'s bow tie];
	zap_hobo_set(it1,it2,it3);
	
	return false;	
}

void manageHoboItems()
{
	hobo_settings_defaults();
	hobo_zapping();
	hobo_settings_print();
}