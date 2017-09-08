//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_ConcealmentLost extends X2Action;

var localized string m_sConcealmentLostMessage;

//------------------------------------------------------------------------------------------------
simulated state Executing
{
Begin:
	if( `CHEATMGR.bWorldDebugMessagesEnabled )
	{
		`PRES.QueueWorldMessage(m_sConcealmentLostMessage, Unit.GetLocation(), Unit.GetVisualizedStateReference(), eColor_Bad, , , Unit.m_eTeamVisibilityFlags, , , , , , , , , , , , , true);
	}

	CompleteAction();
}

defaultproperties
{
	bCauseTimeDilationWhenInterrupting = true
}

