class X2Effect_DLC_3AbsorptionField extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', class'XComGameState_Effect_DLC_3AbsorptionField'.static.AbilityActivatedListener, ELD_OnStateSubmitted);
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Effect_DLC_3AbsorptionField FieldEffectState;
	local XComGameState_Item SourceWeapon;
	local int BonusDamage;

	FieldEffectState = XComGameState_Effect_DLC_3AbsorptionField(EffectState);
	if (FieldEffectState != none)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none && SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
		{
			BonusDamage = min(FieldEffectState.EnergyAbsorbed, CurrentDamage * 2);      //  caps bonus at twice the incoming amount
		
			if (NewGameState != none && BonusDamage > 0)           //  this means we are really attacking and not just previewing damage, so clear out the amount of energy used
			{
				FieldEffectState = XComGameState_Effect_DLC_3AbsorptionField(NewGameState.ModifyStateObject(FieldEffectState.Class, FieldEffectState.ObjectID));
				FieldEffectState.EnergyAbsorbed = 0;
				FieldEffectState.LastEnergyExpendedContext = NewGameState.GetContext();
			}
		}
	}
	else
	{
		`RedScreen("X2Effect_DLC_3AbsorptionField was given an EffectState" @ EffectState.ToString() @ "which is not the right class - should be XComGameState_Effect_DLC_3AbsorptionField! @gameplay @jbouscher");
	}
	return BonusDamage;
}

function Actor GetProjectileVolleyTemplate(XComGameState_Unit UnitState, XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext)
{
	if (XComGameState_Effect_DLC_3AbsorptionField(EffectState).LastEnergyExpendedContext == AbilityContext)
	{
		return Actor(`CONTENT.RequestGameArchetype(class'X2Ability_SparkAbilitySet'.default.AbsorptionFieldProjectile));
	}
	return none;
}

simulated function AddX2ActionsForVisualization_Sync( XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local X2Action_PlayAnimation PlayAnimation;
	local XComGameState_Effect_DLC_3AbsorptionField EffectState;

	super.AddX2ActionsForVisualization_Sync(VisualizeGameState, ActionMetadata);

	if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		EffectState = XComGameState_Effect_DLC_3AbsorptionField(XComGameState_Unit(ActionMetadata.StateObject_NewState).GetUnitAffectedByEffectState(EffectName));
		if (EffectState != none && EffectState.EnergyAbsorbed > 0)
		{
			PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			PlayAnimation.Params.AnimName = 'ADD_AbsorptionField';
			PlayAnimation.Params.Additive = true;
		}
	}
}

function name TargetAdditiveAnimOnApplyWeaponDamage(XComGameStateContext Context, XComGameState_Unit TargetUnit, XComGameState_Effect EffectState)
{
	if (XComGameStateContext_Ability(Context) != none)
	{
		if (class'XComGameState_Effect_DLC_3AbsorptionField'.default.AbsorbedAbilities.Find(XComGameStateContext_Ability(Context).InputContext.AbilityTemplateName) != INDEX_NONE)
			return 'ADD_AbsorptionField';
	}

	return '';
}

function name ShooterAdditiveAnimOnFire(XComGameStateContext Context, XComGameState_Unit ShooterUnit, XComGameState_Effect EffectState) 
{
	local  XComGameState_Effect_DLC_3AbsorptionField FieldEffect;

	FieldEffect = XComGameState_Effect_DLC_3AbsorptionField(EffectState);
	if (FieldEffect != none && FieldEffect.LastEnergyExpendedContext == Context && FieldEffect.EnergyAbsorbed == 0)
		return 'ADD_AbsorptionField_End';

	return '';
}

DefaultProperties
{
	EffectName = "DLC_3AbsorptionField"
	DuplicateResponse = eDupe_Ignore
	GameStateEffectClass = class'XComGameState_Effect_DLC_3AbsorptionField';
	bDisplayInSpecialDamageMessageUI = true
}
