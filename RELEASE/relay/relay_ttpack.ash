import <scripts/ttpack/util/tt_util.ash>

record setting {
	string name;
	string type;
	string description;
};

setting[string][int] s;
string[string] fields;
boolean success;

void write_styles()
{
	writeln("<style type='text/css'>"+
	"body {"+
	"width: 95%;"+
	"margin: auto;"+
	"background: #EAEAEA;"+
	"text-align:center;" +
	"padding:0;"+
	"cursor:default;"+
	"user-select: none;"+
	"-webkit-user- select: none;"+
	"-moz-user-select: text;}"+

	"h1 {"+
	"font-family:times;" +
	"font-size:125%;"+
	"color:#000;}"+

	"table, th, td {"+
	"border: 1px solid black;}"+
	"</style>");
}

void handleSetting(string type, int x)
{
	string color = "white";
	switch(type)
	{
	case "greygoo":			color = "#6FE26F";		break;
	case "plevel":			color = "#8BDCE7";		break;
	case "tt_aftercore":	color = "#6FE26F";		break;
	case "tt_login":		color = "#8BDCE7";		break;
	default:				color = "#ffffff";		break;
	}

	setting set = s[type][x];
	switch(set.type)
	{
	case "boolean":
		write("<tr bgcolor="+color+"><td align=center>"+set.name+"</td><td align=center><select name='"+set.name+"'>");
		if(get_property(set.name) == "true")
		{
			write("<option value='true' selected='selected'>true</option><option value='false'>false</option>");
		}
		else
		{
			write("<option value='true'>true</option><option value='false' selected='selected'>false</option>");
		}
		writeln("</td><td>"+set.description+"</td></tr>");
		break;
	default:
		writeln("<tr bgcolor="+color+"><td align=center>"+set.name+"</td><td><input type='text' name='"+set.name+"' value='"+get_property(set.name)+"' /></td><td>"+set.description+"</td></tr>");
		break;
	}
	writeln("<input type='hidden' name='"+set.name+"_didchange' value='"+get_property(set.name)+"' />");
}

void write_familiar()
{
	//display current 100% familiar. and options related to it.
	familiar hundred_fam = to_familiar(get_property("auto_100familiar"));
	string to_write;
	if(hundred_fam != $familiar[none])			//we already have a 100% familiar set for this ascension
	{
		if(turns_played() == 0)
		{
			to_write = "100% familiar is set to = " +hundred_fam+ ". Turns played is at 0 so it might be possible to change this. So long as you have not done any free fights<br>";
			writeln(to_write);
			writeln("<form action='' method='post'>");
			writeln("<input type='hidden' name='auto_100familiar' value='none'/>");
			writeln("<input type='submit' name='' value='Disable 100% familiar run'/></form>");
		}
		else
		{
			to_write = "100% familiar is set to = " +hundred_fam+ "<br>";
			writeln(to_write);
		}
	}
	else										//100% familiar not set.
	{
		if(turns_played() == 0)
		{
			writeln("100% familiar has not been set. Turns played is at 0 so it might be possible to change this. So long as you have not done any free fights<br>");
			writeln("<form action='' method='post'>");
			writeln("<input type='hidden' name='auto_100familiar' value='" +my_familiar()+ "'/>");
			writeln("<input type='submit' name='' value='Set current familiar as 100% target'/></form>");
		}
		//we could use an else to report that we are not in a 100% familiar run and it is too late to change it. but there is no need to.
	}
}

void write_settings_key()
{
	//display the key to the settings table.
	writeln("<table><tr><th>Settings Color Codings</th></tr>");
	writeln("<tr bgcolor=#6FE26F><td>greygoo.ash script to automate greygoo ascensions</td></tr>");
	writeln("<tr bgcolor=#8BDCE7><td>plevel.ash script to automate some powerleveling in aftercore</td></tr>");
	writeln("<tr bgcolor=#6FE26F><td>tt_aftercore.ash script to automate aftercore actions</td></tr>");
	writeln("<tr bgcolor=#8BDCE7><td>tt_login.ash script to automate some post login actions</td></tr>");
	writeln("</table>");
}

void main()
{
	
	initializeSettings();	//initialize autoscend settings for this ascension. relevant to ttpack due to shared settings like 100%familiar
	tt_initialize();		//configures ttpack settings to default values on first run and removes depreciated settings.
	
	write_styles();
	writeln("<html><head><title>ttpack manager</title>");
	writeln("</head><body><h1>ttpack manager</h1>");

	//button to interrupt script
	writeln("<form action='' method='post'>");
	writeln("<input type='hidden' name='auto_interrupt' value='true'/>");
	writeln("<input type='submit' name='' value='safely stop scripts'/></form>");
	
	//TODO add buttons to run scripts
	
	write_familiar();		//display current 100% familiar. and options related to it.
	
	//generate settings table
	file_to_map("tt_settings.txt", s);
	fields = form_fields();
	if(count(fields) > 0)
	{
		foreach x in fields
		{
			if(contains_text(x, "_didchange"))
			{
				continue;
			}

			string oldSetting = form_field(x + "_didchange");
			if(oldSetting == fields[x])
			{
				if(get_property(x) != fields[x])
				{
					writeln("You did not change setting " + x + ". It changed since you last loaded the page, ignoring.<br>");
				}
				continue;
			}
			if(get_property(x) != fields[x])
			{
				writeln("Changing setting " + x + " to " + fields[x] + "<br>");
				set_property(x, fields[x]);
			}
		}
	}

	writeln("<form action='' method='post'>");
	writeln("<table><tr><th width=20%>Setting</th><th width=20%>Value</th><th width=60%>Description</th></tr>");
	foreach x in s["greygoo"]
	{
		handleSetting("greygoo", x);
	}
	foreach x in s["plevel"]
	{
		handleSetting("plevel", x);
	}
	foreach x in s["tt_aftercore"]
	{
		handleSetting("tt_aftercore", x);
	}
	foreach x in s["tt_login"]
	{
		handleSetting("tt_login", x);
	}
	writeln("<tr><td align=center colspan='3'><input type='submit' name='' value='Save Changes'/></td></tr></table></form>");

	write_settings_key();		//display the key to the settings table

	writeln("<h2>Info</h2>");
	writeln("Ascension: " + my_ascensions() + "<br>");
	writeln("Day: " + my_daycount() + "<br>");
	writeln("Turns Played: " + my_turncount() + "<br>");
	writeln("ttpack version: " +svn_info("ttpack").last_changed_rev+ "<br>");

	writeln("<br>");
	writeln("</body></html>");
}
