
class UIFacility_CIC extends UIFacility;

var public localized string m_strFacilitySummary;

//----------------------------------------------------------------------------
// MEMBERS

// ------------------------------------------------------------

simulated function RealizeNavHelp()
{
	NavHelp.ClearButtonHelp(); // bsg-jrebar (4.4.17): Clear Nav Help so that the buttons all clear and reset properly
	NavHelp.bIsVerticalHelp = `ISCONTROLLERACTIVE;
	if(class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M1_WelcomeToLabs'))
	{
		NavHelp.AddBackButton(OnCancel);
		
		NavHelp.AddSelectNavHelp(); //bsg-crobinson (3.15.17) Adds in select button that was previously missing
	}
	
	NavHelp.AddGeoscapeButton();
}

simulated function FacilitySummary()
{
	Movie.Stack.Push(Spawn(class'UIFacilitySummary', PC.Pres));
}

simulated function ViewObjectives()
{
	Movie.Stack.Push(Spawn(class'UIViewObjectives', PC.Pres), PC.Pres.Get3DMovie());
}

simulated function OnCancel()
{
	if(class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M1_WelcomeToLabs'))
	{
		super.OnCancel();
	}
}

//==============================================================================

defaultproperties
{
	InputState = eInputState_Evaluate;
}
