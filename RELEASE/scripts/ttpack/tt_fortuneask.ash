//This script uses CLI command to perform a fortune request on clanmates (if uses remain today, to avoid aborting on failure).
//It will automatically set the correct asking words for the people being asked to get a high reward.
//Currently populated with clanmates from FCA clan. Change the names in void main.
//History:
//2019-10-23 - replaced relaybot with chatplanet bot.

//CONFIG START - set your options below

boolean compatible = true;			//true to get compatible rewards from zatara, false to get incompatible rewards

//CONFIG ENDS

//the function below takes in a name and performs a fortune request after testing for some contingencies
void doFortune(string name)
{
	//skip asking fortune if you already asked 3 times today (max allowed). without this you will get an error that aborts further automation.
	if (get_property("_clanFortuneConsultUses").to_int() < 3)
	{
		//skip asking fortune from yourself
		if (get_property("lastUsername").to_string() != name)
		{
			cli_execute("fortune " + name);
		}
	}
}

void main()
{
	if(item_amount($item[Clan VIP Lounge key]) == 0)
	{
		return;
	}
	
	//check if there are consults left today, and if so consult with FCA defaults
	if (get_property("_clanFortuneConsultUses").to_int() < 3)
	{
		//set fortune asking words to FCA answers if compatible is set to true. make it wrong if compatible is set to false.
		if (compatible)
			{
				set_property("clanFortuneWord1", "burger");
				set_property("clanFortuneWord2", "batman");
				set_property("clanFortuneWord3", "thick");
			}
			else
			{
				set_property("clanFortuneWord1", "incompatible");
			}
		
		//below are the clanmates who respond with FCA defaults. prioritizing the bots.
		doFortune("ChatPlanet");
		doFortune("Parry Hotter");
		doFortune("BleedingPony");
		doFortune("Born Identities");
		doFortune("caducus");
		doFortune("Cruithne");
		doFortune("Detyan");
		doFortune("Dr Ragon");
		doFortune("guaranteed");
		doFortune("Hekiryuu");
		doFortune("Pont Speedchunk");
		doFortune("Stevezy");
		doFortune("Versil");
		//doFortune("CroThunder");		//doesn't use mafia, so misspells are a possibility.
	}
	
	//check if there are consults left today, and if so consult with mafia defaults
	if (get_property("_clanFortuneConsultUses").to_int() < 3)
	{
		//set fortune asking words to mafia default answers if compatible is set to true. make it wrong if compatible is set to false.
		if (compatible)
			{
				set_property("clanFortuneWord1", "pizza");
				set_property("clanFortuneWord2", "batman");
				set_property("clanFortuneWord3", "thick");
			}
		else
			{
				set_property("clanFortuneWord1", "incompatible");
			}
		
		//below are the clanmates who respond with mafia defaults.
		doFortune("taltamir");
		doFortune("Albatross");
		doFortune("Broken Golem");
		doFortune("Tortoise Roendersen");
		doFortune("DiFranco");
		doFortune("EstroJenn");
		doFortune("Hiroto");
		doFortune("JAD");
		doFortune("MinaPoe");
		doFortune("Salty Waters");
		doFortune("Soloflex");
		doFortune("Solohan50");
		doFortune("Lump the Loquacious");
	}
	
	//check how many consults remain, and warns the user if you ran out of people to ask but still have consults remaining.
	if (get_property("_clanFortuneConsultUses").to_int() == 3)
	{
		print("");
		print("Success: Fortuneask complete, all 3 fortune consults were sent today", "green");
		print("");
	}
	else
	{
		int remainingConsults = 3 - get_property("_clanFortuneConsultUses").to_int();
		print("");
		print("Warning: Fortuneask ran out of clanmates to consult about fortunes. Remaining consults:" + remainingConsults, "red");
		print("");
	}
}
