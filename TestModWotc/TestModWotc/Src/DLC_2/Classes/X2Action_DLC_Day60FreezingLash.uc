//---------------------------------------------------------------------------------------
//  FILE:    X2Action_DLC_Day60FreezingLash.uc
//  AUTHOR:  Michael Donovan
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Action_DLC_Day60FreezingLash extends X2Action_Fire;

var XGWeapon UseWeapon;
var XComWeapon	PreviousWeapon;
var bool ProjectileHit;
var XComUnitPawn FocusUnitPawn;

var private CustomAnimParams Params;

function Init()
{
	super.Init();

	if( AbilityContext.InputContext.ItemObject.ObjectID > 0 )
	{
		UseWeapon = XGWeapon(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID).GetVisualizer());
	}
}

function bool CheckInterrupted()
{
	return false;
}

function NotifyTargetsAbilityApplied()
{
	super.NotifyTargetsAbilityApplied();
	ProjectileHit = true;
}

simulated state Executing
{
	function StartTargetFaceSoldier()
	{
		local Vector FaceVector;

		FocusUnitPawn = XGUnit(PrimaryTarget).GetPawn();

		FaceVector = UnitPawn.Location - FocusUnitPawn.Location;
		FaceVector = Normal(FaceVector);

		FocusUnitPawn.m_kGameUnit.IdleStateMachine.ForceHeading(FaceVector);
	}

Begin:
	PreviousWeapon = XComWeapon(UnitPawn.Weapon);
	UnitPawn.SetCurrentWeapon(XComWeapon(UseWeapon.m_kEntity));

	Unit.CurrentFireAction = self;
	Params.AnimName = 'NO_FreezingLashStart';
	UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

	//Make the target face us
	StartTargetFaceSoldier();
	Sleep(0.1f);

	//Wait for our turn to complete so that we are facing mostly the right direction when the target's RMA animation starts
	while( FocusUnitPawn.m_kGameUnit.IdleStateMachine.IsEvaluatingStance() )
	{
		Sleep(0.01f);
	}

	while( !ProjectileHit )
	{
		Sleep(0.01f);
	}

	Params.AnimName = 'NO_FreezingLashStop';
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));

	FocusUnitPawn.m_kGameUnit.IdleStateMachine.CheckForStanceUpdateOnIdle();

	UnitPawn.SetCurrentWeapon(PreviousWeapon);

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}

DefaultProperties
{
}