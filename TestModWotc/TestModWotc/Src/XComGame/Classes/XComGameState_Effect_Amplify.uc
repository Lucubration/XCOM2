class XComGameState_Effect_Amplify extends XComGameState_Effect;

var int ShotsRemaining;

function PostCreateInit(EffectAppliedData InApplyEffectParameters, GameRuleStateChange WatchRule, XComGameState NewGameState)
{
	local XComGameState_Unit SourceUnit;

	super.PostCreateInit(InApplyEffectParameters, WatchRule, NewGameState);

	SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(InApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit == none)
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(InApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnit != none);

	ShotsRemaining = SourceUnit.GetTemplarFocusLevel();
}