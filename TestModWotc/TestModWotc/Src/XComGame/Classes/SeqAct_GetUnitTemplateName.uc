class SeqAct_GetUnitTemplateName extends SequenceAction;

var string CharacterTemplateString;
var XComGameState_Unit Unit;

event Activated()
{
	if (Unit != none)
	{
		CharacterTemplateString = string(Unit.GetMyTemplateName());
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Get Character Template name from Unit"
	ObjCategory="Unit"
	bCallHandler=false
	bAutoActivateOutputLinks=true

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty;
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit,bWriteable=false)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Name',LinkDesc="Unused")
	VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="TemplateString",PropertyName=CharacterTemplateString,bWriteable=true)
}