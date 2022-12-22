since r27007;

void main()
{
	boolean hastrained = get_property( "_crimboTraining" ).to_boolean();
	if( hastrained )
	{
		print_html( "You've already trained someone today" );
		exit;
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
		hastrained = get_property( "_crimboTraining" ).to_boolean();
		if( hastrained )
		{
			print_html( "Successfully trained " + randomlist[i] );
			exit;
		}
	}
	print_html( "Nobody in chat could be trained, try again later." );
}