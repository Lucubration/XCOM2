//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_SpottedUnit extends X2Action;

var localized string m_sSpottedUnitMessage;
var localized string m_sUnspottedUnitMessage;
var bool m_bBecomeUnspotted;

function SetSpottedParameter( bool bBecomeUnspotted )
{
	m_bBecomeUnspotted = bBecomeUnspotted;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
Begin:
	
	if (Unit.IsAlive())
	{
		if (m_bBecomeUnspotted)
		{
			Unit.m_bSpotted = false;
			if( `CHEATMGR.bWorldDebugMessagesEnabled )
			{
				`PRES.QueueWorldMessage(m_sUnspottedUnitMessage, Unit.GetLocation(), Unit.GetVisualizedStateReference(), eColor_Good, , , Unit.m_eTeamVisibilityFlags, , , , , , , , , , , , , true);
			}
		}
		else
		{
			Unit.m_bSpotted = true;
			if( `CHEATMGR.bWorldDebugMessagesEnabled )
			{
				`PRES.QueueWorldMessage(m_sSpottedUnitMessage, Unit.GetLocation(), Unit.GetVisualizedStateReference(), eColor_Bad, , , Unit.m_eTeamVisibilityFlags, , , , , , , , , , , , , true);
			}
		}
		`PRES.m_kUnitFlagManager.RespondToNewGameState(Unit, None);
	}

	CompleteAction();
}

defaultproperties
{
	bCauseTimeDilationWhenInterrupting = true
}

