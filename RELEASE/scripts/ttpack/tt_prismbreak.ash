//this script should be run automatically after the prism is broken (and thus ending hardcore/ronin restrictions)
//history
//2020-03-23: set recovery script to universal recovery for aftercore.
//2020-03-01: remove auto mojo filters, those are taken care of in tt_login. print notice that about to pvp.
//2020-02-28: adjusted filename for login script
//2019-11-10: auto use mojo filters
//v3 calls login script and removes some redundant things done there such as meteorite-ade.
//v2 uses cleaner code for Meteorite-Ade, and only consumes them if you are a millionaire.

print("");
print("Running prismbreak script", "green");
print("");

//set MP recovery, HP recovery, CCS, and buff balancing for aftercore
print("");
print("Setting MP recovery, HP recovery, CCS, and buff balancing for aftercore", "green");
print("");
set_property("hpAutoRecovery", "0.70");
set_property("hpAutoRecoveryTarget", "1.00");
set_property("mpAutoRecovery", "0.10");
set_property("mpAutoRecoveryTarget", "0.15");
set_property("manaBurningTrigger", "1.00");
set_property("manaBurningThreshold", "0.50");
cli_execute("ccs aftercore");

//pull all items out of hagnk ancestral storage.
print("");
print("Pulling all items from hangk's ancestral storage", "green");
print("");
cli_execute("pull all");

//reply to fortune teller requests
print("");
print("Replying to all clanmate fortune teller requests", "green");
print("");
cli_execute("call fortunereply.ash");

//visit old man by the sea before doing breakfast to start sea quest so that breakfast can get sea jelly
visit_url("place.php?whichplace=sea_oldman&action=oldman_oldman");

//run breakfast
print("");
print("Executing breakfast script", "green");
print("");
cli_execute("Breakfast");

//run OCD Inventory Control
if(have_shop())
{
	print("");
	print("Executing OCD Inventory Control script", "green");
	print("");
	cli_execute("OCDInv.ash");
}

//run pvpprotect
print("");
print("Executing pvpprotect script", "green");
print("");
cli_execute("call pvprotect.ash");

//run cc_snapshot script
print("");
print("Executing cc_snapshot script", "green");
print("");
cli_execute("call cc_snapshot.ash");

//acquire bitchin' meatcar if you don't already have it.
print("");
print("acquire bitchin' meatcar if you don't already have it", "green");
print("");
cli_execute("acquire bitchin");

//run login script to do various things.
cli_execute("tt_login.ash");

//PVP
print("");
print("Using up all PvP attempts", "green");
print("");
cli_execute("outfit pvp; pvp flowers 0;");

//Set recovery script for aftercore
print("");
print("Setting recovery script to Universal Recovery for aftercore", "green");
print("");
set_property("recoveryScript", "scripts\\Universal_recovery.ash");

//notify player that you are done.
print("");
print("prismbreak script finished", "green");
print("");