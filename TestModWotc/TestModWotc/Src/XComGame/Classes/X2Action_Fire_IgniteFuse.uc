class X2Action_Fire_IgniteFuse extends X2Action_Fire;

var protected AnimNotify_FireWeaponVolley   Volley;
var protected Weapon OriginalWeapon;
var private bool bReceivedDetonationMessage;

function Init()
{
	local XComGameState_Ability AbilityState;	
	local XComGameState_Item WeaponItem;

	super.Init();

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	WeaponItem = AbilityState.GetSourceWeapon();
	WeaponVisualizer = XGWeapon(WeaponItem.GetVisualizer());

	bReceivedDetonationMessage = false;
}

function NotifyTargetsAbilityApplied()
{
	if( !bReceivedDetonationMessage )
	{
		DoNotifyTargetsAbilityAppliedWithMultipleHitLocations(VisualizeGameState, AbilityContext, StateChangeContext.AssociatedState.HistoryIndex, ProjectileHitLocation, 
															  allHitLocations, PrimaryTargetID, bNotifyMultiTargetsAtOnce);

		bReceivedDetonationMessage = true;
	}
}

simulated state Executing
{
	simulated function BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
	}

	simulated event Tick( float fDeltaT )
	{
		//  nothing
	}

Begin:
	OriginalWeapon = UnitPawn.Weapon;
	UnitPawn.Weapon = WeaponVisualizer.GetEntity();
	Sleep(0.1f);        //  make sure weapon is attached properly
	Volley = new class'AnimNotify_FireWeaponVolley';
	Unit.AddProjectileVolley(Volley);

	while (!bReceivedDetonationMessage && !IsTimedOut())
		Sleep(0.0f);

	SetTargetUnitDiscState();
	Volley = none;
	UnitPawn.Weapon = OriginalWeapon;
	CompleteAction();
}