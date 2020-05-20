//this script should be run automatically after the king is liberated. which ends hardcore/ronin restrictions

import <ttpack/tt_util.ash>

void changeSettingsForAfter()
{
	//change assorted mafia settings for aftercore.
	print("Configuring recovery settings for aftercore", "blue");
	set_property("recoveryScript", "scripts\\Universal_recovery.ash");
	set_property("hpAutoRecovery", "0.70");
	set_property("hpAutoRecoveryTarget", "1.00");
	set_property("mpAutoRecovery", "0.10");
	set_property("mpAutoRecoveryTarget", "0.15");
	set_property("manaBurningTrigger", "1.00");
	set_property("manaBurningThreshold", "0.50");
	cli_execute("ccs aftercore");
}

void main()
{
	if(!in_aftercore())
	{
		abort("This script should only be run after the king was liberated");
	}
	
	print("");
	print("Running tt_kingliberated script", "blue");
	print("");

	changeSettingsForAfter();				//change assorted mafia settings for aftercore.
	
	print("Pulling all items from hangk's ancestral storage", "blue");
	cli_execute("pull all");				//pull all hangk items
	
	cli_execute("tt_login.ash");			//run login script
	
	cli_execute("call fortunereply.ash");	//reply to zatara fortunes.

	print("Executing pvpprotect script", "blue");
	cli_execute("call pvprotect.ash");

	print("Executing cc_snapshot script", "blue");
	cli_execute("call cc_snapshot.ash");

	print("acquire bitchin' meatcar if you don't already have it", "blue");
	retrieve_item(1, $item[Bitchin\' Meatcar]);

	print("Using up all PvP attempts", "blue");
	cli_execute("outfit pvp; pvp flowers 0;");

	print("");
	print("tt_kingliberated script finished", "blue");
	print("");
}