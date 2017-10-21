//---------------------------------------------------------------------------------------
//  FILE:    X2Action_DLC_Day60FreezeEnd.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Action_DLC_Day60FreezeEnd extends X2Action;
var AnimNodeSequence PlayingSequence;
var CustomAnimParams AnimParams;

simulated function UnFreezeActionUnit()
{
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
	
	AnimParams.AnimName = 'ADD_FreezeStop';
	if( UnitPawn.GetAnimTreeController().CanPlayAnimation(AnimParams.AnimName) )
	{
		PlayingSequence = UnitPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(AnimParams);
	}

	if( !Unit.m_DeadInVisualizer )
	{
		Unit.IdleStateMachine.PerformFlinch();
	}
}

event bool BlocksAbilityActivation()
{
	return true;
}

simulated state Executing
{
Begin:
	UnFreezeActionUnit();

	FinishAnim(PlayingSequence);
	AnimParams.AnimName = 'ADD_FreezeStop';
	UnitPawn.GetAnimTreeController().RemoveAdditiveDynamicAnim(AnimParams);
	AnimParams.AnimName = 'ADD_FreezeStart';
	UnitPawn.GetAnimTreeController().RemoveAdditiveDynamicAnim(AnimParams);

	CompleteAction();
}