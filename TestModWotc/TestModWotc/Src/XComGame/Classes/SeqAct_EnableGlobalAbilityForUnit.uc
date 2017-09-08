class SeqAct_EnableGlobalAbilityForUnit extends SequenceAction;

var() name AbilityName;
var XComGameState_Unit Unit;

event Activated()
{
	local XComGameState NewGameState;
	local XComGameState_Unit NewUnitState;

	if (Unit != none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Kismet - EnableGlobalAbilityForUnit");
		NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(Unit.Class, Unit.ObjectID));

		if(InputLinks[0].bHasImpulse)
		{
			NewUnitState.EnableGlobalAbilityForUnit(AbilityName);
		}
		else if(InputLinks[1].bHasImpulse)
		{
			NewUnitState.DisableGlobalAbilityForUnit(AbilityName);
		}
		
		`GAMERULES.SubmitGameState(NewGameState);
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

DefaultProperties
{
	ObjName="Enable Global Ability For Unit"
	ObjCategory="Unit"
	bCallHandler=false
	bAutoActivateOutputLinks=true;

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit)
}