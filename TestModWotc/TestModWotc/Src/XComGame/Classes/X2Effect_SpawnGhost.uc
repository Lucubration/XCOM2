class X2Effect_SpawnGhost extends X2Effect_SpawnUnit;

var localized string FirstName, LastName;

function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit NewUnitState, SourceUnitState;
	local float HealthValue;
	local XComGameStateHistory History;
	local float StartingFocus;

	History = `XCOMHISTORY;

	NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', NewUnitRef.ObjectID));
	NewUnitState.GhostSourceUnit = ApplyEffectParameters.SourceStateObjectRef;
	NewUnitState.kAppearance.bGhostPawn = true;

	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	StartingFocus = SourceUnitState.GetTemplarFocusLevel();
	HealthValue = min(StartingFocus * class'X2Ability_TemplarAbilitySet'.default.GhostHPPerFocus, SourceUnitState.GetCurrentStat(eStat_HP));
	NewUnitState.SetBaseMaxStat(eStat_HP, HealthValue, ECSMAR_None);
	NewUnitState.SetCurrentStat(eStat_HP, HealthValue);
	NewUnitState.SetCharacterName(default.FirstName, default.LastName, "");

	NewUnitState.SetUnitFloatValue('NewSpawnedUnit', 1, eCleanup_BeginTactical);
}

simulated function ModifyItemsPreActivation(StateObjectReference NewUnitRef, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local array<XComGameState_Item> AllItems;
	local XComGameState_Item ItemState;
	local EInventorySlot eSlot;
	local int idx;

	History = `XCOMHISTORY;

	// Remove all utility, secondary weapon, and heavy weapon items from the Ghost
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewUnitRef.ObjectID));
	AllItems = UnitState.GetAllInventoryItems(NewGameState, true);
	for (idx = 0; idx < AllItems.Length; idx++)
	{
		eSlot = AllItems[idx].InventorySlot;
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(AllItems[idx].ObjectID));

		if (eSlot == eInvSlot_SecondaryWeapon || eSlot == eInvSlot_Utility || eSlot == eInvSlot_HeavyWeapon)
		{
			ItemState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', ItemState.ObjectID));

			if (UnitState.CanRemoveItemFromInventory(ItemState, NewGameState))
			{
				UnitState.RemoveItemFromInventory(ItemState, NewGameState);
			}
		}
	}
}

simulated function ModifyAbilitiesPreActivation(StateObjectReference NewUnitRef, out array<AbilitySetupData> AbilityData, XComGameState NewGameState)
{
	local X2AbilityTemplate NewAbilityTemplate;
	local AbilitySetupData TempData;
	local int FindIndex, LoopIndex;
	local name LoopName;

	// Jwats: Ghost templar should not have some abilities
	for (LoopIndex = 0; LoopIndex < class'X2Ability_TemplarAbilitySet'.default.AbilitiesGhostCantHave.Length; ++LoopIndex)
	{
		LoopName = class'X2Ability_TemplarAbilitySet'.default.AbilitiesGhostCantHave[LoopIndex];
		FindIndex = AbilityData.Find('TemplateName', LoopName);
		while (FindIndex != INDEX_NONE)
		{
			AbilityData.Remove(FindIndex, 1);
			FindIndex = AbilityData.Find('TemplateName', LoopName);
		}
	}

	// Ghost templar needs some other abilities regular templars don't get
	for (LoopIndex = 0; LoopIndex < class'X2Ability_TemplarAbilitySet'.default.GhostOnlyAbilities.Length; ++LoopIndex)
	{
		LoopName = class'X2Ability_TemplarAbilitySet'.default.GhostOnlyAbilities[LoopIndex];
		NewAbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(LoopName);
		if (NewAbilityTemplate != None)
		{
			TempData.Template = NewAbilityTemplate;
			TempData.TemplateName = NewAbilityTemplate.DataName;
			AbilityData.AddItem(TempData);
		}

	}
}

function ETeam GetTeam(const out EffectAppliedData ApplyEffectParameters)
{
	return GetSourceUnitsTeam(ApplyEffectParameters);
}

function AddSpawnVisualizationsToTracks(XComGameStateContext Context, XComGameState_Unit SpawnedUnit, out VisualizationActionMetadata SpawnedUnitTrack,
										XComGameState_Unit EffectTargetUnit, optional out VisualizationActionMetadata EffectTargetUnitTrack)
{
	local X2Action_PlayAnimation AnimationAction;
	local X2Action_PlayAdditiveAnim AdditiveAction;
	local XGUnit DeadVisualizer;
	local XComUnitPawn DeadUnitPawn;
	local X2Action_ShowSpawnedUnit ShowSpawnedUnit;
	local Array<X2Action> ParentActions;
	local X2Action_MarkerNamed JoinAction;
	local X2Action_Delay FrameDelay;
	local X2Action LastActionAdded;
	local X2Action_PlayEffect TetherEffect;

	DeadVisualizer = XGUnit(EffectTargetUnitTrack.VisualizeActor);
	if( DeadVisualizer != None )
	{
		DeadUnitPawn = DeadVisualizer.GetPawn();
		if( DeadUnitPawn != None )
		{
			if( DeadUnitPawn.Mesh != None )
			{
				LastActionAdded = SpawnedUnitTrack.LastActionAdded;

				AdditiveAction = X2Action_PlayAdditiveAnim(class'X2Action_PlayAdditiveAnim'.static.AddToVisualizationTree(SpawnedUnitTrack, Context, false, LastActionAdded));
				AdditiveAction.AdditiveAnimParams.AnimName = 'ADD_StartGhost';
				AdditiveAction.AdditiveAnimParams.BlendTime = 0.0f;
				ParentActions.AddItem(AdditiveAction);

				AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(SpawnedUnitTrack, Context, false, LastActionAdded));
				AnimationAction.Params.AnimName = 'HL_GetUp';
				AnimationAction.Params.BlendTime = 0.0f;
				AnimationAction.Params.DesiredEndingAtoms[0].Translation = `XWORLD.GetPositionFromTileCoordinates(SpawnedUnit.TileLocation);
				AnimationAction.Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(DeadUnitPawn.Rotation);
				AnimationAction.Params.DesiredEndingAtoms[0].Scale = 1.0f;
				ParentActions.AddItem(AnimationAction);

				TetherEffect = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(EffectTargetUnitTrack, Context, false, LastActionAdded));
				TetherEffect.EffectName = "FX_Templar_Ghost.P_Ghost_Summon_Tether";
				TetherEffect.AttachToSocketName = 'FX_Chest';
				TetherEffect.TetherToSocketName = 'Root';
				TetherEffect.TetherToUnit = XGUnit(SpawnedUnitTrack.VisualizeActor);
				TetherEffect.bWaitForCompletion = true;
				ParentActions.AddItem(TetherEffect);

				// Jwats: Give the animation actions a frame delay before showing the unit 
				FrameDelay = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(SpawnedUnitTrack, Context, false, LastActionAdded));
				FrameDelay.Duration = 0.25;
				
				ShowSpawnedUnit = X2Action_ShowSpawnedUnit(class'X2Action_ShowSpawnedUnit'.static.AddToVisualizationTree(SpawnedUnitTrack, Context, false, FrameDelay));
				ShowSpawnedUnit.OverrideVisualizationLocation = DeadUnitPawn.Location;
				ShowSpawnedUnit.OverrideFacingRot = DeadUnitPawn.Rotation;
				ShowSpawnedUnit.bPlayIdle = false;
				ParentActions.AddItem(ShowSpawnedUnit);

				// Jwats: Wait for all the leafs for finish
				JoinAction = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(SpawnedUnitTrack, Context, false, , ParentActions));
				JoinAction.SetName("Join");
			}
		}
	}
}

static function SyncGhostActions(out VisualizationActionMetadata SpawnedUnitTrack, const out XComGameStateContext Context)
{
	local X2Action_PlayAdditiveAnim AdditiveAction;
	local X2Action_Delay DelayAction;

	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(SpawnedUnitTrack, Context));
	DelayAction.Duration = 0.5f;

	AdditiveAction = X2Action_PlayAdditiveAnim(class'X2Action_PlayAdditiveAnim'.static.AddToVisualizationTree(SpawnedUnitTrack, Context, false, DelayAction));
	AdditiveAction.AdditiveAnimParams.AnimName = 'ADD_StartGhost';
	AdditiveAction.AdditiveAnimParams.BlendTime = 0.0f;
}

DefaultProperties
{
	UnitToSpawnName = "TemplarSoldier"	
	SpawnedUnitValueName = "SpawnedGhostTemplar"
	bCopyReanimatedFromUnit = true
	EffectName = "TemplarGhost"
	DuplicateResponse = eDupe_Ignore
	bCopySourceAppearance = true
	bAddToSourceGroup = true
	bCopyReanimatedStatsFromUnit = true
	bKnockbackAffectsSpawnLocation = false
}