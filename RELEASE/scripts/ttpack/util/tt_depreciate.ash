//adjust settings for ttpack by removing defunct settings or renaming them as needed. meant to be imported.

void tt_depreciate()
{
	//remove depreciated settings
	remove_property("guzzlr_autoSpade");
	remove_property("greygoo_bakeryHardcoreUnlock");
	remove_property("greygoo_bakerySoftcoreUnlock");
	remove_property("greygoo_guildUnlock");
}

void rename_property(string old, string new)
{
	if(get_property(old) == "")
	{
		return;
	}
	set_property(new, get_property(old));
	remove_property(old);
}

void tt_settingsUpgrade()
{
	//upgrade settings from old format to new format
	rename_property("tt_aftercore_fatLootToken", "aftercore_fatLootToken");
	rename_property("tt_aftercore_iceHouseAMC", "aftercore_iceHouseAMC");
	rename_property("tt_aftercore_guildUnlock", "aftercore_guildUnlock");
	rename_property("tt_aftercore_meatFarm", "aftercore_meatFarm");
	rename_property("tt_aftercore_useAstralLeftovers", "aftercore_useAstralLeftovers");
	rename_property("tt_aftercore_buyStuff", "aftercore_buyStuff");
	rename_property("tt_aftercore_eatSurpriseEggs", "aftercore_eatSurpriseEggs");
	rename_property("tt_aftercore_consumeAll", "aftercore_consumeAll");
}
