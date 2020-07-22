script "guzzlr_choice_adv.ash";
import <autoscend/auto_choice_adv.ash>

void guzzlr_run_choice(int choice, string page)
{
	print("Running guzzlr_choice_adv.ash");
	
	switch (choice) {
		case 670: // You Don't Mess Around with Gym
			run_choice(4);
			break;
		default:
			auto_run_choice(choice, page)
			break;
	}
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