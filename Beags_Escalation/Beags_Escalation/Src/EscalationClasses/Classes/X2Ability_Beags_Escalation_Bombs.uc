class X2Ability_Beags_Escalation_Bombs extends X2Ability
	config(Beags_Escalation_Ability);

var name BreachingChargePlantAbilityName;
var name BreachingChargeDetonationAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	//Templates.AddItem(PlantBreachingCharge());
	//Templates.AddItem(DetonateBreachingCharge());

	return Templates;
}

static function X2AbilityTemplate PlantBreachingCharge()
{
	local X2AbilityTemplate									Template;	
	local X2Effect_Beags_Escalation_BreachingCharge			BreachingChargeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.BreachingChargePlantAbilityName);

	PlantBombHelper(Template);
	
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_grenade_proximitymine";

	BreachingChargeEffect = new class'X2Effect_Beags_Escalation_BreachingCharge';
	BreachingChargeEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddShooterEffect(BreachingChargeEffect);

	return Template;
}

static function X2AbilityTemplate DetonateBreachingCharge()
{
	local X2AbilityTemplate								Template;
	local X2Condition_UnitEffects						EffectsCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.BreachingChargeDetonationAbilityName);
	
	BombDetonationHelper(Template);
	
	Template.IconImage = "img:///UILibrary_Beags_Escalation_Icons.UIPerk_shaken";
	
	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddRequireEffect('X2Effect_Beags_Escalation_BreachingCharge', 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(EffectsCondition);

	Template.BuildVisualizationFn = BreachingChargeDetonation_BuildVisualization;

	return Template;
}

static function PlantBombHelper(X2AbilityTemplate Template)
{
	local X2AbilityCost_Ammo								AmmoCost;
	local X2AbilityCost_ActionPoints						ActionPointCost;
	local X2AbilityTarget_Beags_Escalation_RadiusCursor		CursorTarget;
	local X2AbilityMultiTarget_Beags_Escalation_RadialCone	ConeMultiTarget;
	local X2Condition_UnitProperty							UnitPropertyCondition;

	Template.bDontDisplayInAbilitySummary = true;
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	Template.bUseThrownGrenadeEffects = true;
	Template.bHideWeaponDuringFire = true;
	
	CursorTarget = new class'X2AbilityTarget_Beags_Escalation_RadiusCursor';
	CursorTarget.bRestrictToWeaponRadius = true;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Beags_Escalation_RadialCone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.SoldierAbilityName = 'VolatileMix';
	ConeMultiTarget.BonusRadius = class'X2Ability_GrenadierAbilitySet'.default.VOLATILE_RADIUS;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; //The grenade can affect interactive objects, others
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	Template.bRecordValidTiles = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fraggrenade";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_GrenadeUnderhand';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.DamagePreviewFn = BombDamagePreview;
	Template.TargetingMethod = class'X2TargetingMethod_Beags_Escalation_Cone';

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
}

static function BombDetonationHelper(X2AbilityTemplate Template)
{
	local X2AbilityCost_ActionPoints						ActionPointCost;
	local X2AbilityTarget_Self								TargetStyle;
	local X2AbilityMultiTarget_Beags_Escalation_RadialCone	ConeMultiTarget;
	local X2Condition_UnitProperty							UnitPropertyCondition;
	local X2Effect_ApplyWeaponDamage						WeaponDamage;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffect(new class'X2Effect_BreakUnitConcealment');
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Beags_Escalation_RadialCone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.SoldierAbilityName = 'VolatileMix';
	ConeMultiTarget.BonusRadius = class'X2Ability_GrenadierAbilitySet'.default.VOLATILE_RADIUS;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; // The bomb can affect interactive objects, others
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	WeaponDamage = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamage.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamage);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shaken";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bLimitTargetIcons = true;
	Template.bStationaryWeapon = true;

	Template.FrameAbilityCameraType = eCameraFraming_Never;

	Template.ActivationSpeech = 'Explosion';
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Cannot interrupt this explosion
}

function BreachingChargeDetonation_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateContext_Ability AbilityContext;
	local int ShooterID, ShooterTrackIdx, LoopIdx;
	local VisualizationTrack VisTrack;
	local X2Action_PlayEffect EffectAction;
	local X2Action_SendInterTrackMessage MessageAction;
	local X2Action_WaitForAbilityEffect WaitAction;
	local X2Action_CameraLookAt LookAtAction;
	local X2Action_Delay DelayAction;
	local X2Action_StartStopSound SoundAction;

	ShooterTrackIdx = INDEX_NONE;
	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	ShooterID = AbilityContext.InputContext.SourceObject.ObjectID;
	TypicalAbility_BuildVisualization(VisualizeGameState, OutVisualizationTracks);

	//Find and grab the "shooter" track - the unit who threw the proximity mine initially
	for (LoopIdx = 0; LoopIdx < OutVisualizationTracks.Length; ++LoopIdx)
	{
		VisTrack = OutVisualizationTracks[LoopIdx];
		if (ShooterID == VisTrack.StateObject_NewState.ObjectID)
		{
			ShooterTrackIdx = LoopIdx;
			break;
		}
	}
	`assert(ShooterTrackIdx != INDEX_NONE);

	//Clear the track and use it for the camera and detonation
	OutVisualizationTracks[ShooterTrackIdx].TrackActions.Length = 0;

	//Camera comes first
	LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.CreateVisualizationAction(AbilityContext));
	LookAtAction.LookAtLocation = AbilityContext.InputContext.TargetLocations[0];
	LookAtAction.BlockUntilFinished = true;
	LookAtAction.LookAtDuration = 2.0f;
	OutVisualizationTracks[ShooterTrackIdx].TrackActions.AddItem(LookAtAction);
	
	//Do the detonation
	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.CreateVisualizationAction(AbilityContext));
	EffectAction.EffectName = class'X2Ability_Grenades'.default.ProximityMineExplosion;
	EffectAction.EffectLocation = AbilityContext.InputContext.TargetLocations[0];
	EffectAction.EffectRotation = Rotator(vect(0, 0, 1));
	EffectAction.bWaitForCompletion = false;
	EffectAction.bWaitForCameraCompletion = false;
	OutVisualizationTracks[ShooterTrackIdx].TrackActions.AddItem(EffectAction);

	SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.CreateVisualizationAction(AbilityContext));
	SoundAction.Sound = new class'SoundCue';
	SoundAction.Sound.AkEventOverride = AkEvent'SoundX2CharacterFX.Proximity_Mine_Explosion';
	SoundAction.bIsPositional = true;
	SoundAction.vWorldPosition = AbilityContext.InputContext.TargetLocations[0];
	OutVisualizationTracks[ShooterTrackIdx].TrackActions.AddItem(SoundAction);

	//Make everyone else wait for the detonation
	for (LoopIdx = 0; LoopIdx < OutVisualizationTracks.Length; ++LoopIdx)
	{
		if (LoopIdx == ShooterTrackIdx)
			continue;

		WaitAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.CreateVisualizationAction(AbilityContext));
		OutVisualizationTracks[LoopIdx].TrackActions.InsertItem(0, WaitAction);

		MessageAction = X2Action_SendInterTrackMessage(class'X2Action_SendInterTrackMessage'.static.CreateVisualizationAction(AbilityContext));
		MessageAction.SendTrackMessageToRef = OutVisualizationTracks[LoopIdx].StateObject_NewState.GetReference();
		OutVisualizationTracks[ShooterTrackIdx].TrackActions.AddItem(MessageAction);
	}
	
	//Keep the camera there after things blow up
	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.CreateVisualizationAction(AbilityContext));
	DelayAction.Duration = 0.5;
	OutVisualizationTracks[ShooterTrackIdx].TrackActions.AddItem(DelayAction);

}

//  Special handling for bombs as they do not deal damage until they explode and therefore don't have damage effects for plant
function bool BombDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Item ItemState;
	local X2BombTemplate_Beags_Escalation BombTemplate;
	local XComGameState_Ability DetonationAbility;
	local XComGameState_Unit SourceUnit;
	local XComGameStateHistory History;
	local StateObjectReference AbilityRef;

	ItemState = AbilityState.GetSourceAmmo();
	if (ItemState == none)
		ItemState = AbilityState.GetSourceWeapon();

	if (ItemState == none)
		return false;

	BombTemplate = X2BombTemplate_Beags_Escalation(ItemState.GetMyTemplate());
	if (BombTemplate == none)
		return false;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	AbilityRef = SourceUnit.FindAbility(BombTemplate.Abilities[1], ItemState.GetReference());
	`assert(AbilityRef.ObjectID > 0);
	DetonationAbility = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
	if (DetonationAbility == none)
		return false;

	DetonationAbility.GetDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	return true;
}

DefaultProperties
{
	BreachingChargePlantAbilityName="Beags_Escalation_PlantBreachingCharge"
	BreachingChargeDetonationAbilityName = "Beags_Escalation_DetonateBreachingCharge"
}