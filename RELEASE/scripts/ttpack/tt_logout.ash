//This script should be set to auto run on logout

import <scripts/ttpack/util/tt_util.ash>

void whenDrunk()
{
	if(can_drink() && my_inebriety() <= inebriety_limit())
	{
		return;		//not overdrunk yet so do not run this function.
	}
	
	if(auto_have_skill($skill[Summon Clip Art]) && get_property("_clipartSummons").to_int() < 3)
	{
		if(item_amount($item[bucket of wine]) == 0)
		{
			cli_execute("make bucket of wine");
		}
		int clipart_left = 3 - get_property("_clipartSummons").to_int();
		if(clipart_left > 0)
		{
			cli_execute("make " + clipart_left + " borrowed time");
		}
	}
	
	if(auto_have_skill($skill[Incredible Self-Esteem]) && !get_property("_incredibleSelfEsteemCast").to_int().to_boolean())
	{
		use_skill(1, $skill[Incredible Self-Esteem]);
	}
}

void main()
{
	cli_execute("breakfast");				//Run mafia built in breakfast script to do many daily tasks
	cli_execute("tt_fortune.ash");			//reply and send zatara fortune teller requests
	cli_execute("pvprotect.ash");			//closet your expensive pvpable items
	whenDrunk();							//actions we only want to take if overdrunk on logout
}