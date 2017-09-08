class X2AmbientNarrativeCriteria_Beags_Escalation_TemplateModificator extends X2AmbientNarrativeCriteria;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2DataTemplate DataTemplate;
	local X2AbilityTemplate AbilityTemplate;

	// This turns out to be a good hook for doing global template modification because subclasses of X2AmbientNarrativeCriteria
	// are the last ones loaded when the game is setting up. We'll just return an empty list of templates for template creation
	// (because we're not actually using this to create any templates) and put our template modifications in-between
	Templates.Length = 0;

	foreach class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().IterateTemplates(DataTemplate, none)
	{
		AbilityTemplate = X2AbilityTemplate(DataTemplate);
		if (AbilityTemplate != none)
		{
			// For every single ability template with a multi-target style, we're going to try to modify the vanilla targeting style
			// X2AbilityMultiTarget_SoldierBonusRadius to our own X2AbilityMultiTarget_Beags_Escalation_ItemRadius, if appropriate, so
			// that we can double-up on increasing the radius of explosive effects with our own perks
			if (AbilityTemplate.AbilityMultiTargetStyle != none)
				TryModifyBonusRadiusAbility(AbilityTemplate);

			// For every single ability template in the DoubleTapAbilities array, modify the ability template's action point cost to
			// allow the Double Tap action point type
			if (class'X2Ability_Beags_Escalation_CommonAbilitySet'.static.IsDoubleTapAbility(AbilityTemplate.DataName))
				TryModifyDoubleTapAbility(AbilityTemplate);

			// Update all 'X2Effect_Shredder' to 'bAllowWeaponUpgrade' in the X2AbilityTemplate.AbilityTargetEffects and the
			// X2AbilityTemplate.AbilityMultiTargetEffects collections
			TryModifyWeaponUpgradeAbility(AbilityTemplate);

			// Update all abilities with the Holo Targeting effect to also include the Suppressing Fire effect
			TryModifySuppressingFireAbility(AbilityTemplate);

			// Update all abilities that apply the Holo Targeting effect or apply a covering fire effect. This should capture all
			// abilities that are restricted by HMG movement
			TryModifyHMGFireAbility(AbilityTemplate);
		}
	}

	// Apply Holo Targeting to Saturation Fire multi-target effects
	TryModifySaturationFire();

	// Update all weapon upgrade templates for the HMG
	UpdateHMGWeaponUpgradeTemplates();

	return Templates;
}

static function TryModifyBonusRadiusAbility(X2AbilityTemplate Template)
{
	local X2AbilityMultiTarget_SoldierBonusRadius OldRadiusMultiTarget;
	local X2AbilityMultiTarget_Beags_Escalation_ItemRadius NewRadiusMultiTarget;

	OldRadiusMultiTarget = X2AbilityMultiTarget_SoldierBonusRadius(Template.AbilityMultiTargetStyle);

	if (OldRadiusMultiTarget != none)
	{
		NewRadiusMultiTarget = new class'X2AbilityMultiTarget_Beags_Escalation_ItemRadius';
		NewRadiusMultiTarget.bUseWeaponRadius = OldRadiusMultiTarget.bUseWeaponRadius;
		NewRadiusMultiTarget.bIgnoreBlockingCover = OldRadiusMultiTarget.bIgnoreBlockingCover;
		NewRadiusMultiTarget.fTargetRadius = OldRadiusMultiTarget.fTargetRadius;
		NewRadiusMultiTarget.fTargetCoveragePercentage = OldRadiusMultiTarget.fTargetCoveragePercentage;
		NewRadiusMultiTarget.bAddPrimaryTargetAsMultiTarget = OldRadiusMultiTarget.bAddPrimaryTargetAsMultiTarget;
		NewRadiusMultiTarget.bAllowDeadMultiTargetUnits = OldRadiusMultiTarget.bAllowDeadMultiTargetUnits;
		NewRadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = OldRadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius;
		NewRadiusMultiTarget.SoldierAbilityNames.AddItem(OldRadiusMultiTarget.SoldierAbilityName);
		NewRadiusMultiTarget.SoldierAbilityNames.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DangerZoneAbilityName);
		NewRadiusMultiTarget.BonusRadii.AddItem(OldRadiusMultiTarget.BonusRadius);
		NewRadiusMultiTarget.BonusRadii.AddItem(`UNITSTOTILES(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DangerZoneExplosiveRadiusBonus));
		Template.AbilityMultiTargetStyle = NewRadiusMultiTarget;
		
		`LOG("Beags Escalation: Updated ability template " @ Template.DataName @ " with Danger Zone targeting style.");
	}
}

static function TryModifyDoubleTapAbility(X2AbilityTemplate Template)
{
	local X2AbilityCost_ActionPoints ActionPointCost;
	local int i;

	// Find the action point cost. It's not always the first item, so find it in the list
	for (i = 0; i < Template.AbilityCosts.Length; i++)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);
		if (ActionPointCost == none)
			continue;

		// Check for the Double Tap action point type; if not allowed, add it as an allowed type
		if (ActionPointCost.AllowedTypes.Find(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DoubleTapActionPointName) == INDEX_NONE)
		{
			ActionPointCost.AllowedTypes.AddItem(class'X2Ability_Beags_Escalation_CommonAbilitySet'.default.DoubleTapActionPointName);

			`LOG("Beags Escalation: Ability Template " @ Template.DataName @ " updated to allow Double Tap.");
		}
	}
}

static function TryModifyWeaponUpgradeAbility(X2AbilityTemplate Template)
{
	local X2Effect_Shredder ShredderEffect;
	local int i;
	
	for (i = 0; i < Template.AbilityTargetEffects.Length; i++)
	{
		ShredderEffect = X2Effect_Shredder(Template.AbilityTargetEffects[i]);
		if (ShredderEffect != none)
		{
			ShredderEffect.bAllowWeaponUpgrade = true;

			`LOG("Beags Escalation: Ability Template " @ Template.DataName @ " target damage effect updated to allow weapon upgrades.");
		}
	}
	for (i = 0; i < Template.AbilityMultiTargetEffects.Length; i++)
	{
		ShredderEffect = X2Effect_Shredder(Template.AbilityMultiTargetEffects[i]);
		if (ShredderEffect != none)
		{
			ShredderEffect.bAllowWeaponUpgrade = true;

			`LOG("Beags Escalation: Ability Template " @ Template.DataName @ " multi target damage effect updated to allow weapon upgrades.");
		}
	}
}

static function TryModifySuppressingFireAbility(X2AbilityTemplate Template)
{
	local X2Effect_HoloTarget HoloTargetEffect;
	local int i;
	
	for (i = 0; i < Template.AbilityTargetEffects.Length; i++)
	{
		HoloTargetEffect = X2Effect_HoloTarget(Template.AbilityTargetEffects[i]);
		if (HoloTargetEffect != none)
		{
			Template.AddTargetEffect(class'X2Ability_Beags_Escalation_GunnerAbilitySet'.static.SuppressingFireEffect());

			`LOG("Beags Escalation: Ability Template " @ Template.DataName @ " target effects updated to include Suppressing Fire effect.");

			break;
		}
	}
	for (i = 0; i < Template.AbilityMultiTargetEffects.Length; i++)
	{
		HoloTargetEffect = X2Effect_HoloTarget(Template.AbilityMultiTargetEffects[i]);
		if (HoloTargetEffect != none)
		{
			Template.AddMultiTargetEffect(class'X2Ability_Beags_Escalation_GunnerAbilitySet'.static.SuppressingFireEffect());

			`LOG("Beags Escalation: Ability Template " @ Template.DataName @ " multi target effects updated to include Suppressing Fire effect.");
		}
	}
}

static function TryModifyHMGFireAbility(X2AbilityTemplate Template)
{
	local X2Effect_HoloTarget HoloTargetEffect;
	local X2Effect_CoveringFire CoveringFireEffect;
	local int i;
	local bool ApplyHMGConditions;
	local X2Condition_UnitEffects EffectsCondition;
	local X2Condition_Beags_Escalation_SquadsightTargetRange RangeCondition;
	local X2Condition_Visibility VisibilityCondition;
	
	ApplyHMGConditions = false;
	for (i = 0; i < Template.AbilityShooterEffects.Length; i++)
	{
		CoveringFireEffect = X2Effect_CoveringFire(Template.AbilityShooterEffects[i]);
		if (CoveringFireEffect != none)
		{
			ApplyHMGConditions = true;
			break;
		}
	}
	if (!ApplyHMGConditions)
	{
		for (i = 0; i < Template.AbilityTargetEffects.Length; i++)
		{
			HoloTargetEffect = X2Effect_HoloTarget(Template.AbilityTargetEffects[i]);
			CoveringFireEffect = X2Effect_CoveringFire(Template.AbilityTargetEffects[i]);
			if (HoloTargetEffect != none || CoveringFireEffect != none)
			{
				ApplyHMGConditions = true;
				break;
			}
		}
	}
	if (!ApplyHMGConditions)
	{
		for (i = 0; i < Template.AbilityMultiTargetEffects.Length; i++)
		{
			HoloTargetEffect = X2Effect_HoloTarget(Template.AbilityMultiTargetEffects[i]);
			if (HoloTargetEffect != none)
			{
				ApplyHMGConditions = true;
				break;
			}
		}
	}

	if (ApplyHMGConditions)
	{
		EffectsCondition = new class'X2Condition_UnitEffects';
		EffectsCondition.AddExcludeEffect(class'X2Ability_Beags_Escalation_GunnerAbilitySet'.default.HMGMovedEffectName, 'AA_AbilityUnavailable');
		Template.AbilityShooterConditions.AddItem(EffectsCondition);

		RangeCondition = new class'X2Condition_Beags_Escalation_SquadsightTargetRange';
		Template.AbilityTargetConditions.AddItem(RangeCondition);

		// Explicitly update Suppression and Suppression Shot to allow squadsight
		if (Template.DataName == 'Suppression' || Template.DataName == 'SuppressionShot')
		{
			for (i = 0; i < Template.AbilityTargetConditions.Length; i++)
			{
				VisibilityCondition = X2Condition_Visibility(Template.AbilityTargetConditions[i]);
				if (VisibilityCondition != none && !VisibilityCondition.bAllowSquadsight)
				{
					VisibilityCondition = new class'X2Condition_Visibility';
					VisibilityCondition.bRequireGameplayVisible = true;
					VisibilityCondition.bAllowSquadsight = true;
					Template.AbilityTargetConditions[i] = VisibilityCondition;

					`LOG("Beags Escalation: Ability Template " @ Template.DataName @ " target conditions updated to allow Squadsight.");
				}
			}
		}

		`LOG("Beags Escalation: Ability Template " @ Template.DataName @ " shooter conditions updated with HMG firing conditions.");
	}
}

static function TryModifySaturationFire()
{
	local X2AbilityTemplate Template;

	Template = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('SaturationFire');
	if (Template != none)
	{
		Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());

		`LOG("Beags Escalation: Saturation Fire ability template updated to include Holo Targeting effect.");
	}
	else
	{
		`LOG("Beags Escalation: Saturation Fire ability template not updated to include Holo Targeting effect (ability template not found).");
	}
}

static function UpdateHMGWeaponUpgradeTemplates()
{
	local X2DataTemplate			DataTemplate;
	local X2WeaponUpgradeTemplate	Template;
	local WeaponAttachment			Attachment;
	
	foreach class'X2ItemTemplateManager'.static.GetItemTemplateManager().IterateTemplates(DataTemplate, none)
	{
		Template = X2WeaponUpgradeTemplate(DataTemplate);
		if (Template != none)
		{
			foreach Template.UpgradeAttachments(Attachment)
			{
				if (Attachment.ApplyToWeaponTemplate == 'Cannon_CV')
				{
					Template.AddUpgradeAttachment(Attachment.AttachSocket, Attachment.UIArmoryCameraPointTag, Attachment.AttachMeshName, Attachment.AttachProjectileName, 'Beags_Escalation_HMG_CV', Attachment.AttachToPawn, Attachment.AttachIconName, Attachment.InventoryIconName, Attachment.InventoryCategoryIcon, Attachment.ValidateAttachmentFn);
					`LOG("Beags Escalation: Weapon Upgrade Template " @ Template.DataName @ " updated for HMG_CV.");
				}
				else if (Attachment.ApplyToWeaponTemplate == 'Cannon_MG')
				{
					Template.AddUpgradeAttachment(Attachment.AttachSocket, Attachment.UIArmoryCameraPointTag, Attachment.AttachMeshName, Attachment.AttachProjectileName, 'Beags_Escalation_HMG_MG', Attachment.AttachToPawn, Attachment.AttachIconName, Attachment.InventoryIconName, Attachment.InventoryCategoryIcon, Attachment.ValidateAttachmentFn);
					`LOG("Beags Escalation: Weapon Upgrade Template " @ Template.DataName @ " updated for HMG_MG.");
				}
				else if (Attachment.ApplyToWeaponTemplate == 'Cannon_BM')
				{
					Template.AddUpgradeAttachment(Attachment.AttachSocket, Attachment.UIArmoryCameraPointTag, Attachment.AttachMeshName, Attachment.AttachProjectileName, 'Beags_Escalation_HMG_BM', Attachment.AttachToPawn, Attachment.AttachIconName, Attachment.InventoryIconName, Attachment.InventoryCategoryIcon, Attachment.ValidateAttachmentFn);
					`LOG("Beags Escalation: Weapon Upgrade Template " @ Template.DataName @ " updated for HMG_BM.");
				}
			}
		}
	}
}
