import <autoscend.ash>

float meat_per_mp()
{
// this function gives the meat cost of restoring 1 MP, assuming you can buy mp with meat.

// initial value is very high in case you simply do not have the means to buy mp with meat and must rest to restore.
float meatpermp = 100;

	// these paths cannot use meat to restore MP, but are able to buy restorers.
	if($strings[Dark Gyffte] contains auto_my_path())
	{
		return 100;
	}

	// if you have access to the general store. reduce to price of soda water. all paths have it except nuclear autumn
	if (auto_my_path() != "Nuclear Autumn")
	{
		meatpermp = min(17.5,meatpermp);
	}
	
	// if white citadel available
	if (white_citadel_available())
		{
			meatpermp = min(10,meatpermp);
		}

	// if you have access to doc galactic
	if(!($strings[Nuclear Autumn, Zombie Slayer, Kingdom of Exploathing] contains auto_my_path()))
	{
		meatpermp = min(9,meatpermp);
		
		// adjusted galactic value if you did the quest
		if ( get_property( "questM24Doc" ) == "finished" )
		{
			meatpermp = min(6,meatpermp);
		}
	}
	
	// knob dispensery
	if (dispensary_available())
	{
		meatpermp = min(8,meatpermp);
	}

	// black market
	if (black_market_available())
	{
		meatpermp = min(8,meatpermp);
	}

	// a nuclear autumn skill that lets you convert meat to MP
	if (have_skill($skill[Internal Soda Machine]))
	{
		meatpermp = min(2,meatpermp);
	}

return meatpermp;
}

float meat_per_hp()
{
// this function gives the meat cost of restoring 1 HP, assuming you can buy hp with meat.
// it does take into account mp to hp conversion

// initial value is very high in case you simply do not have the means to buy hp with meat and must rest to restore.

float meatperhp = 100;
float meatpermp = meat_per_mp();
float spellmpmp = 1;

	// these paths cannot use meat to restore HP, but are able to buy restorers.
	if($strings[Actually Ed the Undying, Dark Gyffte, Path of the Plumber] contains auto_my_path())
	{
		return 100;
	}
	
	// if you have access to doc galactic restoratives
	if(!($strings[Nuclear Autumn, Zombie Slayer, Kingdom of Exploathing] contains auto_my_path()))
	{
		meatperhp = min(6.3,meatperhp);
		
		// adjusted galactic value if you did the quest
		if ( get_property( "questM24Doc" ) == "finished" )
		{
			meatperhp = min(4.21,meatperhp);
		}
	}

	if (have_skill($skill[Disco Nap]))
	{
		spellmpmp = 0.4*meatpermp;
		meatperhp = min(spellmpmp,meatperhp);
	}
	
	if (have_skill($skill[Disco Nap]) && have_skill($skill[Adventurer of Leisure]))
	{
		spellmpmp = 0.2*meatpermp;
		meatperhp = min(spellmpmp,meatperhp);
	}
	
	if (have_skill($skill[Lasagna Bandages]))
	{
		spellmpmp = 0.4*meatpermp;
		meatperhp = min(spellmpmp,meatperhp);
	}
	
	if (have_skill($skill[Saucy Salve]))
	{
		spellmpmp = 0.32*meatpermp;
		meatperhp = min(spellmpmp,meatperhp);
	}
	
	if (have_skill($skill[Lasagna Bandages]))
	{
		spellmpmp = 0.3*meatpermp;
		meatperhp = min(spellmpmp,meatperhp);
	}
	
	if (have_skill($skill[Tongue of the Walrus]))
	{
		spellmpmp = 0.286*meatpermp;
		meatperhp = min(spellmpmp,meatperhp);
	}
	
	if (have_skill($skill[Cannelloni Cocoon]))
	{
		//assuming cocoon is used to heal only 80% of max HP or 1000, whichever is less.
		//this appears to be rounding to zero
		
		if (0.8 * my_maxhp() < 1000)
		{
			spellmpmp = 25.0/my_maxhp()*meatpermp;
		}
		else
		{
			spellmpmp = 0.02*meatpermp;
		}
		
		meatperhp = min(spellmpmp,meatperhp);
	}
	
	if (have_skill($skill[Shake It Off]))
	{
		//assuming when used will only heal 80% of max HP
		spellmpmp = 37.5/my_maxhp()*meatpermp;
		meatperhp = min(spellmpmp,meatperhp);
	}
	
	if (have_skill($skill[Laugh it Off]))
	{
		spellmpmp = 0.667*meatpermp;
		meatperhp = min(spellmpmp,meatperhp);
	}

return meatperhp;
}

float expected_damage_cost_in_meat()
{
// this function reports how much meat worth of HP you expect to lose the next time your enemy takes their turn.
// this assumes you will buy your restorers using meat

return expected_damage() * meat_per_hp();
}

//print ("meat per mp " + meat_per_mp());
//print ("meat per hp " + meat_per_hp());
//print ("expected damage cost in meat " + expected_damage_cost_in_meat());
//print ("expected damage " + expected_damage());

acquireHP();