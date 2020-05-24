//this script should be run automatically after the king is liberated. which ends hardcore/ronin restrictions

import <ttpack/tt_util.ash>

void changeSettingsForAftercore()
{
	//change assorted mafia settings for aftercore.
	print("Configuring recovery settings for aftercore", "blue");
	set_property("recoveryScript", "scripts\\Universal_recovery.ash");
	set_property("hpAutoRecovery", "0.7");
	set_property("hpAutoRecoveryTarget", "1.0");
	set_property("mpAutoRecovery", "0.1");
	set_property("mpAutoRecoveryTarget", "0.15");
	set_property("manaBurningTrigger", "1.0");
	set_property("manaBurningThreshold", "0.5");
	cli_execute("ccs aftercore");
}

void main()
{
	if(!inAftercore())
	{
		abort("This script should only be run after the king was liberated");
	}
	print("Running tt_kingliberated script", "blue");
	
	changeSettingsForAftercore();			//change assorted mafia settings for aftercore.
	
	print("Pulling all items from hangk's ancestral storage", "blue");
	cli_execute("pull all");				//pull all hangk items
	
	cli_execute("tt_login.ash");			//run login script
	cli_execute("fortunereply.ash");		//reply to zatara fortunes.
	cli_execute("pvprotect.ash");			//closet pvp stealable items
	cli_execute("cc_snapshot.ash");			//display your greenboxes

	if(item_amount($item[Bitchin\' Meatcar]) == 0)
	{
		print("acquire bitchin\' meatcar", "blue");
		retrieve_item(1, $item[Bitchin\' Meatcar]);
	}

	if(pvp_attacks_left() > 0)
	{
		print("Using up all PvP attacks", "blue");
		cli_execute("outfit pvp; pvp flowers 0;");
	}

	print("tt_kingliberated script finished", "blue");
}