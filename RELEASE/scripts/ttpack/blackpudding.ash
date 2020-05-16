/*
a script to farm black pudding fights for Awwww, Yeah trophy.

That trophy requires you to defeat 240 black puddings (the monster). You do this by eating roughly 450 black puddings (the food) which is trash food of size 3. Every time you try to eat the food, there is a 35% chance that you will fight the monster, and a 65% chance that you will eat the food.

There is a trick with the dark gyffte path. If a vampyre tries to eat a pudding there is a 35% chance of them fighting the monster, and a 65% chance of them harmlessly being told vampyres only eat blood. So if you have 240 adventures, you can do this trophy in one day by just repeatedly attempting to eat it as a vampyre.

You can either run this script from gCLI by using
pudding X
to fight X puddings

Or you can click on it from the dropdown scripts menu to be asked how many fights you want.
The script will repeatedly attempt to eat puddings until the quantity you specified has been reached.
*/

void main(int how_many_black_pudding_fights)
{
//if you run it without defining the variables for main, mafia asks you to input a value. this cumbersome variable name makes it self documenting.
int qty = how_many_black_pudding_fights;

//avoid infinite loop by making sure requested fights is not higher than adv remaining
if (my_adventures() < qty)
	qty = my_adventures();
	
//only do stuff if a vampyre
if (my_class() != $class[Vampyre])
	{
	print("You need to be a Vampyre for this script" , "red");
	exit;
	}

//avoid infinite loop by making sure fullness is low enough to try and eat black pudding
if (my_class() == $class[Vampyre] && my_fullness() > 2)
	{
	print("Your fullness is already at " + my_fullness() + " out of 5, you need 3 empty stomach space for this script to work" , "red");
	exit;
	}

//while function to repeatedly eat black pudding and fight them.
while (qty > 0)
    {
	print("trying to fight a pudding");
	visit_url("inv_eat.php?whichitem=2338&pwd");
    string page_text = visit_url("main.php");
    if(page_text.contains_text("Combat"))
        {
        run_combat();
        qty--;
		print();
        }
	else print("no fight detected... retrying");
	
	//notify when done running
	if (qty == 0)
		print("Done running Pudding script", "green");
	
	//stop the loop if you already got enough for the trophy
	if(get_property("blackPuddingsDefeated") > "239")
		{
		qty = 0;
		print("You have defeated enough Black Puddings to recieve the trophy", "green");
		}
    }
}