//hunt down a Mu in the tall grass

import <ttpack/tt_util.ash>

boolean have_tall_grass()
{
	if(my_garden_type() == "grass")
	{
		return true;
	}
	
	if(item_amount($item[packet of tall grass seeds]) > 0)
	{
		return use(1, $item[packet of tall grass seeds]);
	}
		
	return false;
}

int growth()
{
	int [item] campground = get_campground();
	foreach it,qty in campground
	{
		if(it == $item[packet of tall grass seeds])
		{
			return qty;
		}
	}
	return 0;
}

void main(int fertilizer_to_use)
{
	if(!have_tall_grass())
	{
		abort("You do not have Tall Grass garden");
	}
	
	print("Trying to catch the elusive [Mu]");
	print("You have " + item_amount($item[Pok&eacute;-Gro fertilizer]) + " [poké-gro fertilizer] in your inventory.");
	
	int fertilizer_initial = item_amount($item[Pok&eacute;-Gro fertilizer]);
	int initial_mu = item_amount($item[Mu]);
	
	while(item_amount($item[Pok&eacute;-Gro fertilizer]) > 0 && fertilizer_to_use > 0)
	{
		if(growth() == 0)
		{
			use(1, $item[Pok&eacute;-Gro fertilizer]);
		}
		fertilizer_to_use--;
		cli_execute("garden pick");
	}
	
	int fertilizer_spent = fertilizer_initial - item_amount($item[Pok&eacute;-Gro fertilizer]);
	int mu_found = item_amount($item[Mu]) - initial_mu;
	
	if(mu_found > 0)
	{
		//don't want to divide by zero so it needs to be inside this if
		float fertilizer_per_mu = fertilizer_spent.to_float() / mu_found.to_float();
		
		print("You have successfully acquired " + mu_found + " [Mu] hatchlings. It cost " + fertilizer_per_mu + " [poké-gro fertilizer] per Mu","green");
	}
	else
	{
		print("Failed to find even a single [Mu] after spending " + fertilizer_spent + " [poké-gro fertilizer]","red");
	}
}