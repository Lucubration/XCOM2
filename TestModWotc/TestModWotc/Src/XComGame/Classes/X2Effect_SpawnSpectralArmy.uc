class X2Effect_SpawnSpectralArmy extends X2Effect_SpawnUnit;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;
	local int i;
	local int FocusLevel;

	TargetUnitState = XComGameState_Unit(kNewTargetState);
	`assert(TargetUnitState != none);

	// Loop over the num chosen level which starts at 1
	FocusLevel = TargetUnitState.GetTemplarFocusLevel();
	for (i = 1; i <= FocusLevel; ++i)
	{
		TriggerSpawnEvent(ApplyEffectParameters, TargetUnitState, NewGameState, NewEffectState);
	}
}

function vector GetSpawnLocation(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComWorldData World;
	local XComAISpawnManager SpawnManager;
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnitState;
	local vector TargetLocation, SpawnLocation;

	World = `XWORLD;
	SpawnManager = `SPAWNMGR;
	History = `XCOMHISTORY;

	TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	TargetLocation = World.GetPositionFromTileCoordinates(TargetUnitState.TileLocation);

	SpawnLocation = SpawnManager.SelectReinforcementsLocation(none, TargetLocation, 2, false, false, false, true);

	return SpawnLocation;
}

function ETeam GetTeam(const out EffectAppliedData ApplyEffectParameters)
{
	return GetSourceUnitsTeam(ApplyEffectParameters);
}

function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SpectralUnit;
	local EffectAppliedData NewEffectParams;
	local X2Effect SpectralArmyLinkEffect;

	SpectralUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewUnitRef.ObjectID));

	if (SpectralUnit == none)
	{
		`RedScreen("X2Effect_SpectralArmyUnit: Spectral Unit is missing: " $SpectralUnit.ObjectID);
		return;
	}

	// Link the source and zombie
	NewEffectParams = ApplyEffectParameters;
	NewEffectParams.EffectRef.ApplyOnTickIndex = INDEX_NONE;
	NewEffectParams.EffectRef.LookupType = TELT_AbilityTargetEffects;
	NewEffectParams.EffectRef.SourceTemplateName = class'X2Ability_ChosenWarlock'.default.SpectralArmyLinkName;
	NewEffectParams.EffectRef.TemplateEffectLookupArrayIndex = 0;
	NewEffectParams.TargetStateObjectRef = SpectralUnit.GetReference();

	SpectralArmyLinkEffect = class'X2Effect'.static.GetX2Effect(NewEffectParams.EffectRef);

	if (SpectralUnit == none)
	{
		`RedScreen("X2Effect_SpectralArmyUnit: Spectral Army Link Effect is missing.");
		return;
	}

	SpectralArmyLinkEffect.ApplyEffect(NewEffectParams, SpectralUnit, NewGameState);
}

//function AddSpawnVisualizationsToTracks(XComGameStateContext Context, XComGameState_Unit SpawnedUnit, out VisualizationActionMetadata SpawnedUnitTrack,
//	XComGameState_Unit EffectTargetUnit, optional out VisualizationActionMetadata EffectTargetUnitTrack)
//{
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local XComGameStateHistory History;
	local XComGameStateVisualizationMgr VisualizationMgr;
	local X2Action_Fire_SpectralArmy FireAction;
	local array<XComGameState_Unit> SpectralUnits;
	local VisualizationActionMetadata EmptyTrack, NewUnitActionMetadata;
	local int j;
	local XComGameState_Unit SpawnedUnit;
	local X2Action_PlayAnimation AnimAction;
	local X2Action_WaitForAbilityEffect WaitAction;
	local X2Action_ShowSpawnedUnit ShowUnitAction;

	History = `XCOMHISTORY;
	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	// Find the X2Action_Fire_SpectralArmy
	FireAction = X2Action_Fire_SpectralArmy(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_Fire_SpectralArmy'));

	FindNewlySpawnedUnit(VisualizeGameState, SpectralUnits);

	for (j = 0; j < SpectralUnits.Length; ++j)
	{
		NewUnitActionMetadata = EmptyTrack;
		NewUnitActionMetadata.StateObject_OldState = SpectralUnits[j];
		NewUnitActionMetadata.StateObject_NewState = NewUnitActionMetadata.StateObject_OldState;
		SpawnedUnit = XComGameState_Unit(NewUnitActionMetadata.StateObject_NewState);
		NewUnitActionMetadata.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

		WaitAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(NewUnitActionMetadata, VisualizeGameState.GetContext(), false, FireAction));
		
		ShowUnitAction = X2Action_ShowSpawnedUnit(class'X2Action_ShowSpawnedUnit'.static.AddToVisualizationTree(NewUnitActionMetadata, VisualizeGameState.GetContext(), false, WaitAction));
		ShowUnitAction.bPlayIdle = false;

		AnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(NewUnitActionMetadata, VisualizeGameState.GetContext(), false, ShowUnitAction));
		AnimAction.Params.AnimName = 'HL_SpectralArmy_Target';
		AnimAction.Params.BlendTime = 0.0f;
		AnimAction.bFinishAnimationWait = true;
	}
}

defaultproperties
{
	UnitToSpawnName="SpectralStunLancerM1"
	bKnockbackAffectsSpawnLocation=false
	bAddToSourceGroup=true
	EffectName="SpawnSpectralArmy"
}