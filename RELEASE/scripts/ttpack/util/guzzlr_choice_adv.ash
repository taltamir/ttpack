script "guzzlr_choice_adv.ash";
import <autoscend/auto_choice_adv.ash>

boolean guzzlr_run_choice(int choice, string page)
{
	print("Running guzzlr_choice_adv.ash");
	
	switch (choice) {
		case 670: // You Don't Mess Around with Gym
			run_choice(4);	//skip NC and save an adv
			break;
		case 1341: // A Pound of Cure
			run_choice(1);	//cure patient
			break;	
		default:
			return auto_run_choice(choice, page);
			break;
	}
	
	return true;
}

void main(int choice, string page)
{
	boolean ret = false;
	try
	{
		ret = guzzlr_run_choice(choice, page);
	}
	finally
	{
		if (!ret)
		{
			auto_log_error("Error running guzzlr_choice_adv.ash, setting auto_interrupt=true");
			set_property("auto_interrupt", true);
		}
	}
}