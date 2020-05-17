//do not run this file

void figurines_settings()
{
	boolean new_setting_added = false;
	
	//set defaults
	if(get_property("tt_display_figurines_displayTarget") == "" || get_property("tt_display_figurines_displayTarget").to_int() < 0)
	{
		new_setting_added = true;
		set_property("tt_display_figurines_displayTarget", 1);
	}
	if(get_property("tt_display_figurines_displayRemoveExcess") == "")
	{
		new_setting_added = true;
		set_property("tt_display_figurines_displayRemoveExcess", true);
	}
	if(get_property("tt_display_figurines_takeFromMyStore") == "")
	{
		new_setting_added = true;
		set_property("tt_display_figurines_takeFromMyStore", false);
	}
	if(get_property("tt_display_figurines_mallbuyCurrent") == "")
	{
		new_setting_added = true;
		set_property("tt_display_figurines_mallbuyCurrent", true);
	}
	if(get_property("tt_display_figurines_mallbuyCurrentMaxPrice") == "" || get_property("tt_display_figurines_mallbuyCurrentMaxPrice").to_int() < 1000)
	{
		new_setting_added = true;
		set_property("tt_display_figurines_mallbuyCurrentMaxPrice", 1000);
	}
	if(get_property("tt_display_figurines_mallbuyObsolete") == "")
	{
		new_setting_added = true;
		set_property("tt_display_figurines_mallbuyObsolete", false);
	}
	if(get_property("tt_display_figurines_mallbuyObsoleteMaxPrice") == "" || get_property("tt_display_figurines_mallbuyCurrentMaxPrice").to_int() < 1000)
	{
		new_setting_added = true;
		set_property("tt_display_figurines_mallbuyObsoleteMaxPrice", 1000);
	}

	//print current settings status
	print("tt_display_figurines_displayTarget = " + get_property("tt_display_figurines_displayTarget"), "blue");
	print("tt_display_figurines_displayRemoveExcess = " + get_property("tt_display_figurines_displayRemoveExcess"), "blue");
	print("tt_display_figurines_takeFromMyStore = " + get_property("tt_display_figurines_takeFromMyStore"), "blue");
	print("tt_display_figurines_mallbuyCurrent = " + get_property("tt_display_figurines_mallbuyCurrent"), "blue");
	print("tt_display_figurines_mallbuyCurrentMaxPrice = " + get_property("tt_display_figurines_mallbuyCurrentMaxPrice"), "blue");
	print("tt_display_figurines_mallbuyObsolete = " + get_property("tt_display_figurines_mallbuyObsolete"), "blue");
	print("tt_display_figurines_mallbuyObsoleteMaxPrice = " + get_property("tt_display_figurines_mallbuyObsoleteMaxPrice"), "blue");
	
	if(new_setting_added)
	{
		abort("Settings have been configured to default. Please verify they are correct before running me again");
	}
}

boolean displayFigurine(item it, boolean mallbuy, int max_price)
{
	int target = get_property("tt_display_figurines_displayTarget").to_int();
	int temp = 0;
	
	//remove excess from display, so that they can be sold.
	if(get_property("tt_display_figurines_displayRemoveExcess").to_boolean() && display_amount(it) > target)
	{
		print("[" + it + "] will have excess units removed from display", "green");
		take_display(display_amount(it) - target, it);
	}
	
	//display from your inventory
	if(display_amount(it) < target && item_amount(it) > 0)
	{
		temp = min(target-display_amount(it), item_amount(it));
		print("[" + it + "] will be added to display", "green");
		put_display(temp, it);
	}
	
	//take from your colossal closet
	if(display_amount(it) < target && closet_amount(it) > 0)
	{
		temp = min(target-display_amount(it), closet_amount(it));
		take_closet(temp, it);
		print("[" + it + "] will be added to display", "green");
		put_display(temp, it);
	}
	
	//take from your own store in the mall
	if(get_property("tt_display_figurines_takeFromMyStore").to_boolean() && display_amount(it) < target && shop_amount(it) > 0)
	{
		temp = min(target-display_amount(it), shop_amount(it));
		take_shop(temp, it);
		print("[" + it + "] will be added to display", "green");
		put_display(temp, it);
	}
	
	//buy from other people's store in the mall
	if(mallbuy && display_amount(it) < target && mall_price(it) < my_meat() && mall_price(it) < max_price)
	{
		temp = min(target-display_amount(it), floor(my_meat()/mall_price(it)));
		buy(temp, it, max_price);
		print("[" + it + "] will be added to display", "green");
		put_display(temp, it);
	}
	
	if(display_amount(it) == target)
	{
		return true;
	}
	return false;
}

boolean setCheckCurrentFigurine(string set_name, boolean[item] item_set, boolean mallbuy, string acquire_msg)
{
	boolean set_complete = true;
	int max_price = get_property("tt_display_figurines_mallbuyCurrentMaxPrice").to_int();
	foreach it in item_set
	{
		if(!displayFigurine(it, mallbuy, max_price))
		{
			set_complete = false;
			print("[" + set_name + "] is still missing [" + it + "]. mallprice = " + mall_price(it));
		}
	}
	if(set_complete)
	{
		print("You have successfully displayed a full set of [" + set_name + "]" , "blue");
	}
	else
	{
		print("[" + set_name + "] is not complete. " + acquire_msg, "green");
	}
	return set_complete;
}

boolean setCheckObsoleteFigurine(string set_name, boolean[item] item_set, boolean mallbuy, string acquire_msg)
{
	boolean set_complete = true;
	int max_price = get_property("tt_display_figurines_mallbuyObsoleteMaxPrice").to_int();
	foreach it in item_set
	{
		if(!displayFigurine(it, mallbuy, max_price))
		{
			set_complete = false;
			if(mallbuy)
			{
				print("[" + set_name + "] is still missing [" + it + "]. mallprice = " + mall_price(it));
			}
		}
	}
	if(set_complete)
	{
		print("You have successfully displayed a full set of [" + set_name + "]" , "blue");
	}
	else
	{
		print("[" + set_name + "] is not complete and obsolete. " + acquire_msg, "orange");
	}
	return set_complete;
}

void figurines_getObsolete()
{
	//this is for sets for which no new instances can be acquired. you can only buy surplus in the mall.
	
	string set_name = "";
	string acquire_msg = "";
	boolean[item] item_set;
	boolean mallbuy = get_property("tt_display_figurines_mallbuyObsolete").to_boolean();
	
	//Tiny Plastic Series 1C
	set_name = "Tiny Plastic Series 1C \(Crimbo 2005\)";
	acquire_msg = "Originally from [Advent Calendar]. Can still drop from [doll house] but no new [doll house] can be created.";
	item_set = $items[tiny plastic Crimbo elf,
	tiny plastic sweet nutcracker,
	tiny plastic Crimbo reindeer,
	tiny plastic Crimbo wreath,
	tiny plastic Uncle Crimbo];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 1Cw
	set_name = "Tiny Plastic Series 1Cw \(Crimboween 2006\)";
	acquire_msg = "Originally from [Spooky Advent Calendar].";
	item_set = $items[tiny plastic gift-wrapping vampire,
	tiny plastic ancient yuletide troll,
	tiny plastic skeletal reindeer,
	tiny plastic Crimboween pentagram,
	tiny plastic Scream Queen];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 2C
	set_name = "Tiny plastic series 2C \(Crimbo 2008\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic Mob Penguin,
	tiny plastic Mutant Elf,
	tiny plastic Fat stack of cash,
	tiny plastic Strand of DNA,
	tiny plastic Chunk of depleted Grimacite];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 3C
	set_name = "Tiny plastic series 3C \(Crimbo 2009\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic 11 Dealer,
	tiny plastic Crimbo Casino,
	tiny plastic stocking mimic,
	tiny plastic Don Crimbo,
	tiny plastic Crimbomination];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 4C
	set_name = "Tiny plastic series 4C \(Crimbo 2010\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic CRIMBCO HQ,
	tiny plastic fax machine,
	tiny plastic hobo elf,
	tiny plastic Mr. Mination,
	tiny plastic Best Game Ever];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 5C
	set_name = "Tiny plastic series 5C \(Crimbo 2011\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic trollipop,
	tiny plastic Fudge Wizard,
	tiny plastic abominable fudgeman,
	tiny plastic colollilossus,
	tiny plastic Big Candy];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 6C
	set_name = "Tiny plastic series 6C \(Crimbo 2012\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic animelf,
	tiny plastic ChibiBuddy&trade;,
	tiny plastic taco-clad Crimbo elf,
	tiny plastic Uncle Crimboku,
	tiny plastic MechaElf];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 7C
	set_name = "Tiny plastic series 7C \(Crimbo 2013\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic GORM-8,
	tiny plastic warbear,
	tiny plastic Toybot,
	tiny plastic warbear fortress,
	tiny plastic K.R.A.M.P.U.S.];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 8C
	set_name = "Tiny plastic series 8C \(Crimbo 2014\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic exo-suited miner, 
	tiny plastic semi-autonomous drill unit,
	tiny plastic ambulatory robo-minecart,
	tiny plastic Crimbot,
	tiny plastic Crimbomega];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 9C
	set_name = "Tiny plastic series 9C \(Crimbo 2015\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic Tammy the Tambourine Elf,
	tiny plastic Rudolph the Red,
	tiny plastic Gaia\'ajh-dsli Ak\'lwej,
	tiny plastic Crimborgatron,
	tiny plastic Crimbodhisattva];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 10C
	set_name = "Tiny plastic series 10C \(Crimbo 2016\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic bad vibe,
	tiny plastic angry vikings,
	tiny plastic Knows About Chakras,
	tiny plastic Your Brain,
	tiny plastic Krampus];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 11C
	set_name = "Tiny plastic series 11C \(Crimbo 2017\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic mime functionary,
	tiny plastic mime scientist,
	tiny plastic mime soldier,
	tiny plastic mime executive,
	tiny plastic The Silent Nightmare];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 12C
	set_name = "Tiny plastic series 12C \(Crimbo 2018\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic wild beaver,
	tiny plastic reindeer,
	tiny plastic Caf&eacute; Elf,
	tiny plastic orphan,
	tiny plastic Abuela Crimbo];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 13C
	set_name = "Tiny plastic series 13C \(Crimbo 2019\)";
	acquire_msg = "Originally from [Advent Calendar].";
	item_set = $items[tiny plastic Mer-kin baker,
	tiny plastic sea elf,
	tiny plastic yuleviathan,
	tiny plastic dolphin &quot;orphan&quot;,
	tiny plastic Dolph Bossin,];
	setCheckObsoleteFigurine(set_name, item_set, mallbuy, acquire_msg);
}

void figurines_getCurrent()
{
	//this is for sets for which new instances can be acquired in the game.
	
	string set_name = "";
	string acquire_msg = "";
	boolean[item] item_set;
	boolean mallbuy = get_property("tt_display_figurines_mallbuyCurrent").to_boolean();
	
	//Tiny Plastic Series 1
	set_name = "Tiny Plastic Series 1 \(February 1st, 2005\)";
	acquire_msg = "Obtained by eating a [Lucky Surprise Egg] or use the obsolete [doll house]";
	item_set = $items[tiny plastic disco bandit,
	tiny plastic accordion thief,
	tiny plastic turtle tamer,
	tiny plastic seal clubber,
	tiny plastic pastamancer,
	tiny plastic sauceror,
	tiny plastic mosquito,
	tiny plastic leprechaun,
	tiny plastic levitating potato,
	tiny plastic angry goat,
	tiny plastic sabre-toothed lime,
	tiny plastic fuzzy dice,
	tiny plastic spooky pirate skeleton,
	tiny plastic barrrnacle,
	tiny plastic howling balloon monkey,
	tiny plastic stab bat,
	tiny plastic grue,
	tiny plastic blood-faced volleyball,
	tiny plastic ghuol whelp,
	tiny plastic baby gravy fairy,
	tiny plastic cocoabo,
	tiny plastic star starfish,
	tiny plastic ghost pickle on a stick,
	tiny plastic killer bee,
	tiny plastic Cheshire bat,
	tiny plastic coffee pixie,
	tiny plastic bitchin\' meatcar,
	tiny plastic hermit,
	tiny plastic Boris,
	tiny plastic Jarlsberg,
	tiny plastic Sneaky Pete,
	tiny plastic Susie];
	setCheckCurrentFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 2
	set_name = "Tiny Plastic Series 2 \(October 31st, 2007\)";
	acquire_msg = "Obtained by eating a [Spooky Surprise Egg] or use the obsolete [dollhive]";
	item_set = $items[tiny plastic Naughty Sorceress,
	tiny plastic Ed the Undying,
	tiny plastic Lord Spookyraven,
	tiny plastic Dr. Awkward,
	tiny plastic protector spectre,
	tiny plastic Baron von Ratsworth,
	tiny plastic Boss Bat,
	tiny plastic Knob Goblin King,
	tiny plastic Bonerdagon,
	tiny plastic The Man,
	tiny plastic The Big Wisniewski,
	tiny plastic Felonia,
	tiny plastic Beelzebozo,
	tiny plastic conservationist hippy,
	tiny plastic 7-foot dwarf,
	tiny plastic angry bugbear,
	tiny plastic anime smiley,
	tiny plastic apathetic lizardman,
	tiny plastic astronomer,
	tiny plastic beanbat,
	tiny plastic blooper,
	tiny plastic brainsweeper,
	tiny plastic briefcase bat,
	tiny plastic demoninja,
	tiny plastic filthy hippy jewelry maker,
	tiny plastic drunk goat,
	tiny plastic fiendish can of asparagus,
	tiny plastic Gnollish crossdresser,
	tiny plastic handsome mariachi,
	tiny plastic Knob Goblin bean counter,
	tiny plastic Knob Goblin harem girl,
	tiny plastic Knob Goblin mad scientist,
	tiny plastic Knott Yeti,
	tiny plastic lemon-in-the-box,
	tiny plastic lobsterfrogman,
	tiny plastic ninja snowman,
	tiny plastic Orcish Frat Boy,
	tiny plastic G Imp,
	tiny plastic goth giant,
	tiny plastic cubist bull,
	tiny plastic scary clown,
	tiny plastic smarmy pirate,
	tiny plastic spiny skelelton,
	tiny plastic Spam Witch,
	tiny plastic spooky vampire,
	tiny plastic taco cat,
	tiny plastic undead elbow macaroni,
	tiny plastic warwelf,
	tiny plastic whitesnake,
	tiny plastic XXX pr0n,
	tiny plastic zmobie,
	tiny plastic Protagonist,
	tiny plastic Spunky Princess,
	tiny plastic topiary golem,
	tiny plastic senile lihc,
	tiny plastic Iiti Kitty,
	tiny plastic Gnomester Blomester,
	tiny plastic Trouser Snake,
	tiny plastic Axe Wound,
	tiny plastic Hellion,
	tiny plastic Black Knight,
	tiny plastic giant pair of tweezers,
	tiny plastic fruit golem,
	tiny plastic fluffy bunny];
	setCheckCurrentFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 3
	set_name = "Tiny Plastic Series 3 \(December 15th, 2012\)";
	acquire_msg = "Obtained from [blind-packed capsule toy] obtained from trick or treat with [Animelf Apparel]";
	item_set = $items[tiny plastic four-shadowed mime,
	tiny plastic Bugbear Captain,
	tiny plastic Rene C. Corman,
	tiny plastic Lord Flameface,
	tiny plastic Beebee King,
	tiny plastic Queen Bee,
	tiny plastic Wu Tang the Betrayer,
	tiny plastic Clancy the Minstrel,
	tiny plastic Battlesuit Bugbear Type,
	tiny plastic spiderbugbear,
	tiny plastic peacannon,
	tiny plastic The Free Man,
	tiny plastic fire servant,
	tiny plastic mumblebee,
	tiny plastic moneybee,
	tiny plastic beebee gunners,
	tiny plastic beebee queue,
	tiny plastic buzzerker,
	tiny plastic bee swarm,
	tiny plastic batbugbear,
	tiny plastic bugaboo,
	tiny plastic Ancient Unspeakable Bugbear,
	tiny plastic black ops bugbear,
	tiny plastic hypodermic bugbear,
	tiny plastic cavebugbear,
	tiny plastic Norville Rogers,
	tiny plastic Scott the Miner,
	tiny plastic angry space marine,
	tiny plastic Charity the Zombie Hunter,
	tiny plastic Father McGruber,
	tiny plastic Hank North\, Photojournalist,
	tiny plastic blazing bat];
	setCheckCurrentFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Tiny Plastic Series 1(FF)
	set_name = "Tiny Plastic Series 1\(FF\) \(March 1st, 2014\)";
	acquire_msg = "Obtained from [Thinknerd Blind-Packed Toy]";
	item_set = $items[tiny plastic Gary Claybender,
	tiny plastic Jared the Duskwalker,
	tiny plastic Duke Starkiller,
	tiny plastic Professor What,
	tiny plastic Captain Kerkard];
	setCheckCurrentFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Die-Cast series 1
	set_name = "Die-Cast series 1 \(December 17th, 2013\)";
	acquire_msg = "Obtained from [blind-packed die-cast metal toy] obtained from [warbear black box] via the bot [WhositBot]";
	item_set = $items[tiny die-cast Bashful the Reindeer,
	tiny die-cast Doc the Reindeer,
	tiny die-cast Dopey the Reindeer,
	tiny die-cast Grumpy the Reindeer,
	tiny die-cast Happy the Reindeer,
	tiny die-cast Sleepy the Reindeer,
	tiny die-cast Sneezy the Reindeer,
	tiny die-cast Zeppo the Reindeer,
	tiny die-cast factory worker elf,
	tiny die-cast gift-wrapping elf,
	tiny die-cast middle-management elf,
	tiny die-cast pencil-pusher elf,
	tiny die-cast stocking-stuffer elf,
	tiny die-cast Unionize the Elves Sign,
	tiny die-cast CrimboTown Toy Factory,
	tiny die-cast death ray in a pear tree,
	tiny die-cast turtle mech,
	tiny die-cast Swiss hen,
	tiny die-cast killing bird,
	tiny die-cast golden ring,
	tiny die-cast goose a-laying,
	tiny die-cast swarm a-swarming,
	tiny die-cast blade a-spinning,
	tiny die-cast arc-welding Elfborg,
	tiny die-cast ribbon-cutting Elfborg,
	tiny die-cast Rudolphus of Crimborg,
	tiny die-cast Father Crimborg,
	tiny die-cast Don Crimbo,
	tiny die-cast Uncle Hobo,
	tiny die-cast Father Crimbo];
	setCheckCurrentFigurine(set_name, item_set, mallbuy, acquire_msg);
	
	//Series 007
	set_name = "Series 007";
	acquire_msg = "Obtained daily from IOTM [Kremlin\'s Greatest Briefcase] so just mallbuy it";
	item_set = $items[tiny plastic golden gundam];
	setCheckCurrentFigurine(set_name, item_set, mallbuy, acquire_msg);
}

void manageFigurines()
{
	figurines_settings();
	figurines_getCurrent();
	figurines_getObsolete();
}