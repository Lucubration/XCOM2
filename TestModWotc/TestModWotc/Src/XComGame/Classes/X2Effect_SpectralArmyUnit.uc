class X2Effect_SpectralArmyUnit extends X2Effect_Persistent config(GameCore);

var private config name ADD_EFFECT_ANIM_NAME;
var private config name REMOVE_EFFECT_ANIM_NAME;

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit SpectralUnit;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	SpectralUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( SpectralUnit != None )
	{
		SpectralUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SpectralUnit.ObjectID));

		// Remove the unit from play
		`XEVENTMGR.TriggerEvent('UnitRemovedFromPlay', SpectralUnit, SpectralUnit, NewGameState);
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameStateVisualizationMgr VisualizationMgr;
	local XComGameStateHistory History;
	local X2Action_PlayAnimation AnimationAction, CosmeticAnimationAction;
	local X2Action_Delay DelayAction;
	local X2Action_Death DeathAction;
	local X2Action DelayParentAction;
	local XComGameState_Unit Unit, CosmeticUnit;
	local VisualizationActionMetadata CosmeticUnitMetaData;
	local XComGameState_Item ItemState;
	local X2GremlinTemplate GremlinTemplate;
	local bool bHasGremlin;

	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, RemovedEffect);

	if( EffectApplyResult != 'AA_Success' || ActionMetadata.VisualizeActor == none )
	{
		return;
	}

	
	VisualizationMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;

	DeathAction = X2Action_Death(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_Death', ActionMetadata.VisualizeActor));
	if( DeathAction == None )
	{
		DeathAction = X2Action_Death(VisualizationMgr.GetNodeOfType(VisualizationMgr.VisualizationTree, class'X2Action_Death', ActionMetadata.VisualizeActor));
	}

	Unit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	// Look for a gremlin that got copied
	ItemState = Unit.GetSecondaryWeapon();

	GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());
	if( GremlinTemplate != none )
	{
		CosmeticUnit = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.CosmeticUnitRef.ObjectID));

		History.GetCurrentAndPreviousGameStatesForObjectID(CosmeticUnit.ObjectID, CosmeticUnitMetaData.StateObject_OldState, CosmeticUnitMetaData.StateObject_NewState, , VisualizeGameState.HistoryIndex);
		CosmeticUnitMetaData.VisualizeActor = CosmeticUnit.GetVisualizer();

		bHasGremlin = true;
	}

	if( DeathAction != None )
	{
		// This unit is dying so play the additive before the Death
		AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), true, , DeathAction.ParentActions));
		DelayParentAction = DeathAction;

		if( bHasGremlin )
		{
			CosmeticAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(CosmeticUnitMetaData, VisualizeGameState.GetContext(), true, , DeathAction.ParentActions));
		}
	}
	else
	{
		AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
		DelayParentAction = AnimationAction;

		if( bHasGremlin )
		{
			CosmeticAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(CosmeticUnitMetaData, VisualizeGameState.GetContext()));
		}
	}

	AnimationAction.Params.AnimName = default.REMOVE_EFFECT_ANIM_NAME;
	AnimationAction.Params.BlendTime = 0.0f;
	AnimationAction.Params.Additive = true;

	if( bHasGremlin )
	{
		CosmeticAnimationAction.Params.AnimName = default.REMOVE_EFFECT_ANIM_NAME;
		CosmeticAnimationAction.Params.BlendTime = 0.0f;
		CosmeticAnimationAction.Params.Additive = true;
	}

	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, DelayParentAction));
	DelayAction.Duration = 1.0f;
}

simulated function AddX2ActionsForVisualization_Sync( XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local XComGameStateHistory History;
	local X2Action_PlayAnimation AnimationAction;
	local X2Action LastActionAdded;
	local XComGameState_Unit Unit, CosmeticUnit;
	local VisualizationActionMetadata CosmeticUnitMetaData;
	local XComGameState_Item ItemState;
	local X2GremlinTemplate GremlinTemplate;

	super.AddX2ActionsForVisualization_Sync(VisualizeGameState, ActionMetadata);

	if( default.ADD_EFFECT_ANIM_NAME != '' )
	{
		LastActionAdded = ActionMetadata.LastActionAdded;

		AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, LastActionAdded));
		AnimationAction.Params.AnimName = default.ADD_EFFECT_ANIM_NAME;
		AnimationAction.Params.BlendTime = 0.0f;
		AnimationAction.Params.Additive = true;

		Unit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

		// Look for a gremlin that got copied
		ItemState = Unit.GetSecondaryWeapon();

		GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());
		if( GremlinTemplate != none )
		{
			History = `XCOMHISTORY;

			CosmeticUnit = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.CosmeticUnitRef.ObjectID));

			History.GetCurrentAndPreviousGameStatesForObjectID(CosmeticUnit.ObjectID, CosmeticUnitMetaData.StateObject_OldState, CosmeticUnitMetaData.StateObject_NewState, , VisualizeGameState.HistoryIndex);
			CosmeticUnitMetaData.VisualizeActor = CosmeticUnit.GetVisualizer();

			AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(CosmeticUnitMetaData, VisualizeGameState.GetContext(), false, LastActionAdded));
			AnimationAction.Params.AnimName = default.ADD_EFFECT_ANIM_NAME;
			AnimationAction.Params.BlendTime = 0.0f;
			AnimationAction.Params.Additive = true;
		}
	}
}

function bool DoesEffectAllowUnitToBleedOut(XComGameState_Unit UnitState) {return false; }
function bool DoesEffectAllowUnitToBeLooted(XComGameState NewGameState, XComGameState_Unit UnitState) {return false; }

DefaultProperties
{
	DuplicateResponse=eDupe_Ignore
	EffectName="SpectralArmyUnitEffect"
}