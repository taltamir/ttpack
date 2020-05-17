import <ttpack/tt_util.ash>

void chooseFamiliar()
{
	if(have_familiar($familiar[Lil\' Barrel Mimic]));
	{
		use_familiar($familiar[Lil\' Barrel Mimic]);
	}
}

boolean iceHouse()
{
	//2020-05-17 refresh icehouse status. mafia often thinks it is empty when it is not. maybe because it is out of standard?
	//http://127.0.0.1:60083/museum.php?action=icehouse
	return false;
}

void meatfarm()
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

	adv1($location[The Castle in the Clouds in the Sky (Top Floor)], -1, "");
}

void main()
{
	chooseFamiliar();
	iceHouse();
	meatfarm();
}