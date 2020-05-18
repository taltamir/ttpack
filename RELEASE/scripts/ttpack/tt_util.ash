//utility functions for ttpack. since I do a lot of autoscend dev I figured I would reuse functionality and I start off by importing all autoscend functions.

import <autoscend.ash>
import <ttpack/tt_depreciate.ash>

boolean tt_acquire(item it)
{
	if(item_amount(it) + equipped_amount(it) + closet_amount(it) > 0) return true;
	
	int expected_price = mall_price(it);
	//TODO add store price
	
	if(my_meat()+20000 > expected_price)
	{
		buy(1, it, expected_price);
		if(item_amount(it) > 0) return true;
	}
	
	return false;
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