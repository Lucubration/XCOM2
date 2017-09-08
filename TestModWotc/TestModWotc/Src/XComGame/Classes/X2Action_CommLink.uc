//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_CommLink extends X2Action;

var localized string m_sCommLinkMessage;

event bool BlocksAbilityActivation()
{
	return false;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
Begin:
	
	`PRES.QueueWorldMessage(m_sCommLinkMessage, Unit.GetLocation(), Unit.GetVisualizedStateReference(), eColor_Bad, , , Unit.m_eTeamVisibilityFlags, , , , , , , , , , , , , true);

	CompleteAction();
}

defaultproperties
{
}

