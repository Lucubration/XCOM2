class X2Action_Lucu_CombatEngineer_FireOnce extends X2Action_Fire;

var private CustomAnimParams AnimParams;
var private Vector TowardsTarget;
var private AnimNotify_FireWeaponVolley Volley;
var private Weapon OriginalWeapon;
var private XComWeapon NewWeapon;
var private X2UnifiedProjectile OriginalProjectile;
var private XComPresentationLayer PresentationLayer;
var private bool bReceivedFireMessage;

function Init()
{
	local XComGameState_Ability AbilityState;	
	local XComGameState_Item WeaponItem;

	super.Init();
    
	PresentationLayer = `PRES;

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	WeaponItem = AbilityState.GetSourceWeapon();
	WeaponVisualizer = XGWeapon(WeaponItem.GetVisualizer());

	bReceivedFireMessage = false;
}

function NotifyTargetsAbilityApplied()
{
	if (!bReceivedFireMessage)
	{
		DoNotifyTargetsAbilityAppliedWithMultipleHitLocations(VisualizeGameState, AbilityContext, StateChangeContext.AssociatedState.HistoryIndex, ProjectileHitLocation, 
															  allHitLocations, PrimaryTargetID, bNotifyMultiTargetsAtOnce);

		bReceivedFireMessage = true;
	}
}

simulated state Executing
{
	simulated function BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
	}

	simulated event Tick(float fDeltaT)
	{
		super.Tick(fDeltaT);
	}

Begin:
    // The primary target should never be fogged
	if ((XGUnit(PrimaryTarget) != none))
	{
		HideFOW();
	}
    
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
    
	OriginalWeapon = UnitPawn.Weapon;
    NewWeapon = WeaponVisualizer.GetEntity();
	UnitPawn.Weapon = NewWeapon; // Temporarily replace equipped weapon
    OriginalProjectile = NewWeapon.DefaultProjectileTemplate;
    NewWeapon.DefaultProjectileTemplate = none; // Temporarily remove default projectile
	Sleep(0.1f);        // Make sure weapon is attached properly
    
    // Must ensure aim at target. For some reason I don't understand, X2Action_ExitCover is not
    // letting our unit aim when out of cover. I'm going to force the issue here
	if (Unit.bShouldStepOut == false && Unit.m_eCoverState == eCS_None)
	{
		AnimParams = default.AnimParams;
		AnimParams.PlayRate = GetNonCriticalAnimationSpeed();
		AnimParams.AnimName = 'HL_FireStart';

		AnimParams.DesiredEndingAtoms.Add(1);
		AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;
		AnimParams.DesiredEndingAtoms[0].Translation = UnitPawn.Location;
				
		TowardsTarget = TargetLocation - UnitPawn.Location;
		TowardsTarget.Z = 0;
		TowardsTarget = Normal(TowardsTarget);
		AnimParams.DesiredEndingAtoms[0].Rotation = QuatFromRotator(Rotator(TowardsTarget));
				
		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams), false, class'X2Action_ExitCover'.default.CrossFadeTime);
	}

	Volley = new class'AnimNotify_FireWeaponVolley';
	Unit.AddProjectileVolley(Volley);

	while (!bReceivedFireMessage && !IsTimedOut())
		Sleep(0.0f);
        
	// Signal that we are done with our fire animation
	`XEVENTMGR.TriggerEvent('Visualizer_AnimationFinished', self, self);

	// Taking a shot causes overwatch to be removed
	PresentationLayer.m_kUnitFlagManager.RealizeOverwatch(Unit.ObjectID, History.GetCurrentHistoryIndex());

	// Failure case handling! We failed to notify our targets that damage was done. Notify them now.
	SetTargetUnitDiscState();

	Volley = none;
    NewWeapon.DefaultProjectileTemplate = OriginalProjectile; // Replace original default projectile
	UnitPawn.Weapon = OriginalWeapon; // Replace original equipped weapon
    
	if (FOWViewer != none)
	{
		`XWORLD.DestroyFOWViewer(FOWViewer);

		if (XGUnit(PrimaryTarget).IsAlive())
		{
			XGUnit(PrimaryTarget).SetForceVisibility(eForceNone);
			XGUnit(PrimaryTarget).GetPawn().UpdatePawnVisibility();
		}
		else
		{
			//Force dead bodies visible
			XGUnit(PrimaryTarget).SetForceVisibility(eForceVisible);
			XGUnit(PrimaryTarget).GetPawn().UpdatePawnVisibility();
		}
	}

	if (SourceFOWViewer != none)
	{
		`XWORLD.DestroyFOWViewer(SourceFOWViewer);

		Unit.SetForceVisibility(eForceNone);
		Unit.GetPawn().UpdatePawnVisibility();
	}

	// Wait for any projectiles we created to finish their trajectory before continuing
	while (ShouldWaitToComplete())
	{
		Sleep(0.0f);
	};

	CompleteAction();
}