//This script should be set to auto run on pre-ascension
//Version History
// 2020-04-30 added void displayTake() for instant karma
// 2020-03-23 set recovery script to none before ascending


//replies to all zatara fortune teller requests with whatever you configured as mafia's default
void fortuneReply()
{
	buffer page = visit_url("clan_viplounge.php?preaction=lovetester");

	string [int][int] request_array = page.group_string("(clan_viplounge.php\\?preaction=testlove&testlove=\\d*)\">(.*?)</a>");

	foreach i in request_array 
	{
		string response_url = request_array[i][1].replace_string("preaction\=testlove","preaction\=dotestlove") + "&pwd&option=1&q1=" + get_property("clanFortuneReply1") + "&q2=" + get_property("clanFortuneReply2") + "&q3=" + get_property("clanFortuneReply3");
		visit_url(response_url);
		print("Response sent to " + request_array[i][2] + ".", "green");
	}
}

void displayTake()
{
	if(!have_display()) return;
	
	int instant_karma_to_take = 0;
	if(display_amount($item[instant karma]) > 1)
	{
		instant_karma_to_take = min(10, (display_amount($item[instant karma]) - 1));
	}
	if(instant_karma_to_take > 0)
	{
		take_display(instant_karma_to_take, $item[instant karma]);
	}
}

void main()
{
	fortuneReply();							//replies to all zatara fortune consult with mafia default (configurable via mafia)
	if(pvp_attacks_left() > 0)				//if you accidentally entered valhalla without using all your pvp
		{
		cli_execute("outfit pvp");			//wear pvp outfit
		cli_execute("pvp flowers 0");		//burn remaining pvp fights. set for average season.
		}
	cli_execute("breakfast");				//run mafia's built in breakfast
	cli_execute("combbeach 1111");			//burn all remaining adventures on beach combing before ascension.
	cli_execute("briefcase unlock");		//unlock the briefcase using ezandora script (must be installed seperately)
	cli_execute("briefcase collect");		//collect 3x epic drinks using ezandora script (must be installed seperately)
	if(have_shop())
	{
		cli_execute("OCDInv.ash");			//run OCD inventory control script (must be installed seperately)
	}
	cli_execute("Rollover Management.ash");			//runs the rollover management script (must be installed seperately)
	cli_execute("cc_snapshot.ash");			//runs the cc snapshot script (must be installed seperately)
	set_property("recoveryScript", "");		//set recovery script to none before ascending
	displayTake();							//take certain items from display so you could use them.
}