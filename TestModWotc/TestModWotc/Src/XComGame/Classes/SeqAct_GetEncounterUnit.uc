//-----------------------------------------------------------
//Gets a unit in an encounter group
//-----------------------------------------------------------
class SeqAct_GetEncounterUnit extends SequenceAction;

var XComGameState_Unit Unit;
var Name EncounterID;
var int UnitIndex;

var String EncounterIDString;
var string PrePlacedEncounterTag;

private function ShowRedscreen(string Message)
{
	local string FullObjectName;

	FullObjectName = PathName(self);
	`Redscreen(FullObjectName $ ":\n " $ Message $ "\n Show this to the LDs! David B. added the assert.");
}

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState_AIGroup GroupState;
	local name PrePlacedEncounterTagName;

	History = `XCOMHISTORY;

	if(EncounterIDString != "")
	{
		EncounterID = name(EncounterIDString);
	}

	PrePlacedEncounterTagName = name(PrePlacedEncounterTag);

	foreach History.IterateByClassType(class'XComGameState_AIGroup', GroupState)
	{
		if ((EncounterID != '' && GroupState.EncounterID == EncounterID)
			|| (PrePlacedEncounterTagName != '' && GroupState.PrePlacedEncounterTag == PrePlacedEncounterTagName))
		{
			if (UnitIndex >= GroupState.m_arrMembers.Length)
			{
				ShowRedscreen("Unit Index is out of range!");
			}
			else
			{
				Unit = XComGameState_Unit(History.GetGameStateForObjectID(GroupState.m_arrMembers[UnitIndex].ObjectID));
				if (Unit == none)
				{
					ShowRedscreen("Could not find unit state for object ID " $ GroupState.m_arrMembers[UnitIndex].ObjectID);
				}
			}

			return;
		}
	}

	ShowRedscreen("Could not find AI encounter!");
	Unit = none;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Get Encounter Unit"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit, bWriteable=true)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="EncounterID",PropertyName=EncounterIDString)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="Unit Index",PropertyName=UnitIndex)
	VariableLinks(3)=(ExpectedType=class'SeqVar_String',LinkDesc="PreplacedEncounterTag",PropertyName=PrePlacedEncounterTag)
}
