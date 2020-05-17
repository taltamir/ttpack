//This is a script for acquiring and displaying tiny plastic or die casted figurines.
//mainly for the achievement, but also just to have.

import <ttpack/tt_util.ash>
import <ttpack/display/tt_display_figurines.ash>

void manageHoboItems()
{
	//hobo_settings();
}

void help()
{
	print("To use type in gCLI:" , "blue");
	print("tt_display [goal]" , "blue");
	print("Currently supported options for [goal]:" , "blue");
	print("figurines = display tiny plastic and die casted figurines. A set of collectors items with several associated trophies" , "blue");
	print("hobo = auto zap hobo gear 1/day if you have a zapwand. display excess gear" , "blue");
}

void main(string goal)
{
	if(!have_display())
	{
		abort("You do not own a display case");
	}
	if(!can_interact())
	{
		abort("You do not have unlimited mall access. Break prism or ronin");
	}
	
	tt_depreciate();
	
	goal = to_lower_case(goal);
	if(goal == "figurines")
	{
		manageFigurines();
	}
	else if(goal == "hobo")
	{
		manageHoboItems();
	}
	else help();
}