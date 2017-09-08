//-----------------------------------------------------------
// Ends a battle
//-----------------------------------------------------------
class SeqAct_EndBattle extends SequenceAction;

// If this battle was lost, specify if its unfailable.
var() UICombatLoseType LoseType;

// If true, this node will also generate a replay save that can be used to replay this mission, up to and including the
// save
var() bool GenerateReplaySave;

event Activated()
{
	local XComGameStateHistory History;
	local X2TacticalGameRuleset Ruleset;
	local XComGameState_Player PlayerState;
	local array<ETeam> Teams;
	local ETeam ImpulseTeam;
	local int ImpulseIdx;
	
	History = `XCOMHISTORY;
	if(History == none) return;

	Ruleset = `TACTICALRULES;
	if(Ruleset == none) return;

	Teams.AddItem(eTeam_XCom);
	Teams.AddItem(eTeam_Alien);
	Teams.AddItem(eTeam_One);
	Teams.AddItem(eTeam_Two);
	Teams.AddItem(eTeam_TheLost);
	Teams.AddItem(eTeam_Resistance);

	for (ImpulseIdx = 0; ImpulseIdx < InputLinks.Length; ++ImpulseIdx)
	{
		if (InputLinks[ImpulseIdx].bHasImpulse)
		{
			ImpulseTeam = Teams[ImpulseIdx];
			break;
		}
	}

	foreach History.IterateByClassType(class'XComGameState_Player', PlayerState)
	{
		if (PlayerState.TeamFlag == ImpulseTeam)
		{
			Ruleset.EndBattle(XGPlayer(PlayerState.GetVisualizer()), LoseType, GenerateReplaySave);
			break;
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
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="Gameplay"
	ObjName="End Battle"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	InputLinks(0)=(LinkDesc="XCom Victory")
	InputLinks(1)=(LinkDesc="Alien Victory")
	InputLinks(2)=(LinkDesc="Team One Victory")
	InputLinks(3)=(LinkDesc="Team Two Victory")
	InputLinks(4)=(LinkDesc="The Lost Victory")
	InputLinks(5)=(LinkDesc="Resistance Victory")

	OutputLinks.Empty
	VariableLinks.Empty
}
