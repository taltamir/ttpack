//utility functions for ttpack.
//importing autoscend since I do a lot of dev there and want to reuse functions

import <autoscend.ash>
import <ttpack/util/tt_header.ash>
import <ttpack/util/tt_defaults.ash>
import <ttpack/util/tt_depreciate.ash>

boolean gbool(string prop)
{
	return to_boolean(get_property(prop));
}

int gint(string prop)
{
	return to_int(get_property(prop));
}

float gfloat(string prop)
{
	return to_float(get_property(prop));
}

void noStooper()
{
	//switches out stooper familiar if it is the current familiar.
	if(!pathHasFamiliar() || !pathAllowsChangingFamiliar())
		return;		//path incompatible with familiars
	if(my_familiar() != $familiar[stooper])
		return;		//familiar is not stooper at the moment
	if(inebriety_left() == 0)
		return;		//familiar is stooper. but must be kept as it is the only thing preventing overdrunk
	
	use_familiar(lookupFamiliarDatafile("item"));
}

boolean quest_unstarted(string quest_name)
{
	//returns true if a quest is currently unstarted.
	//quest_name is using mafia tracking quest data types that track current stage via a string.
	return get_property(quest_name) == "unstarted";
}

void tt_printSetting(string name, string desc)
{
	print(name + " = " + get_property(name), "blue");
	if(desc != "")
	{
		print("    ^" + desc);
	}
}
void tt_printSetting(string name)
{
	tt_printSetting(name, "");
}

boolean tt_acquire(item it, int price_limit)
{
	//already have it?
	if((item_amount(it) + equipped_amount(it)) > 0) return true;
	
	//uncloset it
	if(closet_amount(it) > 0)
	{
		take_closet(1, it);
		if((item_amount(it) + equipped_amount(it)) > 0) return true;
	}
	
	//pull from hangk if no mall access.
	if(canPull(it) && !can_interact())
	{
		if(pullXWhenHaveY(it, 1, 0)) return true;
	}
	
	//take from your own mall store.
	if(shop_amount(it) > 0)
	{
		take_shop(1, it);
	}
	
	//check store availability and best price.
	int mall_price = mall_price(it);	//-1 means out of stock, 0 means untradeable.
	int npc_price = npc_price(it);		//0 means unavailable
	int expected_price = 0;
	if(mall_price > 0 && npc_price > 0)		//available from both
	{
		expected_price = min(mall_price, npc_price);
	}
	else if(mall_price > 0)				//mall only
	{
		expected_price = mall_price;
	}
	else if(npc_price > 0)				//npc stores only
	{
		expected_price = npc_price;
	}
	
	if(my_meat()+20000 > expected_price && expected_price > 0 && expected_price < price_limit)
	{
		buy(1, it, expected_price+100);
		if(item_amount(it) > 0) return true;
	}
	
	return false;
}

boolean tt_acquire(item it)
{
	return tt_acquire(it, gint("autoBuyPriceLimit"));
}

boolean try_retrieve(int amt, item it)
{
	//a failed retrieve command throws an abort instead of merely returning false.
	try retrieve_item(amt,it);
	finally return item_amount(it) >= amt;
}

boolean try_retrieve(item it)
{
	return try_retrieve(1,it);
}

boolean retrieve_new(int amt, item it)
{
	//do a try_retrieve with different return values
	//false means we already had it (thus did not act). or that we failed to acquire it.
	//true means we did not have it before, but do have it now.
	int start = item_amount(it);
	int needed = amt - start;
	if(needed < 1) return false;
	try_retrieve(amt, it);
	return (item_amount(it) - needed) == start;
}

boolean retrieve_new(item it)
{
	return retrieve_new(1,it);
}

void tt_eatSurpriseEggs()
{
	if(!get_property("aftercore_eatSurpriseEggs").to_boolean())
	{
		return;
	}
	
	int food_amt = fullness_left();
	int spooky_amt = 0;
	int lucky_amt = 0;
	while(food_amt > 0)
	{
		if(lucky_amt < spooky_amt)
		{
			lucky_amt++;
			food_amt--;
		}
		else
		{
			spooky_amt++;
			food_amt--;
		}
	}
	
	if(lucky_amt > 0)
	{
		retrieve_item(lucky_amt, $item[ten-leaf clover]);		//to fix aborting due to failure to craft due to not having enough clovers
		retrieve_item(lucky_amt, $item[lucky surprise egg]);
		lucky_amt = min(item_amount($item[lucky surprise egg]), lucky_amt);
		eat(lucky_amt, $item[lucky surprise egg]);
	}
	if(spooky_amt > 0)
	{
		retrieve_item(lucky_amt, $item[ten-leaf clover]);		//to fix aborting due to failure to craft due to not having enough clovers
		retrieve_item(spooky_amt, $item[spooky surprise egg]);
		spooky_amt = min(item_amount($item[spooky surprise egg]), spooky_amt);
		eat(spooky_amt, $item[spooky surprise egg]);
	}
}

void tt_closetPutAll(item it)
{
	int qty = item_amount(it);
	if (qty > 0)
	{
		print("putting in closet " + qty + " " + it);
		put_closet(qty, it);
	}
}

void tt_closetTakeAll(item it)
{
	int qty = closet_amount(it);
	if (qty > 0)
	{
		print("taking from closet " + qty + " " + it);
		take_closet(qty, it);
	}
}

boolean tt_isRich()
{
	if(my_meat() > 1000000) return true;
	else return false;
}

void tt_snapshot()
{
	if(get_property("auto_snapshot").to_int() == my_ascensions())
	{
		return;		//only want to run this once per ascension.
	}
	
	if(svn_info("ccascend-snapshot").last_changed_rev > 0)
	{
		cli_execute("cc_snapshot.ash");
	}

	set_property("auto_snapshot", my_ascensions());
}

boolean out_of_adv()
{
	if(my_adventures() == 0)
	{
		print("Out of adventures", "red");
		return true;
	}
	return false;
}

boolean has_numbers(string target)
{
    for(int i=0; i<10; i++)
    {
        if(target.contains_text(i.to_string()))
        {
            return true;
        }
    }
    return false;
}

int day()
{
	string today = today_to_string();
	string retval = char_at(today, 6) + char_at(today, 7);
	return retval.to_int();
}

int month()
{
	string today = today_to_string();
	string retval = char_at(today, 4) + char_at(today, 5);
	return retval.to_int();
}

int year()
{
	string today = today_to_string();
	string retval = char_at(today, 0) + char_at(today, 1) + char_at(today, 2) + char_at(today, 3);
	return retval.to_int();
}

string[int] stances()
{
	int[string] input = current_pvp_stances();
	string[int] retval;
	foreach s, i in input
	{
		retval[i] = s;
	}
	return retval;
}
