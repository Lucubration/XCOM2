// Additional Behavior Tree conditions for Alien Rulers DLC.
class X2AIBT_DLC_90Conditions extends X2AIBTDefaultConditions;
const OVERLOAD_ACTIVATION_RANGE = 28; // 28 tiles, ~= dash range + explode range.

static event bool FindBTConditionDelegate(name strName, optional out delegate<BTConditionDelegate> dOutFn, optional out Name NameParam)
{
	dOutFn = None;
	if( ParseNameForNameAbilitySplit(strName, "TargetSoldierClassIs-", NameParam) )
	{
		dOutFn = TargetSoldierClassIs;
		return true;
	}
	if( ParseNameForNameAbilitySplit(strName, "IsAbilityReady-", NameParam) )
	{
		dOutFn = IsAbilityReadyExcludeSacrifice;
		return true;
	}

	switch( strName )
	{
		case 'CanAIUseOverload':
			dOutFn = CanAIUseOverload;
			return true;
		break;
	
		case 'NoTeammateSuppressors':
			dOutFn = NoTeammateSuppressors;
			return true;
		break;

		case 'UpdateOverloadVar':
			dOutFn = UpdateOverloadVar;
				return true;
		break;

		case 'HasOverloaderTeammate':
			dOutFn = HasOverloaderTeammate;
			return true;
		break;
		
		default:
		break;
	}

	return super.FindBTConditionDelegate(strName, dOutFn, NameParam);
}

// Check for Sacrifice - If this ability should be ignored by AI, and any unit is protected with Sacrifice, this returns failure.
function bt_status IsAbilityReadyExcludeSacrifice()
{
	local XGPlayer Player;
	local array<XComGameState_Unit> UnitList;
	local XComGameState_Unit TargetState;

	if( class'X2AIBT_DLC_90Actions'.static.ExcludeAbilityWithSacrifice(SplitNameParam) )
	{
		Player = `BATTLE.GetEnemyPlayer(m_kBehavior.m_kUnit.m_kPlayer);
		Player.GetPlayableUnits(UnitList);
		foreach UnitList(TargetState)
		{
			if( TargetState.IsUnitAffectedByEffectName(class'X2Effect_DLC_3SacrificeShield'.default.EffectName) )
			{
				return BTS_FAILURE;
			}
		}
	}
	return IsAbilityReady();
}
function bt_status CanAIUseOverload()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local int Value;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if( XComHQ != none )
	{
		Value = XComHQ.GetGenericKeyValue("AIFlag_DoNotSelfDestruct");// Key set by Kismet event, SeqAct_XComKVP_Set, for LostTowers map.
		if( Value > 0 ) // -1 == Not found. 0 == Flag disabled.  Set to 1 when Self-Destruct is not valid. 
		{
			return BTS_FAILURE;
		}
	}
	return BTS_SUCCESS;
}

function bt_status NoTeammateSuppressors()
{
	local array<XComGameState_Unit> Teammates;
	local XComGameState_Unit Teammate;
	m_kBehavior.m_kPlayer.GetPlayableUnits(Teammates, true);
	foreach Teammates(Teammate)
	{
		if( Teammate.IsUnitApplyingEffectName(class'X2Effect_Suppression'.default.EffectName) )
		{
			return BTS_FAILURE;
		}
	}
	return BTS_SUCCESS;
}

function bt_status TargetSoldierClassIs()
{
	local XComGameState_Unit TargetState;
	if( m_kBehavior.BT_GetTarget(TargetState) )
	{
		if( TargetState.GetSoldierClassTemplateName()== SplitNameParam )
		{
			return BTS_SUCCESS;
		}
	}
	else
	{
		`LogAIBT("TargetSoldierClass name Check failure - No current target or curr alert data active!  Unit# "$m_kUnitState.ObjectID);
	}
	return BTS_FAILURE;
}

function bt_status HasOverloaderTeammate()
{
	local int OverloaderID;
	local XComGameState_Unit Overloader;
	if( m_kBehavior.BT_HasBTVar('Overloader', OverloaderID) )
	{
		// Value is set.  Check if this unit is alive.
		Overloader = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(OverloaderID));
		if( Overloader != None && Overloader.IsAbleToAct() )
		{
			`LogAIBT("Found Overloader ID == "$OverloaderID@".");
			return BTS_SUCCESS;
		}
		`LogAIBT("Overloader ID == "$OverloaderID@" but is unable to act!");
	}
	else
	{
		`LogAIBT("No overloader has been set this turn.");
	}
	return BTS_FAILURE;
}

// If this is called, we need to update the ShouldOverload unit var
function bt_status UpdateOverloadVar()
{
	local array<XComGameState_Unit> UnitList, FinalList;
	local XComGameState_Unit ListUnitState;
	local float MaxDistSq, DistSq;
	local XGUnit UnitVis;
	local XGAIBehavior UnitBehavior;
	local vector UnitLocation;
	local int RandUnitIndex, Value;

	// BTVars get init-ed with the Player Init.  Only needed during the sequence of BT runs on the AI player turn, not saved out.
	if( class'X2Helpers_DLC_Day90'.static.GetOverloadableFeralMECUnits(UnitList, m_kBehavior.m_kPlayer) )
	{
		// cannot reduce list based on ability availability, since abilities don't get updated until the unit is next to run.
		// For now reduce based on proximity to the enemy.  Remove any units that cannot reach any soldiers.  (cheat??? Soldier Location?)
		MaxDistSq = `TILESTOUNITS(OVERLOAD_ACTIVATION_RANGE);
		MaxDistSq = Square(MaxDistSq);
		foreach UnitList(ListUnitState)
		{
			UnitVis = XGUnit(ListUnitState.GetVisualizer());
			if( UnitVis != None )
			{
				UnitLocation = UnitVis.GetGameStateLocation();
				m_kBehavior.m_kPlayer.GetNearestEnemy(UnitLocation, DistSq); // Note- this only skips critically wounded.  Change?
				if( DistSq > 0 && DistSq < MaxDistSq )
				{
					FinalList.AddItem(ListUnitState);
				}
			}
		}
		// For now we are selecting one nearby Feral MEC each turn randomly to be the chosen one to use Overload.
		if( FinalList.Length > 0 )
		{
			RandUnitIndex = `SYNC_RAND(FinalList.Length);
			ListUnitState = FinalList[RandUnitIndex];
			FinalList.Length = 0;
			FinalList.AddItem(ListUnitState);
		}
		// Set all to false, except the chosen one.
		foreach UnitList(ListUnitState)
		{
			UnitBehavior = XGUnit(ListUnitState.GetVisualizer()).m_kBehavior;
			if( FinalList[0].ObjectID == ListUnitState.ObjectID )
			{
				Value = 1;
			}
			else
			{
				Value = 0;
			}
			UnitBehavior.BT_SetBTVar("ShouldOverload", Value, true);
			UnitBehavior.BT_SetBTVar("Overloader", FinalList[0].ObjectID, true); // Save out the overloader ID for suppression checks.
		}

	}

	return BTS_SUCCESS;
}

defaultproperties
{
}