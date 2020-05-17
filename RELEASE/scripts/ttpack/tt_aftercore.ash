void chooseFamiliar()
{
	if(have_familiar($familiar[Lil\' Barrel Mimic]));
	{
		use_familiar($familiar[Lil\' Barrel Mimic]);
	}
}

boolean tt_acquire(item it)
{
	if(item_amount(it) > 0) return true;
	
	int expected_price = mall_price(it);
	//TODO add store price
	
	if(my_meat()+20000 > expected_price)
	{
		buy(1, it, expected_price);
		if(item_amount(it) > 0) return true;
	}
	
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
	meatfarm();
}