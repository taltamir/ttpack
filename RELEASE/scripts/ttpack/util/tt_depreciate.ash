//adjust settings for ttpack by removing defunct settings or renaming them as needed. meant to be imported.

void tt_depreciate()
{
	//remove depreciated settings
	remove_property("guzzlr_autoSpade");
	remove_property("greygoo_bakeryHardcoreUnlock");
	remove_property("greygoo_bakerySoftcoreUnlock");
	remove_property("greygoo_guildUnlock");
	remove_property("tt_aftercore_buyStuff");
	remove_property("aftercore_buyStuff");
}

void tt_settingsUpgrade()
{
	//upgrade settings from old format to new format
	auto_rename_property("tt_aftercore_fatLootToken", "aftercore_fatLootToken");
	auto_rename_property("tt_aftercore_iceHouseAMC", "aftercore_iceHouseAMC");
	auto_rename_property("tt_aftercore_guildUnlock", "aftercore_guildUnlock");
	auto_rename_property("tt_aftercore_meatFarm", "aftercore_meatFarm");
	auto_rename_property("tt_aftercore_useAstralLeftovers", "aftercore_useAstralLeftovers");
	auto_rename_property("tt_aftercore_eatSurpriseEggs", "aftercore_eatSurpriseEggs");
	auto_rename_property("tt_aftercore_consumeAll", "aftercore_consumeAll");
	auto_rename_property("tt_login_auto", "tt_login_autoscend");
}
