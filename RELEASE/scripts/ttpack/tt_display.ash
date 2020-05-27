//This is a script for acquiring and displaying tiny plastic or die casted figurines.
//mainly for the achievement, but also just to have.

import <scripts/ttpack/util/tt_util.ash>
import <ttpack/display/tt_display_figurines.ash>
import <ttpack/display/tt_display_hobopolis.ash>
import <ttpack/display/tt_display_crimbo2019.ash>

void help()
{
	print("Welcome to tt_display" , "blue");
	print("To use type in gCLI:");
	print("tt_display [goal]");
	print("Currently supported options for [goal]:");
	print("figurines = display tiny plastic and die casted figurines. A set of collectors items with several associated trophies");
	print("hobopolis = auto zap hobopolis gear 1/day if you have a zapwand. display excess gear");
	print("hobo = same as hobopolis");
	print("crimbo2019 = display and count the rare drops from crimbo2019. display the counts and their mall values");
	print("crimbo19 = same as crimbo2019");
}

void main(string goal)
{
	if(!have_display())
	{
		abort("You do not own a display case");
	}
	if(!can_interact())
	{
		abort("You do not have unlimited mall access. liberate the king or break ronin");
	}
	
	tt_depreciate();	//adjust renamed settings. delete deleted settings.
	
	cli_execute("pull all");

	goal = to_lower_case(goal);
	if(goal == "figurines")
	{
		manageFigurines();
	}
	else if(goal == "hobopolis" || goal == "hobo")
	{
		manageHoboItems();
	}
	else if(goal == "crimbo2019" || goal == "crimbo19")
	{
		manageCrimbo2019();
	}
	else help();
}