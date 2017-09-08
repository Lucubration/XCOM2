class X2AbilityToHitCalc_Beags_Escalation_Rocket extends X2AbilityToHitCalc_StandardAim;

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
	local EAbilityHitResult HitResult;
	local int MultiIndex, CalculatedHitChance;
	local ArmorMitigationResults ArmorMitigated;

	if (bMultiTargetOnly)
	{
		ResultContext.HitResult = eHit_Success;
	}
	else
	{
		InternalRollForAbilityHit(kAbility, kTarget, ResultContext, HitResult, ArmorMitigated, CalculatedHitChance);
		ResultContext.HitResult = HitResult;
		ResultContext.ArmorMitigation = ArmorMitigated;
		ResultContext.CalculatedHitChance = CalculatedHitChance;
	}

	for (MultiIndex = 0; MultiIndex < kTarget.AdditionalTargets.Length; ++MultiIndex)
	{
		if (bOnlyMultiHitWithSuccess && class'XComGameStateContext_Ability'.static.IsHitResultMiss(HitResult))
		{
			ResultContext.MultiTargetHitResults.AddItem(eHit_Miss);
			ResultContext.MultiTargetArmorMitigation.AddItem(ArmorMitigated);
			ResultContext.MultiTargetStatContestResult.AddItem(0);
		}
		else
		{
			kTarget.PrimaryTarget = kTarget.AdditionalTargets[MultiIndex];
			InternalRollForAbilityHit(kAbility, kTarget, ResultContext, HitResult, ArmorMitigated, CalculatedHitChance);
			ResultContext.MultiTargetHitResults.AddItem(HitResult);
			ResultContext.MultiTargetArmorMitigation.AddItem(ArmorMitigated);
			ResultContext.MultiTargetStatContestResult.AddItem(0);
		}
	}
}

//  Inside of GetHitChance, m_ShotBreakdown should be initially reset, then all modifiers to the shot should be added via this function.
protected function AddModifier(const int ModValue, const string ModReason, optional EAbilityHitResult ModType=eHit_Success)
{
	local ShotModifierInfo Mod;

	switch(ModType)
	{
	case eHit_Miss:
		//  Miss should never be modified, only Success
		`assert(false);
		return;
	}

	if (ModValue != 0)
	{
		Mod.ModType = ModType;
		Mod.Value = ModValue;
		Mod.Reason = ModReason;
		m_ShotBreakdown.Modifiers.AddItem(Mod);
		m_ShotBreakdown.ResultTable[ModType] += ModValue;
		m_ShotBreakdown.FinalHitChance = m_ShotBreakdown.ResultTable[eHit_Success];
	}
	`log("Modifying" @ ModType @ (ModValue >= 0 ? "+" : "") $ ModValue @ "(" $ ModReason $ "), New hit chance:" @ m_ShotBreakdown.FinalHitChance, m_bDebugModifiers, 'XCom_HitRolls');
}

protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional bool bDebugLog=false)
{
	local XComGameState_Unit UnitState, TargetState;
	local XComGameState_Item SourceWeapon;
	local array<X2WeaponUpgradeTemplate> WeaponUpgrades;
	local int i, iWeaponMod;
	local ShotBreakdown EmptyShotBreakdown;
	local array<ShotModifierInfo> EffectModifiers;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local XComGameStateHistory History;
	local bool bIgnoreGraze;
	local string IgnoreGrazeReason;
	local X2AbilityTemplate AbilityTemplate;
	local array<XComGameState_Effect> StatMods;
	local array<float> StatModValues;
	local X2Effect_Persistent PersistentEffect;
	local array<X2Effect_Persistent> UniqueToHitEffects;
	local float FinalAdjust;
	local X2RocketLauncherTemplate_Beags_Escalation WeaponTemplate;
	
	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID( kAbility.OwnerStateObject.ObjectID ));
	TargetState = XComGameState_Unit(History.GetGameStateForObjectID( kTarget.PrimaryTarget.ObjectID ));
	if (kAbility != none)
	{
		AbilityTemplate = kAbility.GetMyTemplate();
		SourceWeapon = kAbility.GetSourceWeapon();
	}
	
	// Reset shot breakdown
	m_ShotBreakdown = EmptyShotBreakdown;
	// Add all of the built-in modifiers
	if (bGuaranteedHit && TargetState != none)
	{
		// Call our override to bypass our check to ignore success mods for guaranteed hits
		AddModifier(100, AbilityTemplate.LocFriendlyName, eHit_Success);
	}
	AddModifier(BuiltInHitMod, AbilityTemplate.LocFriendlyName, eHit_Success);
	AddModifier(BuiltInCritMod, AbilityTemplate.LocFriendlyName, eHit_Crit);

	if (bIndirectFire && TargetState != none)
	{
		// Call our override to bypass our check to ignore success mods for guaranteed hits
		AddModifier(100, AbilityTemplate.LocFriendlyName, eHit_Success);
	}
	
	//  Add basic offense and value
	AddModifier(UnitState.GetBaseStat(eStat_Offense), class'XLocalizedData'.default.OffenseStat);			
	UnitState.GetStatModifiers(eStat_Offense, StatMods, StatModValues);
	for (i = 0; i < StatMods.Length; ++i)
	{
		AddModifier(int(StatModValues[i]), StatMods[i].GetX2Effect().FriendlyName);
	}

	//  Check for modifier from weapon 				
	if (SourceWeapon != none)
	{
		iWeaponMod = SourceWeapon.GetItemAimModifier();
		AddModifier(iWeaponMod, class'XLocalizedData'.default.WeaponAimBonus);

		WeaponUpgrades = SourceWeapon.GetMyWeaponUpgradeTemplates();
		for (i = 0; i < WeaponUpgrades.Length; ++i)
		{
			if (WeaponUpgrades[i].AddHitChanceModifierFn != None)
			{
				AddModifier(WeaponUpgrades[i].AimBonus, WeaponUpgrades[i].GetItemFriendlyName());
			}
		}
	}
	//  Now check for critical chances.
	if (bAllowCrit)
	{
		AddModifier(UnitState.GetBaseStat(eStat_CritChance), class'XLocalizedData'.default.CharCritChance, eHit_Crit);
		UnitState.GetStatModifiers(eStat_CritChance, StatMods, StatModValues);
		for (i = 0; i < StatMods.Length; ++i)
		{
			AddModifier(int(StatModValues[i]), StatMods[i].GetX2Effect().FriendlyName, eHit_Crit);
		}

		if (SourceWeapon !=  none)
		{
			AddModifier(SourceWeapon.GetItemCritChance(), class'XLocalizedData'.default.WeaponCritBonus, eHit_Crit);
		}
	}
	foreach UnitState.AffectedByEffects(EffectRef)
	{
		EffectModifiers.Length = 0;
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		PersistentEffect = EffectState.GetX2Effect();
		if (UniqueToHitEffects.Find(PersistentEffect) != INDEX_NONE)
			continue;

		PersistentEffect.GetToHitModifiers(EffectState, UnitState, none, kAbility, self.Class, bMeleeAttack, false, bIndirectFire, EffectModifiers);
		if (EffectModifiers.Length > 0)
		{
			if (PersistentEffect.UniqueToHitModifiers())
				UniqueToHitEffects.AddItem(PersistentEffect);

			for (i = 0; i < EffectModifiers.Length; ++i)
			{
				if (!bAllowCrit && EffectModifiers[i].ModType == eHit_Crit)
				{
					if (!PersistentEffect.AllowCritOverride())
						continue;
				}
				AddModifier(EffectModifiers[i].Value, EffectModifiers[i].Reason, EffectModifiers[i].ModType);
			}
		}
		if (PersistentEffect.ShotsCannotGraze())
		{
			bIgnoreGraze = true;
			IgnoreGrazeReason = PersistentEffect.FriendlyName;
		}
	}
	//  Remove graze if shooter ignores graze chance.
	if (bIgnoreGraze)
	{
		AddModifier(-m_ShotBreakdown.ResultTable[eHit_Graze], IgnoreGrazeReason, eHit_Graze);
	}
	
	if (FinalMultiplier != 1.0f)
	{
		FinalAdjust = m_ShotBreakdown.ResultTable[eHit_Success] * FinalMultiplier;
		AddModifier(-int(FinalAdjust), AbilityTemplate.LocFriendlyName);
	}

	// Rocket launcher distance modifier
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	WeaponTemplate = X2RocketLauncherTemplate_Beags_Escalation(kAbility.GetSourceWeapon().GetMyTemplate());
	AddModifier(-1*WeaponTemplate.GetAimModifiers(UnitState, kAbility), class'XLocalizedData'.default.WeaponRange);

	FinalizeHitChance();
	m_bDebugModifiers = false;

	// Make sure the shot breakdown is displayed
	m_ShotBreakdown.HideShotBreakdown = false;

	// Set the hit chance as a value on the unit for later
	UnitState.SetUnitFloatValue(class'X2TargetingMethod_Beags_Escalation_Rocket'.default.FiringAimName, m_ShotBreakdown.FinalHitChance, eCleanup_BeginTurn);
	
	return m_ShotBreakdown.FinalHitChance;
}

DefaultProperties
{
	bMultiTargetOnly=true
	bIndirectFire=true
	bAllowCrit=false
}