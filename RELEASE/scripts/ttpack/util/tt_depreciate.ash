//adjust settings for ttpack by removing defunct settings or renaming them as needed. meant to be imported.

void tt_depreciate()
{
	//remove depreciated settings
	remove_property("guzzlr_autoSpade");
	remove_property("greygoo_bakeryHardcoreUnlock");
	remove_property("greygoo_bakerySoftcoreUnlock");
	remove_property("greygoo_guildUnlock");
}

void cleanup_property(string target)
{
	//we need to clear out empty property that exist with an empty value.
	//aside from being messy they also cause problems such as rename_property refusing to work.
	if(get_property(target) == "" && property_exists(target))
	{
		remove_property(target);
	}
}

void tt_rename_property(string oldprop, string newprop)
{
	cleanup_property(oldprop);
	cleanup_property(newprop);
	if(!property_exists(oldprop) || property_exists(newprop))
	{
		return;
	}
	rename_property(oldprop,newprop);
}

void tt_settingsUpgrade()
{
	//upgrade settings from old format to new format
	tt_rename_property("tt_aftercore_fatLootToken", "aftercore_fatLootToken");
	tt_rename_property("tt_aftercore_iceHouseAMC", "aftercore_iceHouseAMC");
	tt_rename_property("tt_aftercore_guildUnlock", "aftercore_guildUnlock");
	tt_rename_property("tt_aftercore_meatFarm", "aftercore_meatFarm");
	tt_rename_property("tt_aftercore_useAstralLeftovers", "aftercore_useAstralLeftovers");
	tt_rename_property("tt_aftercore_buyStuff", "aftercore_buyStuff");
	tt_rename_property("tt_aftercore_eatSurpriseEggs", "aftercore_eatSurpriseEggs");
	tt_rename_property("tt_aftercore_consumeAll", "aftercore_consumeAll");
}
