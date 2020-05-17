set_property("choiceAdventure675", 1);
set_property("choiceAdventure676", 4);
set_property("choiceAdventure677", 4);
set_property("choiceAdventure678", 2);
set_property("currentMood", "meat");

if(have_familiar($familiar[Lil\' Barrel Mimic]));
{
	use_familiar($familiar[Lil\' Barrel Mimic]);
}

maximize("meat, equip mafia thumb ring, effective", false);

adv1($location[The Castle in the Clouds in the Sky (Top Floor)], -1, "");