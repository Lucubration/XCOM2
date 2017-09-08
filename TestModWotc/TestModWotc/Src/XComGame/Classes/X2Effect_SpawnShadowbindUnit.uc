class X2Effect_SpawnShadowbindUnit extends X2Effect_SpawnUnit
	config(GameData_SoldierSkills);

var config array<Name> AbilitiesShadowCantHave;

var name ShadowbindUnconciousCheckName;

function vector GetSpawnLocation(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	if (ApplyEffectParameters.AbilityInputContext.TargetLocations.Length == 0)
	{
		`Redscreen("Attempting to create X2Effect_SpawnShadowbindUnit without a target location! @dslonneger");
		return vect(0, 0, 0);
	}

	return ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
}

// Get the team that this unit should be added to
function ETeam GetTeam(const out EffectAppliedData ApplyEffectParameters)
{
	return GetSourceUnitsTeam(ApplyEffectParameters);
}

function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit ShadowbindUnitGameState, ShadowbindTargetUnitGameState;
	local EffectAppliedData NewEffectParams;
	local X2Effect ShadowboundLinkEffect;
	local X2EventManager EventMgr;
	local Object EffectObj;

	ShadowbindTargetUnitGameState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.AbilityInputContext.PrimaryTarget.ObjectID));

	ShadowbindUnitGameState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', NewUnitRef.ObjectID));
	if(`XENGINE.IsMultiplayerGame())
	{
		// shadow units cannot move on the same turn they are spawned.
		ShadowbindUnitGameState.ActionPoints.Length = 0;
	}

	// Link the Source and Shadow units
	NewEffectParams = ApplyEffectParameters;
	NewEffectParams.EffectRef.ApplyOnTickIndex = INDEX_NONE;
	NewEffectParams.EffectRef.LookupType = TELT_AbilityTargetEffects;
	NewEffectParams.EffectRef.SourceTemplateName = class'X2Ability_Spectre'.default.ShadowboundLinkName;
	NewEffectParams.EffectRef.TemplateEffectLookupArrayIndex = 0;
	NewEffectParams.TargetStateObjectRef = ShadowbindUnitGameState.GetReference();

	ShadowboundLinkEffect = class'X2Effect'.static.GetX2Effect(NewEffectParams.EffectRef);
	`assert(ShadowboundLinkEffect != none);
	ShadowboundLinkEffect.ApplyEffect(NewEffectParams, ShadowbindUnitGameState, NewGameState);

	// Shadow units need the anim sets of the units they copied. They are all humanoid units so this should be fine
	ShadowbindUnitGameState.ShadowUnit_CopiedUnit = ShadowbindTargetUnitGameState.GetReference();

	EventMgr = `XEVENTMGR;
	EffectObj = NewEffectState;
	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', NewEffectState.ShadowbindUnitDeathListener, ELD_OnStateSubmitted, , ShadowbindUnitGameState);
}

function AddSpawnVisualizationsToTracks(XComGameStateContext Context, XComGameState_Unit SpawnedUnit, out VisualizationActionMetadata SpawnedUnitTrack,
										XComGameState_Unit EffectTargetUnit, optional out VisualizationActionMetadata EffectTargetUnitTrack)
{
	local XComGameStateVisualizationMgr VisMgr;
	local XComGameStateHistory History;
	local X2Action_ShadowbindTarget TargetShadowbind;
	local X2Action_CreateDoppelganger CopyUnitAction;

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;

	TargetShadowbind = X2Action_ShadowbindTarget(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ShadowbindTarget', , XComGameStateContext_Ability(Context).InputContext.PrimaryTarget.ObjectID));

	// Copy the target unit's appearance to the Shadow
	CopyUnitAction = X2Action_CreateDoppelganger(class'X2Action_CreateDoppelganger'.static.AddToVisualizationTree(SpawnedUnitTrack, Context, true, , TargetShadowbind.ParentActions));//TargetShadowbind/*, TargetShadowbind.ParentActions*/));
	CopyUnitAction.OriginalUnit = XGUnit(History.GetVisualizer(EffectTargetUnit.ObjectID));
	CopyUnitAction.ShouldCopyAppearance = true;
	CopyUnitAction.bReplacingOriginalUnit = false;
}

simulated function ModifyAbilitiesPreActivation(StateObjectReference NewUnitRef, out array<AbilitySetupData> AbilityData, XComGameState NewGameState)
{
	local int FindIndex, CantHaveIndex;
	local name CantHaveName;
	local X2CharacterTemplateManager CharTemplateMan;
	local X2CharacterTemplate CharacterTemplate;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local name AbilityName;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Unit ShadowbindUnitGameState;
	local AbilitySetupData Data, EmptyData;
	local int i, j, OverrideIdx, ShadowAbilitiesStartIndex;

	ShadowAbilitiesStartIndex = AbilityData.Length;

	ShadowbindUnitGameState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', NewUnitRef.ObjectID));
	CharTemplateMan = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharacterTemplate = CharTemplateMan.FindCharacterTemplate(ShadowbindUnitGameState.CopiedUnitTemplateName);

	if (CharacterTemplate != None)
	{
		AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

		foreach CharacterTemplate.Abilities(AbilityName)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
			if (AbilityTemplate != none &&
				(!AbilityTemplate.bUniqueSource || AbilityData.Find('TemplateName', AbilityTemplate.DataName) == INDEX_NONE) &&
				AbilityTemplate.ConditionsEverValidForUnit(ShadowbindUnitGameState, false))
			{
				Data = EmptyData;
				Data.TemplateName = AbilityName;
				Data.Template = AbilityTemplate;
				AbilityData.AddItem(Data);
			}
			else if (AbilityTemplate == none)
			{
				`RedScreen("Character template" @ CharacterTemplate.DataName @ "specifies unknown ability:" @ AbilityName);
			}
		}
		//  Check for ability overrides - do it BEFORE adding additional abilities so we don't end up with extra ones we shouldn't have
		for (i = AbilityData.Length - 1; i >= ShadowAbilitiesStartIndex; --i)
		{
			if (AbilityData[i].Template.OverrideAbilities.Length > 0)
			{
				for (j = 0; j < AbilityData[i].Template.OverrideAbilities.Length; ++j)
				{
					OverrideIdx = AbilityData.Find('TemplateName', AbilityData[i].Template.OverrideAbilities[j]);
					if (OverrideIdx != INDEX_NONE)
					{
						AbilityData[OverrideIdx].Template = AbilityData[i].Template;
						AbilityData[OverrideIdx].TemplateName = AbilityData[i].TemplateName;
						//  only override the weapon if requested. otherwise, keep the original source weapon for the override ability
						if (AbilityData[i].Template.bOverrideWeapon)
						{
							AbilityData[OverrideIdx].SourceWeaponRef = AbilityData[i].SourceWeaponRef;
						}

						AbilityData.Remove(i, 1);
						break;
					}
				}
			}
		}
		//  Add any additional abilities
		for (i = 0; i < AbilityData.Length; ++i)
		{
			foreach AbilityData[i].Template.AdditionalAbilities(AbilityName)
			{
				AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
				if (AbilityTemplate != none &&
					(!AbilityTemplate.bUniqueSource || AbilityData.Find('TemplateName', AbilityTemplate.DataName) == INDEX_NONE) &&
					AbilityTemplate.ConditionsEverValidForUnit(ShadowbindUnitGameState, false))
				{
					Data = EmptyData;
					Data.TemplateName = AbilityName;
					Data.Template = AbilityTemplate;
					Data.SourceWeaponRef = AbilityData[i].SourceWeaponRef;
					AbilityData.AddItem(Data);
				}
			}
		}
		//  Check for ability overrides AGAIN - in case the additional abilities want to override something
		for (i = AbilityData.Length - 1; i >= ShadowAbilitiesStartIndex; --i)
		{
			if (AbilityData[i].Template.OverrideAbilities.Length > 0)
			{
				for (j = 0; j < AbilityData[i].Template.OverrideAbilities.Length; ++j)
				{
					OverrideIdx = AbilityData.Find('TemplateName', AbilityData[i].Template.OverrideAbilities[j]);
					if (OverrideIdx != INDEX_NONE)
					{
						AbilityData[OverrideIdx].Template = AbilityData[i].Template;
						AbilityData[OverrideIdx].TemplateName = AbilityData[i].TemplateName;
						//  only override the weapon if requested. otherwise, keep the original source weapon for the override ability
						if (AbilityData[i].Template.bOverrideWeapon)
						{
							AbilityData[OverrideIdx].SourceWeaponRef = AbilityData[i].SourceWeaponRef;
						}

						AbilityData.Remove(i, 1);
						break;
					}
				}
			}
		}
	}

	// Check to see which abilities the Shadow can't have
	for (CantHaveIndex = 0; CantHaveIndex < default.AbilitiesShadowCantHave.Length; ++CantHaveIndex)
	{
		CantHaveName = default.AbilitiesShadowCantHave[CantHaveIndex];
		FindIndex = AbilityData.Find('TemplateName', CantHaveName);
		while (FindIndex != INDEX_NONE)
		{
			AbilityData.Remove(FindIndex, 1);
			FindIndex = AbilityData.Find('TemplateName', CantHaveName);
		}
	}
}

defaultproperties
{
	UnitToSpawnName="ShadowbindUnit"
	bCopyTargetAppearance=true
	bKnockbackAffectsSpawnLocation=false
	EffectName="SpawnShadowbindUnit"
	bCopyReanimatedFromUnit=true
	bCopyReanimatedStatsFromUnit=false
	bSetProcessedScamperAs=false
	ShadowbindUnconciousCheckName="ShadowbindUnconciousCheck"
}