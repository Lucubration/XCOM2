class X2Effect_DLC_Day60TurnStartRemoveActionPoints extends X2Effect_Persistent;

var bool bApplyToRevealedAIOnly;

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local int UnusedPoints, GrantedPoints, Point;
	if( bApplyToRevealedAIOnly && UnitState.IsUnrevealedAI() )
		return;

	ActionPoints.Length = 0;

	UnusedPoints = class'Helpers'.static.GetRemainingXComActionPoints(true);
	if( UnusedPoints > 0 )
	{
		GrantedPoints = FCeil(UnusedPoints*0.5f);
		for( Point = 0; Point < GrantedPoints; ++Point )
		{
			ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
		}
	}
}

function EffectAddedCallback(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		ModifyTurnStartActionPoints(UnitState, UnitState.ActionPoints, none);
	}
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;
	local XComGameState_Unit UnitState;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'ExhaustedActionPoints', ExhaustedActionCheck, ELD_OnVisualizationBlockCompleted, , UnitState);
	EventMgr.RegisterForEvent(EffectObj, 'NoActionPointsAvailable', ExhaustedActionCheck, ELD_OnVisualizationBlockCompleted, , UnitState);
	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', ExhaustedActionCheck, ELD_OnVisualizationBlockCompleted, , UnitState);
}

static function EventListenerReturn ExhaustedActionCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	`PRES.UIHideSpecialTurnOverlay();
	return ELR_NoInterrupt;
}

DefaultProperties
{
	EffectAddedFn=EffectAddedCallback
}