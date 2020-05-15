/*
a script to farm distention pill and synthetic dog hair pill
https://kol.coldfront.net/thekolwiki/index.php/Distention_pill
https://kol.coldfront.net/thekolwiki/index.php/Synthetic_dog_hair_pill

You can either run this script from gCLI by using
dpills X
to spend X adventures farming pills
Or you can click on it from the dropdown scripts menu to be asked how many fights you want.

Do note that you are expected to have set an appropriate mood, ccs, and outfit ahead of time.

Version History
2020-01-19b actually display finishing message with pill count if you asked it to run for more adventures than you have
2020-01-19 initial version
*/




void closetTakeAll(item it)
{
int qty = closet_amount(it);
if (qty > 0)
	{
	print("taking from closet " + qty + " " + it);
	take_closet(qty, it);
	}
}

int countItem(item it)
{
	return item_amount(it) + closet_amount(it);
}

void main(int how_many_adventures_to_spend)
{
//if you run it without defining the variables for main, mafia asks you to input a value. this cumbersome variable name was chose to make it self documenting. It is then converted into a convenient variable.
int adv = how_many_adventures_to_spend;

	
//while function to process one adventure at a time
while (adv > 0)
    {
	//set target to either distention pill or synthetic dog hair pill, depending on which you have more of.
	if (countItem($item[distention pill]) <= countItem($item[synthetic dog hair pill]))
		set_property("choiceAdventure536", 1);		//get distention pill
	else
		set_property("choiceAdventure536", 2);		//get synthetic dog hair pill
	
	//extend Transpondent duration if ran out
	if (have_effect($effect[Transpondent]) == 0)
		use(1 , $item[transporter transponder]);
	
	//if for some reason you closetted a map to safety shelter of grimace prime then take it out of closet
	if (closet_amount($item[Map to Safety Shelter Grimace Prime]) > 0)
		closetTakeAll($item[Map to Safety Shelter Grimace Prime]);
	
	//if you have a map to safety shelter of grimace prime in your inventory then use it. If you don't have a map then spend 1 adventure on combat trying to get a map. Unless only 1 adventure is left in which case do not try to get a map, as it is a quest item that takes 1 adventure to use
	if (item_amount($item[Map to Safety Shelter Grimace Prime]) > 0)
		use(1, $item[Map to Safety Shelter Grimace Prime]);
	else if (adv > 1)
		adventure(1,$location[Domed City of Grimacia]);
		
	//reduce adv by 1 now that actions have been taken, if actions didn't get taken, still reduce it so that it won't infinite loop.
	adv--;
	
	//stop the loop if you ran out of adventures. This is checked repeatedly as part of the loop because you might have acquired additional adventures from things like mafia thumb ring.
	if (my_adventures() == 0)
		adv = 0;
    }
	
	//notify when done running
	if (adv == 0)
		{
		print("Done running DPills script", "green");
		print("distention pill: " + countItem($item[distention pill]), "green");
		print("synthetic dog hair pill: " + countItem($item[synthetic dog hair pill]), "green");
		}
}