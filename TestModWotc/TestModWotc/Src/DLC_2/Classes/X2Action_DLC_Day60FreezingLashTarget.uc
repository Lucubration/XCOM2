//---------------------------------------------------------------------------------------
//  FILE:    X2Action_DLC_Day60FreezingLashTarget.uc
//  AUTHOR:  Michael Donovan
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Action_DLC_Day60FreezingLashTarget extends X2Action;

//Cached info for the unit performing the action
//*************************************
var private XComGameStateContext_Ability AbilityContext;
var private CustomAnimParams	Params;
var private Vector				DesiredLocation;
var private float				DistanceToTargetSquared;

var private BoneAtom StartingAtom;
var private Rotator DesiredRotation;
//*************************************

function Init()
{
	super.Init();

	AbilityContext = XComGameStateContext_Ability(StateChangeContext);
}

function bool CheckInterrupted()
{
	return false;
}

function SetDesiredLocation(Vector NewDesiredLocation, XGUnit NeededForZ)
{
	DesiredLocation = NewDesiredLocation;
	DesiredLocation.Z = NeededForZ.GetDesiredZForLocation(DesiredLocation);
}

simulated state Executing
{
Begin:
	//Wait for our turn to complete... and then set our rotation to face the destination exactly
	while( UnitPawn.m_kGameUnit.IdleStateMachine.IsEvaluatingStance() )
	{
		Sleep(0.01f);
	}

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;

	Params.AnimName = 'NO_StrangleStart';
	DesiredRotation = Rotator(Normal(DesiredLocation - UnitPawn.Location));
	StartingAtom.Rotation = QuatFromRotator(DesiredRotation);
	StartingAtom.Translation = UnitPawn.Location;
	StartingAtom.Scale = 1.0f;
	UnitPawn.GetAnimTreeController().GetDesiredEndingAtomFromStartingAtom(Params, StartingAtom);
	UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

	// hide the targeting icon
	Unit.SetDiscState(eDS_None);

	DistanceToTargetSquared = VSizeSq(DesiredLocation - UnitPawn.Location);
	while( DistanceToTargetSquared > Square(UnitPawn.fStrangleStopDistance) )
	{
		Sleep(0.0f);
		DistanceToTargetSquared = VSizeSq(DesiredLocation - UnitPawn.Location);
	}

	UnitPawn.bSkipIK = false;
	Params = default.Params;
	Params.AnimName = 'NO_StrangleStop';
	Params.DesiredEndingAtoms.Add(1);
	Params.DesiredEndingAtoms[0].Scale = 1.0f;
	Params.DesiredEndingAtoms[0].Translation = DesiredLocation;
	DesiredRotation = UnitPawn.Rotation;
	DesiredRotation.Pitch = 0.0f;
	DesiredRotation.Roll = 0.0f;
	Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(DesiredRotation);
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}

DefaultProperties
{
}
