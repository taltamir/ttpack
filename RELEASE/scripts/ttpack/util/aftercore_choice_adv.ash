script "aftercore_choice_adv.ash";
import <autoscend/auto_choice_adv.ash>

boolean aftercore_run_choice(int choice, string page)
{
	print("Running aftercore_choice_adv.ash");
	
	switch (choice) {
		case 502:	//Arboreal Respite
			# https://kol.coldfront.net/thekolwiki/index.php/Arboreal_Respite
			# 1 => Follow the old road (503)
			# 2 => Explore the stream (505)
			# 3 => Brave the dark thicket (506)
			
			if(gbool("_aftercoreGetUsedBlood"))	//trying to acquire [bottle of used blood]
			{
				boolean has_blood = item_amount($item[bottle of used blood]) > 0;
				boolean has_heart = item_amount($item[Vampire heart]) > 0;
				boolean has_stakes = possessEquipment($item[wooden stakes];
				boolean equipped_stakes = equipped_amount($item[wooden stakes] > 0;
				
				if(has_blood)
					abort("_aftercoreGetUsedBlood is true but we already have [bottle of used blood]. yet we are still trying to get it");
				else if(has_heart || !has_stakes)
				{
					run_choice(1);		//goto choice 503 to trade hearts or get wooden stakes
					run_choice(2);		//talk to vampire hunter in choice 503.
					break;
				}
				else if(has_stakes)
				{
					if(equipped_stakes)
					{
						run_choice(2);		//goto choice 505 to fight a vampire
						run_choice(3);		//fight a vampire in choice 505
						break;
					}
					else abort("Tried to get [bottle of used blood] by adventuring in the forest without [wooden stakes]");
				}
			}
			break;
		
		default:
			return auto_run_choice(choice, page);
			break;
	}
	
	return true;
}

void main(int choice, string page)
{
	boolean ret = false;
	try
	{
		ret = aftercore_run_choice(choice, page);
	}
	finally
	{
		if (!ret)
		{
			auto_log_error("Error running aftercore_choice_adv.ash, setting auto_interrupt=true");
			set_property("auto_interrupt", true);
		}
	}
}