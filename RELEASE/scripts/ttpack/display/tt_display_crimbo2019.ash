//DO NOT RUN THIS FILE

void crimbo2019_settings()
{
	boolean new_setting_added = false;
	
	//set defaults
	if(get_property("tt_display_crimbo2019_displayTarget") == "" || get_property("tt_display_crimbo2019_displayTarget").to_int() < 0)
	{
		new_setting_added = true;
		set_property("tt_display_crimbo2019_displayTarget", 1);
	}
	if(get_property("tt_display_crimbo2019_inventoryTarget") == "" || get_property("tt_display_crimbo2019_inventoryTarget").to_int() < 0)
	{
		new_setting_added = true;
		set_property("tt_display_crimbo2019_inventoryTarget", 1);
	}
	if(get_property("tt_display_crimbo2019_doubleFisting") == "")
	{
		new_setting_added = true;
		set_property("tt_display_crimbo2019_doubleFisting", true);
	}

	//print current settings status
	print("how many of each item do you want in your display case:", "blue");
	print("tt_display_crimbo2019_displayTarget = " + get_property("tt_display_crimbo2019_displayTarget"), "blue");
	print("how many of that item do you want in your inventory. currently equipped counts:", "blue");
	print("tt_display_crimbo2019_inventoryTarget = " + get_property("tt_display_crimbo2019_inventoryTarget"), "blue");
	print("Add +1 to inventoryTarget for items that can be double fisted:", "blue");
	print("tt_display_crimbo2019_doubleFisting = " + get_property("tt_display_crimbo2019_doubleFisting"), "blue");
	
	print();
	print("You can make changes to these settings by typing:", "blue");
	print("set [setting_name] = [target]", "blue");
	
	if(new_setting_added)
	{
		abort("Settings have been configured to default. Please verify they are correct before running me again");
	}
}

//settings
int inventoryTarget = 1;			//how many of that item do you want in your inventory, currently equipped counts.
int displayTarget = 1;				//how many of each item do you want in your display case.
boolean fisting = true;				//Add +1 to inventoryTarget for items that can be double fisted
//end settings

void cacheMall()
{
mall_price($item[ribbon candy ascot]);
mall_price($item[icing poncho]);
mall_price($item[anemoney clip]);
mall_price($item[mer-kin rollpin]);
mall_price($item[crimbylow-rise jeans]);
mall_price($item[soggy elf shoes]);
mall_price($item[peppermint spine]);
mall_price($item[yuleviathan necklace]);
mall_price($item[kelp-holly drape]);
mall_price($item[kelp-holly gun]);
}

int invCount(item it)
{
   int counter = item_amount(it) + closet_amount(it) + storage_amount(it) + equipped_amount(it);
   return counter;
}

void reportRare(string mon, item it, int invq, int disq)
{
	int kmprice = mall_price(it)/1000;
	if (display_amount(it) >= disq && invCount(it) >= invq)
	{
		print(mon + " rare drop is " + it + ". Display QTY: " + display_amount(it) + ". Inventory QTY: " + invCount(it) + ". Mallprice: " + kmprice + " kilomeat","green");
	}
	if ((display_amount(it) + invCount(it) > 0) && (display_amount(it) < disq || invCount(it) < invq))
	{
		print(mon + " rare drop is " + it + ". Display QTY: " + display_amount(it) + ". Inventory QTY: " + invCount(it) + ". Mallprice: " + kmprice + " kilomeat","orange");
	}
	if ((display_amount(it) + (invCount(it))) == 0)
	{
		print(mon + " rare drop is " + it + ". of which you have none. Mallprice: " + kmprice + " kilomeat","red");
	}
}

void reportCS(int invq, int disq)
{
	item it = $item[staff of the peppermint twist];

	if (display_amount(it) >= disq && invCount(it) >= invq)
	{
		print("Peppermint Spine can be used to craft staff of the peppermint twist. Display QTY: " + display_amount(it) + ". Inventory QTY: " + invCount(it),"green");
	}
	if ((display_amount(it) + invCount(it) > 0) && (display_amount(it) < disq || invCount(it) < invq))
	{
		print("Peppermint Spine can be used to craft staff of the peppermint twist. Display QTY: " + display_amount(it) + ". Inventory QTY: " + invCount(it),"orange");
	}
	if ((display_amount(it) + (invCount(it))) == 0)
	{
		print("Peppermint Spine can be used to craft staff of the peppermint twist. of which you have none","red");
	}
}

void rareList()
{
	//set the fisting target quantity based on whether or not fisting is enabled.
	int displayTarget = get_property("tt_display_crimbo2019_displayTarget").to_int();
	int inventoryTarget = get_property("tt_display_crimbo2019_inventoryTarget").to_int();
	int fistingTarget = inventoryTarget;
	if(get_property("tt_display_crimbo2019_doubleFisting").to_boolean())
	{
		fistingTarget++;
	}

	//first zone
	print("Zone = Gingerbread Reef","blue");
	reportRare("Gingerbread Maw",$item[ribbon candy ascot],inventoryTarget,displayTarget);
	reportRare("Icingfish",$item[icing poncho],inventoryTarget,displayTarget);
	reportRare("Nutmeg Anemone",$item[anemoney clip],inventoryTarget,displayTarget);
	reportRare("Mer-kin Baker",$item[mer-kin rollpin],fistingTarget,displayTarget);
	int zoneAvg = (mall_price($item[ribbon candy ascot]) + mall_price($item[icing poncho]) + mall_price($item[anemoney clip]) + mall_price($item[mer-kin rollpin]))/4000;
	print("Zone average mallprice: " + zoneAvg + " kilomeat");

	//second zone
	print();
	print("Zone = The Wreck of the H. M. S. Kringle","blue");
	reportRare("Crimbylow",$item[crimbylow-rise jeans],inventoryTarget,displayTarget);
	reportRare("Sea-elf",$item[soggy elf shoes],inventoryTarget,displayTarget);
	reportRare("Peppermint Eel",$item[peppermint spine],fistingTarget,displayTarget);
	reportCS(inventoryTarget,displayTarget);
	zoneAvg = (mall_price($item[crimbylow-rise jeans]) + mall_price($item[soggy elf shoes]) + mall_price($item[peppermint spine]))/3000;
	print("Zone average mallprice: " + zoneAvg + " kilomeat");

	//third zone
	print();
	print("Zone = The Impenetrable Kelp-Holly Forest","blue");
	reportRare("The Yuleviathan",$item[yuleviathan necklace],inventoryTarget,displayTarget);
	reportRare("Kelpie (horse form)",$item[kelp-holly drape],inventoryTarget,displayTarget);
	reportRare("Kelpie (lady form)",$item[kelp-holly gun],fistingTarget,displayTarget);
	zoneAvg = (mall_price($item[yuleviathan necklace]) + mall_price($item[kelp-holly drape]) + mall_price($item[kelp-holly gun]))/3000;
	print("Zone average mallprice: " + zoneAvg + " kilomeat");
}

void manageCrimbo2019()
{
	crimbo2019_settings();
	cacheMall();
	rareList();			//list all the rare items for crimbo 2019
}