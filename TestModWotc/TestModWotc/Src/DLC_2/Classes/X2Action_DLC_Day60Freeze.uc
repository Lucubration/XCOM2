//---------------------------------------------------------------------------------------
//  FILE:    X2Action_DLC_Day60Freeze.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Action_DLC_Day60Freeze extends X2Action;

var bool PlayIdle;

var private float IdleBlend_S;

simulated function FreezeActionUnit()
{
	local CustomAnimParams AnimParams;

	AnimParams.AnimName = 'FreezePose';
	AnimParams.Looping = true;
	AnimParams.BlendTime = 0.0f;
	AnimParams.HasPoseOverride = true;
	AnimParams.Pose = UnitPawn.Mesh.LocalAtoms;

	UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);

	AnimParams.AnimName = 'ADD_FreezeStart';
	AnimParams.Looping = false;
	AnimParams.HasPoseOverride = false;
	if( UnitPawn.GetAnimTreeController().CanPlayAnimation(AnimParams.AnimName) )
	{
		UnitPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(AnimParams);
	}

	// Ensure we disable aiming, snap it when they freeze since it would look weird for them
	// to aim (movement) while frozen
	UnitPawn.SetAiming(false, 0.0f);

	UnitPawn.GetAnimTreeController().BlendOutDynamicNode(0.0f, BLEND_MASK_UPPERBODY);
	UnitPawn.GetAnimTreeController().BlendOutDynamicNode(0.0f, BLEND_MASK_LEFTARM);
	UnitPawn.GetAnimTreeController().BlendOutDynamicNode(0.0f, BLEND_MASK_RIGHTARM);
	UnitPawn.GetAnimTreeController().BlendOutDynamicNode(0.0f, BLEND_MASK_HEAD);
	UnitPawn.GetAnimTreeController().BlendOutDynamicNode(0.0f, BLEND_MASK_ADDITIVE);

	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(false);
}

function ForceImmediateTimeout()
{
	// Do nothing. Since we want to ensure we freeze in the idle pose
}

event bool BlocksAbilityActivation()
{
	return true;
}

simulated state Executing
{
Begin:
	if( PlayIdle )
	{
		IdleBlend_S = UnitPawn.Into_Idle_Blend;
		UnitPawn.Into_Idle_Blend = 0.0f;
		Unit.IdleStateMachine.PlayIdleAnim(true);
		Sleep(0.0f);
		UnitPawn.Into_Idle_Blend = IdleBlend_S;
	}

	FreezeActionUnit();

	CompleteAction();
}