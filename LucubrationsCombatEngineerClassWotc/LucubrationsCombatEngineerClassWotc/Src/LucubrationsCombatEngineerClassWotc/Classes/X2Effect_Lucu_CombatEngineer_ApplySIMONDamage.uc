class X2Effect_Lucu_CombatEngineer_ApplySIMONDamage extends X2Effect_ApplyWeaponDamage;

simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_EnvironmentDamage DamageEvent;
	local XComGameState_Ability AbilityStateObject;
	local XComGameState_Unit SourceStateObject;
	local XComGameState_Item SourceItemStateObject;
	local X2WeaponTemplate WeaponTemplate;
	local float AbilityRadius;
	local vector DamageDirection;
	local int DamageAmount;
	local int PhysicalImpulseAmount;
	local name DamageTypeTemplateName;
	local XGUnit SourceUnit;
	local int OutCoverIndex;
	local UnitPeekSide OutPeekSide;
	local int OutRequiresLean;
	local int bOutCanSeeFromDefault;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Item SourceAmmo;
	local Vector HitLocation;	
	local int HitLocationCount, HitLocationIndex;
	local array<vector> HitLocationsArray;
	local X2AbilityMultiTargetStyle TargetStyle;
	local GameRulesCache_VisibilityInfo OutVisibilityInfo;

	// If this damage effect has an associated position, it does world damage
	if (ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0 || ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations.Length > 0)
	{
		History = `XCOMHISTORY;
		SourceStateObject = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		SourceItemStateObject = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));	
		if (SourceItemStateObject != None)
			WeaponTemplate = X2WeaponTemplate(SourceItemStateObject.GetMyTemplate());
		AbilityStateObject = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

		if ((SourceStateObject != none && AbilityStateObject != none) && (SourceItemStateObject != none || EnvironmentalDamageAmount > 0))
		{	
			AbilityRadius = AbilityStateObject.GetAbilityRadius();
			AbilityTemplate = AbilityStateObject.GetMyTemplate();
			if (AbilityTemplate != None)
			{
				TargetStyle = AbilityTemplate.AbilityMultiTargetStyle;
            }

			//Here, we want to use the target location as the input for the direction info since a miss location might possibly want a different step out
			SourceUnit = XGUnit(History.GetVisualizer(SourceStateObject.ObjectID));
			SourceUnit.GetDirectionInfoForPosition(ApplyEffectParameters.AbilityInputContext.TargetLocations[0], OutVisibilityInfo, OutCoverIndex, OutPeekSide, bOutCanSeeFromDefault, OutRequiresLean);
			
			DamageAmount = EnvironmentalDamageAmount;
			if ((SourceItemStateObject != none) && !bIgnoreBaseDamage)
			{
				SourceAmmo = AbilityStateObject.GetSourceAmmo();
				if (SourceAmmo != none)
				{
					DamageAmount += SourceAmmo.GetItemEnvironmentDamage();
				}
			}

			PhysicalImpulseAmount = WeaponTemplate.iPhysicsImpulse;
			DamageTypeTemplateName = WeaponTemplate.DamageTypeTemplateName;
			
			// Loop here over projectiles if needed. If not single hit and use the first index.
			if (ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations.Length > 0)
			{
				HitLocationsArray = ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations;
			}
			else
			{
				HitLocationsArray = ApplyEffectParameters.AbilityInputContext.TargetLocations;
			}

			HitLocationCount = 1;
			if (bApplyWorldEffectsForEachTargetLocation)
			{
				HitLocationCount = HitLocationsArray.Length;
			}

			for (HitLocationIndex = 0; HitLocationIndex < HitLocationCount; ++HitLocationIndex)
			{
				HitLocation = HitLocationsArray[HitLocationIndex];

				DamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateNewStateObject(class'XComGameState_EnvironmentDamage'));	
				DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_ApplyWeaponDamage:ApplyEffectToWorld";
				DamageEvent.DamageAmount = DamageAmount;
				DamageEvent.DamageTypeTemplateName = DamageTypeTemplateName;
				DamageEvent.HitLocation = HitLocation;
				DamageEvent.Momentum = (AbilityRadius == 0.0f) ? DamageDirection : vect(0,0,0);
				DamageEvent.PhysImpulse = PhysicalImpulseAmount;

				TargetStyle.GetValidTilesForLocation(AbilityStateObject, DamageEvent.HitLocation, DamageEvent.DamageTiles);

				DamageEvent.DamageCause = SourceStateObject.GetReference();
				DamageEvent.DamageSource = DamageEvent.DamageCause;
			}
		}
	}
}
