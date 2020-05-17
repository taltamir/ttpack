boolean tt_acquire(item it)
{
	if(item_amount(it) > 0) return true;
	
	int expected_price = mall_price(it);
	//TODO add store price
	
	if(my_meat()+20000 > expected_price)
	{
		buy(1, it, expected_price);
		if(item_amount(it) > 0) return true;
	}
	
	return false;
}