//This script should be set to auto run on pre-ascension

import <scripts/ttpack/util/tt_util.ash>

boolean needExtraAdv()
{
	//do we have a way to burn extra adv. such as combing the beach.
	if(auto_beachCombAvailable())
	{
		return true;
	}
	
	return false;
}

void useBorrowedTime()
{
	if(get_property("_borrowedTimeUsed").to_boolean())
	{
		return;		//can only use once a day
	}
	if(!needExtraAdv())
	{
		return;
	}
	use(1,$item[borrowed time]);
}

void pa_consume()
{
	//fill up liver and stomach before ascending
	if(my_path() == "Grey Goo")
	{
		return;		//grey goo is problematic. do not try to consume before ascending in it.
	}
	
	//use stooper to increase liver size by 1 temporarily
	familiar start_fam = my_familiar();
	if(inebriety_left() >= 0 &&
	auto_have_familiar($familiar[Stooper]) && //drinking does not break 100fam runs so do not use canChangeToFamiliar
	start_fam != $familiar[Stooper] && pathAllowsChangingFamiliar()) //check if path allows changing familiar
	{
		use_familiar($familiar[Stooper]);
	}
	
	//TODO eat and drink things to unlock trophies.
	
	tt_eatSurpriseEggs();	//fill up stomach with lucky and spooky surprise eggs. based on setting aftercore_eatSurpriseEggs
	
	if(needExtraAdv())		//use remaining space to eat and drink things to gian adventures
	{
		//TODO use distension and diet pills.
		int drink_amt = inebriety_left();
		
		if(!get_property("_mimeArmyShotglassUsed").to_boolean() && item_amount($item[mime army shotglass]) > 0)
		{
			drink_amt++;
		}
		if(drink_amt > 0)
		{
			autoDrink(drink_amt, $item[elemental caipiroska]);
		}
		
		//fill up remaining liver first. such as stooper space.
		while(inebriety_left() > 0 && auto_autoConsumeOne("drink"));
		
		//nightcap
		if(item_amount($item[bucket of wine]) == 0 && shop_amount($item[bucket of wine]) > 0)
		{
			take_shop(1, $item[bucket of wine]);
		}
		retrieve_item(1,$item[bucket of wine]);
		buffMaintain($effect[Ode to Booze],0,1,10);	//need at least 10 turns worth of ode
		drinksilent(1, $item[bucket of wine]);
	}
	
	//switch back from stooper to 100% familiar if one has been set
	if(start_fam != my_familiar() && pathAllowsChangingFamiliar())	//familiar can change when crafting the drink in QT
	{
		use_familiar(start_fam);
	}
}

string[int] invertIntString(int[string] source)
{
	//invert an int[string] into a string[int]. use with caution as it will mangle the data if the int values are not unique.
	string [int] retval;
	foreach s, i in source
	{
		retval[i] = s;
	}
	return retval;
}

void pa_pvp()
{
	//if you accidentally entered valhalla without using all your pvp then use them now.
	if(pvp_attacks_left() == 0)
	{
		return;
	}
	if(!(invertIntString(current_pvp_stances()) contains 1))
	{
		print("PVP does not appear to be available. Skipping", "red");
		return;
	}

	cli_execute("maximize food drop");		//prepare outfit
	cli_execute("pvp flowers 0");			//burn remaining pvp fights. set for average season.
}

void KGB()
{
	if(!possessEquipment($item[Kremlin\'s Greatest Briefcase]))
	{
		return;
	}
	cli_execute("briefcase unlock");		//unlock the briefcase using ezandora script (must be installed seperately)
	cli_execute("briefcase collect");		//collect 3x epic drinks using ezandora script (must be installed seperately)
}

void combBeach()
{
	if(!auto_beachCombAvailable())
	{
		return;
	}
	while(my_adventures() > 0)
	{
		string command = "combbeach " + my_adventures();
		cli_execute(command);				//burn all remaining adventures on beach combing before ascension.
	}
}

void main()
{
	if(my_path() == "Grey Goo")		//greygoo does not break ronin but still allows you to enter gash on day3
	{
		if(my_daycount() < 3)
		{
			int remaining_days = 3-my_daycount();
			abort("You need to wait " + remaining_days + " more days before you can ascend");
		}
	}
	else if(!inAftercore())
	{
		abort("Accidentally tried to run pre-ascension script without being in aftercore");
	}
	
	tt_depreciate();
	cli_execute("tt_login.ash");			//do various login things. such as mafia breakfast script
	cli_execute("tt_logout.ash");			//do various logout things.
	useBorrowedTime();						//use borrowed time. only if you need extra adventures
	pa_consume();							//fill up liver and stomach before ascending
	
	KGB();									//Do some briefcase things before ascension.
	combBeach();							//burn all remaining adventures on beach combing before ascension.
	pa_pvp();								//using remaining pvp fights.
	
	if(my_path() == "Grey Goo")
	{
		print("pre-ascension script finished", "green");
		return;		//everything below this line errors in grey goo.
	}
	
	if(have_shop())
	{
		cli_execute("OCDInv.ash");			//run OCD inventory control script (must be installed seperately)
	}
	cli_execute("Rollover Management.ash");			//runs the rollover management script (must be installed seperately)
	cli_execute("tt_logout.ash");			//runs the tt_logout script (must be installed seperately)
	tt_snapshot();							//runs the cc snapshot script (must be installed seperately)
	
	print("pre-ascension script finished", "green");
}