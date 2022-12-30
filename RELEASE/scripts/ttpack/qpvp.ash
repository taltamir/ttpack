//qpvp = quick pvp. just execute the command line "qpvp" to use up all your pvp fights
//configure settings via ttpack gui

void pvpEnable()
{
	if(!hippy_stone_broken())
	{
		visit_url("peevpee.php?action=smashstone&pwd&confirm=on&shatter=Smash+that+Hippy+Crap%21"); 	//break hippy stone
		visit_url("peevpee.php?action=pledge&place=fight&pwd"); 										//pledge allegiance
	}
}

string[int] stances()
{
	int[string] input = current_pvp_stances();
	string[int] retval;
	foreach s, i in input
	{
		retval[i] = s;
	}
	return retval;
}

void main()
{
	pvpEnable();
	if(stances()[0] == "" || !hippy_stone_broken())
	{
		print("qpvp could not break hippy stone. sometimes there is a day or two between pvp seasons where pvp is unavailable. try again tomorrow.", "red");
		print("or if this is not the issue then fix it and run me again. Also please report this at:", "red");
		print("https://github.com/taltamir/ttpack/issues", "red");
		return;
	}
	
	cli_execute("outfit checkpoint");
	string max = get_property("qpvp_maximize");
	if(max != "")
		maximize(get_property("qpvp_maximize"), 0, 0, false, true);
	
	string do = "pvp "+
	get_property("qpvp_reward")+
	" "+
	get_property("qpvp_stance").to_int();
	
	cli_execute(do);
	cli_execute("checkpoint clear");
}
