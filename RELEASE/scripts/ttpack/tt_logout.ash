//This script should be set to auto run on logout

import <scripts/ttpack/util/tt_util.ash>

void main()
{
	cli_execute("breakfast");				//Run mafia built in breakfast script to do many daily tasks
	cli_execute("tt_fortune.ash");			//reply and send zatara fortune teller requests
	cli_execute("pvprotect.ash");			//closet your expensive pvpable items
	
}