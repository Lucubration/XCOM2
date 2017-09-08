//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Yell extends X2Action;

var localized string m_sYellMessage;

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	function DoEnemyFallbackVO()
	{
		local XGPlayer AIPlayer;
		local XGUnit XComUnit;
		AIPlayer = Unit.GetPlayer();
		XComUnit = AIPlayer.GetNearestEnemy(Unit.Location);
		XComUnit.UnitSpeak('AlienRetreat');
	}
Begin:
	
	if( `CHEATMGR.bWorldDebugMessagesEnabled )
	{
		`PRES.QueueWorldMessage(m_sYellMessage, Unit.GetLocation(), Unit.GetVisualizedStateReference(), eColor_Bad, , , Unit.m_eTeamVisibilityFlags, , , , , , , , , , , , , true);
	}
	if( Unit.GetTeam() == eTeam_Neutral )
	{
		Unit.UnitSpeak('PanicScream'); // TODO- Replace with a new civilian speech enum.
	}
	else
	{
		// Scott W says that ALERT and TargetSighted should be used in the same situations
		// that TargetSpotted would be used by xcom.  mdomowicz 2015_06_30
		if (Unit.GetTeam() == eTeam_Alien )
		{
			if( Unit.IsFallingBack() )
			{
				// Kick off the soldier VO announcing that the AI is falling back.
				DoEnemyFallbackVO();
			}
			else
			{
				if( Rand(2) == 0 )
					Unit.UnitSpeak('TargetSighted');
				else
					Unit.UnitSpeak('ALERT');
			}
		}
		else
		{
			Unit.UnitSpeak('TargetSpotted');
		}
	}

	CompleteAction();
}

defaultproperties
{
}

