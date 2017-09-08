class X2Effect_Suppression extends X2Effect_Persistent config(GameCore);

var config int SoldierTargetAimPenalty;     //  inside GetToHitModifiers, this value is used if the Attacker is not on eTeam_XCom (because a soldier hit this unit with suppression)
var config int AlienTargetAimPenalty;       //  as above, but only for eTeam_XCom (because an alien hit this xcom unit with suppression)
var config int MultiplayerTargetAimPenalty; //  the value used in MP games

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotMod;

	if (!bIndirectFire)
	{
		ShotMod.ModType = eHit_Success;
		if (`XENGINE.IsMultiplayerGame())
			ShotMod.Value = default.MultiplayerTargetAimPenalty;
		else if (Attacker.GetTeam() != eTeam_XCom)
			ShotMod.Value = default.SoldierTargetAimPenalty;
		else
			ShotMod.Value = default.AlienTargetAimPenalty;
		ShotMod.Reason = FriendlyName;
		ShotModifiers.AddItem(ShotMod);
	}
}

//Only one Suppression effect is allowed to apply to a target.
function bool UniqueToHitModifiers() { return true; }

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
		
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	TargetUnit = XComGameState_Unit(kNewTargetState);
	TargetUnit.ReserveActionPoints.Length = 0;              //  remove overwatch when suppressed
	SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	SourceUnit.m_SuppressionHistoryIndex = History.GetNumGameStates(); // the NewGameState is pending submission, so its index will be the next index in the history
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID);
}

simulated function AddX2ActionsForVisualization_RemovedSource(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local X2Action_EnterCover Action;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState SuppressionGameState;

	History = `XCOMHISTORY;

	class'X2Action_StopSuppression'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
	Action = X2Action_EnterCover(class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));

	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	SuppressionGameState = History.GetGameStateFromHistory(UnitState.m_SuppressionHistoryIndex);
	Action.AbilityContext = XComGameStateContext_Ability(SuppressionGameState.GetContext());
}

simulated function CleansedSuppressionVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState, SuppressionEffect;
	local X2Action_EnterCover Action;
	local XComGameState_Unit UnitState;
	local XComGameState SuppressionGameState;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.bRemoved && EffectState.GetX2Effect() == self)
		{
			SuppressionEffect = EffectState;
			break;
		}
	}
	if (SuppressionEffect != none)
	{
		History = `XCOMHISTORY;

		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SuppressionEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		ActionMetadata.VisualizeActor = History.GetVisualizer(SuppressionEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID);
		History.GetCurrentAndPreviousGameStatesForObjectID(SuppressionEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, eReturnType_Reference, VisualizeGameState.HistoryIndex);
		if (ActionMetadata.StateObject_NewState == none)
			ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;

		class'X2Action_StopSuppression'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
		Action = X2Action_EnterCover(class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));

		SuppressionGameState = History.GetGameStateFromHistory(UnitState.m_SuppressionHistoryIndex);
		Action.AbilityContext = XComGameStateContext_Ability(SuppressionGameState.GetContext());
	}
}


function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit SourceUnitState;
	local XComGameStateHistory History;
	local Object EffectObj;

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	// Register for the required events
	EventMgr.RegisterForEvent(EffectObj, 'ImpairingEffect', EffectGameState.OnSourceBecameImpaired, ELD_OnStateSubmitted, , SourceUnitState);
}

DefaultProperties
{
	EffectName="Suppression"
	bUseSourcePlayerState=true
	CleansedVisualizationFn=CleansedSuppressionVisualization
}