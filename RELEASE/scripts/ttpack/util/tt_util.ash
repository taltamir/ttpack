//utility functions for ttpack.
//importing autoscend since I do a lot of dev there and want to reuse functions

import <autoscend.ash>
import <ttpack/util/tt_header.ash>
import <ttpack/util/tt_defaults.ash>
import <ttpack/util/tt_depreciate.ash>

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

boolean tt_acquire(item it)
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
	
	if(my_meat()+20000 > expected_price && expected_price > 0 && expected_price < 1000000)
	{
		buy(1, it, expected_price);
		if(item_amount(it) > 0) return true;
	}
	
	return false;
}

void tt_eatSurpriseEggs()
{
	if(!get_property("tt_aftercore_eatSurpriseEggs").to_boolean())
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
		retrieve_item(lucky_amt, $item[disassembled clover]);		//to fix aborting due to failure to craft due to not having enough clovers
		retrieve_item(lucky_amt, $item[lucky surprise egg]);
		lucky_amt = min(item_amount($item[lucky surprise egg]), lucky_amt);
		eat(lucky_amt, $item[lucky surprise egg]);
	}
	if(spooky_amt > 0)
	{
		retrieve_item(lucky_amt, $item[disassembled clover]);		//to fix aborting due to failure to craft due to not having enough clovers
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
