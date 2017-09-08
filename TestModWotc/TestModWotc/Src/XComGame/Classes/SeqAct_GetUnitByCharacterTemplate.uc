class SeqAct_GetUnitByCharacterTemplate extends SequenceAction;

var name CharacterTemplateName;
var XComGameState_Unit Unit;
var string CharacterTemplateNameString;

event Activated()
{
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	if(CharacterTemplateName == '')
	{
		if(CharacterTemplateNameString != "")
		{
			CharacterTemplateName = name(CharacterTemplateNameString);
		}
		else
		{
			`Redscreen("SeqAct_GetUnitByCharacterTemplate: No Template specified for retrieval");
			return;
		}
	}

	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if(Unit.GetMyTemplateName() == CharacterTemplateName && Unit.IsAlive() && !Unit.bRemovedFromPlay)
		{
			return;
		}
	}

	// no such unit template was found
	`Redscreen("SeqAct_GetUnitByCharacterTemplate: Could not find a unit with template " $ string(CharacterTemplateName));
	Unit = none;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Get Unit By Character Template"
	ObjCategory="Unit"
	bCallHandler=false
	bAutoActivateOutputLinks=true

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty;
	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="Template",PropertyName=CharacterTemplateNameString)
	VariableLinks(1)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit,bWriteable=true)
}