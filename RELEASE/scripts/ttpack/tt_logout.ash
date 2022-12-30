//This script should be set to auto run on logout

import <scripts/ttpack/util/tt_util.ash>

void tt_whenDrunk()
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
	
	if(auto_have_skill($skill[Incredible Self-Esteem]) && !get_property("_incredibleSelfEsteemCast").to_boolean())
	{
		use_skill(1, $skill[Incredible Self-Esteem]);
	}
}

void tt_cargoPants()
{
	if(!auto_cargoShortsCanOpenPocket())
	{
		return;
	}
	int count(item it)
	{
		return item_amount(it) + shop_amount(it) + closet_amount(it) + display_amount(it) + storage_amount(it);
	}
	item target_it = $item[none];
	int target_amt = 0;
	foreach it in $items[onyx knight, alabaster pawn, onyx king, alabaster king, onyx pawn,  alabaster rook, onyx rook, alabaster knight, onyx queen, onyx bishop, alabaster bishop, alabaster queen]
	{
		if(!auto_cargoShortsCanOpenPocket(it))
		{
			continue;
		}
		if(target_it == $item[none] || count(it) < target_amt)
		{
			target_it = it;
			target_amt = count(it);
		}
	}
	auto_cargoShortsOpenPocket(target_it);
}

void tt_collect_on_logout()
{
	foreach sk in $skills[Acquire Rhinestones, Advanced Cocktailcrafting, Advanced Saucecrafting, Bowl Full of Jelly, Chubby and Plump, Communism!, Eye and a Twist, Grab a Cold One, Lunch Break, Pastamastery, Perfect Freeze, Prevent Scurvy and Sobriety, Request Sandwich, Spaghetti Breakfast, Summon Alice\'s Army Cards, Summon Carrot, Summon Confiscated Things, Summon Crimbo Candy, Summon Geeky Gifts, Summon Hilarious Objects, Summon Holiday Fun!, Summon Kokomo Resort Pass, Summon Tasteful Items]
	{
		if(is_unrestricted(sk) && auto_have_skill(sk) && (my_mp() >= mp_cost(sk)))
		{
			use_skill(1, sk);
		}
	}
}

void pvp_logout()
{
	//spend pvp fights on logout
	if(pvp_attacks_left() < 1)
		return;
	if(gbool("tt_logout_pvp_overdrunk") && can_drink() && my_inebriety() <= inebriety_limit())
		return;		//not overdrunk yet so do not run this function.
	boolean forbid = true;
	if(inAftercore() && gbool("tt_logout_pvp_aftercore"))
		forbid = false;
	if(!inAftercore() && gbool("tt_logout_pvp_ascend"))
		forbid = false;
	if(forbid) return;
	
	cli_execute("qpvp.ash");
}

void main()
{
	cli_execute("breakfast");				//Run mafia built in breakfast script to do many daily tasks
	cli_execute("tt_fortune.ash");			//reply and send zatara fortune teller requests
	cli_execute("pvprotect.ash");			//closet your expensive pvpable items
	while(LX_freeCombats(true));			//use remaining free combats for the day
	doBedtime();							//various actions from autoscend bedtime
	tt_whenDrunk();							//actions we only want to take if overdrunk on logout
	tt_cargoPants();
	tt_collect_on_logout();
	pvp_logout();							//quickly spend all remaining pvp fights on logout. based on user settings
	cli_execute("crimbo22train.ash");		//train clan mates in the crimbo 2022 skills
	print("logout script finished", "green");
}