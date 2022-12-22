since r27007;

boolean hastrained()
{
	return get_property( "_crimboTraining" ).to_boolean();
}

void main()
{
	if(get_clan_id( ) == -1)
	{
		return;
	}
	if(item_amount($item[Crimbo training manual]) == 0)
	{
		return;
	}
	if( hastrained() )
	{
		return;
	}
	boolean[string] clannies = who_clan();
	string[int] randomlist;
	int i = 0;
	foreach name in clannies
	{
		randomlist[i++] = name;
	}
	sort randomlist by random(1000000);
	for( i = 0; i < randomlist.count(); i++ )
	{
		cli_execute( "try; crimbotrain " + randomlist[i] );
		if( hastrained() )
		{
			print( "crimbo22train successfully trained " + randomlist[i] );
			return;
		}
	}
	print( "crimbo22train could not find anyone in your clan to train." );
}
