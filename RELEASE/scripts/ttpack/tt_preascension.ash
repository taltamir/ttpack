//This script should be set to auto run on pre-ascension

import <scripts/ttpack/util/tt_util.ash>

void displayTake()
{
	if(!have_display()) return;
	
	int instant_karma_to_take = 0;
	if(display_amount($item[instant karma]) > 1)
	{
		instant_karma_to_take = min(10, (display_amount($item[instant karma]) - 1));
	}
	if(instant_karma_to_take > 0)
	{
		take_display(instant_karma_to_take, $item[instant karma]);
	}
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

void KGB()
{
	if(!possessEquipment($item[Kremlin\'s Greatest Briefcase]))
	{
		return;
	}
	cli_execute("briefcase unlock");		//unlock the briefcase using ezandora script (must be installed seperately)
	cli_execute("briefcase collect");		//collect 3x epic drinks using ezandora script (must be installed seperately)
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
	
	cli_execute("tt_fortune.ash");			//reply and send zatara fortune teller requests
	if(pvp_attacks_left() > 0)				//if you accidentally entered valhalla without using all your pvp
	{
		cli_execute("outfit pvp");			//wear pvp outfit
		cli_execute("pvp flowers 0");		//burn remaining pvp fights. set for average season.
	}
	cli_execute("breakfast");				//run mafia's built in breakfast script to do many things.
	KGB();									//Do some briefcase things before ascension.
	combBeach();							//burn all remaining adventures on beach combing before ascension.
	if(have_shop())
	{
		cli_execute("OCDInv.ash");			//run OCD inventory control script (must be installed seperately)
	}
	cli_execute("Rollover Management.ash");			//runs the rollover management script (must be installed seperately)
	tt_snapshot();							//runs the cc snapshot script (must be installed seperately)
	set_property("recoveryScript", "");		//set recovery script to none before ascending
	displayTake();							//take certain items from display so you could use them.
}