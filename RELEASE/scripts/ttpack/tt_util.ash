//utility functions for ttpack.
//importing autoscend since I do a lot of dev there and want to reuse functions

import <autoscend.ash>
import <ttpack/tt_depreciate.ash>

boolean tt_acquire(item it)
{
	if((item_amount(it) + equipped_amount(it)) > 0) return true;
	if(closet_amount(it) > 0)
	{
		take_closet(1, it);
		return true;
	}
	if(canPull(it))
	{
		if(pullXWhenHaveY(it, 1, 0)) return true;
	}
	
	//check availability and best price.
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