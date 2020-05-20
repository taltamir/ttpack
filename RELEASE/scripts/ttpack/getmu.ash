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

int grass_growth()
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

void main(int fertilizer_plan_to_use)
{
	if(!have_tall_grass())
	{
		abort("You do not have Tall Grass garden");
	}
	
	print("Trying to catch the elusive [Mu]");
	print("You have " + item_amount($item[Pok&eacute;-Gro fertilizer]) + " [poké-gro fertilizer] in your inventory.");
	
	int initial_mu = item_amount($item[Mu]);
	fertilizer_plan_to_use = min(fertilizer_plan_to_use, item_amount($item[Pok&eacute;-Gro fertilizer]));
	int fertilizer_uses_left = fertilizer_plan_to_use;
	
	while(fertilizer_uses_left > 0 || grass_growth() > 0)
	{
		if(grass_growth() == 0)
		{
			int multiuse = min(7,fertilizer_uses_left);
			use(multiuse, $item[Pok&eacute;-Gro fertilizer]);
			fertilizer_uses_left -= multiuse;
		}
		cli_execute("garden pick");
	}
	
	int mu_found = item_amount($item[Mu]) - initial_mu;
	int fertilizer_spent = fertilizer_plan_to_use - fertilizer_uses_left;
	int lifetime_mu_found = mu_found + get_property("tt_getmu_lifetime_mu_found").to_int();
	int lifetime_fertilizer_spent = fertilizer_spent + get_property("tt_getmu_lifetime_fertilizer_spent").to_int();
	
	set_property("tt_getmu_lifetime_mu_found", lifetime_mu_found);
	set_property("tt_getmu_lifetime_fertilizer_spent", lifetime_fertilizer_spent);
	
	//report this sessions results
	if(mu_found > 0)	//don't want to divide by zero
	{
		float fertilizer_per_mu_this_session = fertilizer_spent.to_float() / mu_found.to_float();
		
		print("You have successfully acquired " + mu_found + " [Mu] hatchlings this session. It cost " + fertilizer_per_mu_this_session + " [poké-gro fertilizer] per Mu","green");
	}
	else
	{
		print("Failed to find even a single [Mu] this session after spending " + fertilizer_spent + " [poké-gro fertilizer]","red");
	}
	
	//report all sessions results
	if(lifetime_mu_found > 0)	//don't want to divide by zero
	{
		float fertilizer_per_mu_lifetime = lifetime_fertilizer_spent.to_float() / lifetime_mu_found.to_float();
		
		print("You have successfully acquired " + lifetime_mu_found + " [Mu] hatchlings over all sessions. It cost " + fertilizer_per_mu_lifetime + " [poké-gro fertilizer] per Mu","green");
	}
	else
	{
		print("Failed to find even a single [Mu] over all sessions after spending " + lifetime_fertilizer_spent + " [poké-gro fertilizer]","red");
	}
	
	print();
}