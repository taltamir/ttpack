import <ttpack/tt_util.ash>

void tt_chooseFamiliar()
{
	if(have_familiar($familiar[Lil\' Barrel Mimic]));
	{
		use_familiar($familiar[Lil\' Barrel Mimic]);
	}
}

boolean tt_iceHouse()
{
	//2020-05-17 refresh icehouse status. mafia often thinks it is empty when it is not. maybe because it is out of standard?
	//http://127.0.0.1:60083/museum.php?action=icehouse
	return false;
}

boolean tt_fatLootToken()
{
	return false;
}

boolean tt_meatFarm()
{
	//castle in the sky NCs
	set_property("choiceAdventure675", 1);
	set_property("choiceAdventure676", 4);
	set_property("choiceAdventure677", 4);
	set_property("choiceAdventure678", 2);
	set_property("currentMood", "meat");

	string maximizer_string = "meat,effective";
	if(tt_acquire($item[mafia thumb ring]))
	{
		maximizer_string += ",+equip mafia thumb ring";
	}
	maximize(maximizer_string, false);

	return adv1($location[The Castle in the Clouds in the Sky (Top Floor)], -1, "");
}

boolean tt_doTasks()
{
	//main loop of tt_aftercore. returning true resets the loop. returning false exists the loop
	
	if(tt_iceHouse()) return true;
	if(tt_fatLootToken()) return true;
	if(tt_meatFarm()) return true;
	return false;
}

void main()
{
	tt_chooseFamiliar();
	
	//main loop is doTasks which is run as part of the while.
	while(auto_unreservedAdvRemaining() && tt_doTasks());
}