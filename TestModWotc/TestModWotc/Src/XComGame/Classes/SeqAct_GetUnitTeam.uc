//-----------------------------------------------------------
//Gets the location of an xcom unit
//-----------------------------------------------------------
class SeqAct_GetUnitTeam extends SequenceAction;

var XComGameState_Unit Unit;

var() bool GetOriginalTeamIfMindControlled;

event Activated()
{
	local XComGameState_Player PlayerState;
	local ETeam TeamFlag;
	local int OutputIndex;
	local int Index;

	for (Index = 0; Index < OutputLinks.Length; ++Index)
	{
		OutputLinks[Index].bHasImpulse = false;
	}

	if (Unit != none)
	{
		PlayerState = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(Unit.GetAssociatedPlayerID()));
		TeamFlag = PlayerState.TeamFlag;
		if( GetOriginalTeamIfMindControlled && Unit.IsMindControlled() )
		{
			TeamFlag = Unit.GetPreviousTeam();
		}

		switch( TeamFlag )
		{
		case eTeam_XCom:
			OutputIndex = 0;			
			break;
		case eTeam_Alien:
			OutputIndex = 1;			
			break;
		case eTeam_Neutral:
			OutputIndex = 2;			
			break;
		case eTeam_TheLost:
			OutputIndex = 3;
			break;
		case eTeam_Resistance:
			OutputIndex = 4;
			break;
		}

		if (OutputIndex < OutputLinks.Length)
		{
			OutputLinks[OutputIndex].bHasImpulse = true;
		}
	}
}

/**
* Return the version number for this class.  Child classes should increment this method by calling Super then adding
* a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
* link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
* Super.GetObjClassVersion() should be incremented by 1.
*
* @return	the version number for this specific class.
*/
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Get Unit Team"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	bAutoActivateOutputLinks=false
	OutputLinks(0)=(LinkDesc="XCom")
	OutputLinks(1)=(LinkDesc="Alien")
	OutputLinks(2)=(LinkDesc="Civilian")
	OutputLinks(3)=(LinkDesc="TheLost")
	OutputLinks(4)=(LinkDesc="Resistance")

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
}
