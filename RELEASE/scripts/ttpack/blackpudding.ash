/*
a script to farm black pudding fights for Awwww, Yeah trophy.

That trophy requires you to defeat 240 black puddings (the monster). You do this by eating roughly 450 black puddings (the food) which is trash food of size 3. Every time you try to eat the food, there is a 35% chance that you will fight the monster, and a 65% chance that you will eat the food.

There is a trick with the dark gyffte path. If a vampyre tries to eat a pudding there is a 35% chance of them fighting the monster, and a 65% chance of them harmlessly being told vampyres only eat blood. So if you have 240 adventures, you can do this trophy in one day by just repeatedly attempting to eat it as a vampyre.

Make sure to set mood, CCS, and outfit so you can defeat the puddings without getting beaten up.

You can either run this script from gCLI by using
blackpudding X
to fight X puddings

Or you can click on it from the dropdown scripts menu to be asked how many fights you want.
The script will repeatedly attempt to eat puddings until the quantity you specified has been reached.
*/

void main(int how_many_black_pudding_fights)
{
	//if you run it without defining the variables for main, mafia asks you to input a value.
	//this cumbersome variable name makes it clear to the user what they are being asked for
	int qty = how_many_black_pudding_fights;

	//avoid infinite loop by making sure requested fights is not higher than adv remaining
	qty = min(qty,my_adventures());
	
	if(my_class() != $class[Vampyre])
	{
		abort("You need to be a Vampyre for this script");
	}
	if(my_fullness() > 2)
	{
		abort("Your fullness is already at " + my_fullness() + " out of 5, you need 3 empty stomach space for this script to work");
	}

	//while function to repeatedly eat black pudding and fight them.
	while(qty > 0)
    {
		print("trying to fight a pudding");
		visit_url("inv_eat.php?whichitem=2338&pwd");
		string page_text = visit_url("main.php");
		if(page_text.contains_text("Combat"))
        {
			run_combat();
			qty--;
			print();
			if(have_effect($effect[Beaten Up]) > 0)
				abort("I got beaten up. Make sure to set mood, CCS, and outfit so you can defeat the puddings without getting beaten up");
        }
		else print("this attempt did not yield combat");
	
		if(qty == 0) print("Done running Pudding script", "green");
	
		if(get_property("blackPuddingsDefeated") > "239")	//have enough for trophy
		{
			qty = 0;
			print("You have defeated enough Black Puddings to recieve the trophy", "green");
		}
    }
}