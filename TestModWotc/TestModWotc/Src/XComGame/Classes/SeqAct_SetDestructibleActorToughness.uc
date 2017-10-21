//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SetDestructibleActorToughness.uc
//  AUTHOR:  Liam Collins --  10/25/2013
//  PURPOSE: This sequence action changes the toughness setting on a 
//           destructible actor.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class SeqAct_SetDestructibleActorToughness extends SequenceAction;

var Actor   TargetActor;
var XComGameState_InteractiveObject TargetObject;
var() XComDestructibleActor_Toughness TargetToughness;
var() bool PerserveHealthPercent;
var() bool DoNotUpdateGamestate;

event Activated()
{
	local XComDestructibleActor TargetDestructible;	
	local float fHealthPercentage;
	local XComGameState NewGameState;
	local XComGameState_InteractiveObject NewTargetState;

	if (TargetObject != none)
	{
		TargetActor = TargetObject.GetVisualizer();
	}

	TargetDestructible = XComDestructibleActor(TargetActor);
	fHealthPercentage = TargetDestructible.Health / float(TargetDestructible.TotalHealth);

	if( TargetDestructible != none )
	{
		TargetDestructible.Toughness = TargetToughness;		
		TargetDestructible.TotalHealth = TargetToughness.Health;

		if(`SecondWaveEnabled('BetaStrike' ))
		{
			TargetDestructible.TotalHealth *= class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod;
		}

			if (PerserveHealthPercent)
			{
				TargetDestructible.Health = int(TargetDestructible.TotalHealth * fHealthPercentage);

				// We don't want to accidentally interp the health of this actor below 1
				if(TargetDestructible.Health < 1)
				{
					TargetDestructible.Health = 1;
				}
			}
			else
			{
				TargetDestructible.Health = TargetDestructible.TotalHealth;
			}

		if(!DoNotUpdateGamestate)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "SeqAct_SetDestructibleActorToughness" );
			NewTargetState = XComGameState_InteractiveObject( NewGameState.ModifyStateObject( class'XComGameState_InteractiveObject', TargetObject.ObjectID ) );

			NewTargetState.Health = TargetDestructible.Health;

			NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);

			`TACTICALRULES.SubmitGameState( NewGameState );
		}
	}
	else
	{
		`warn("SeqAct_SetDestructibleToughness called on non destructible actor:"@TargetActor@" This sequence action requires a destructible actor input.");
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjCategory="Level"
	ObjName="Set DestructibleActor Toughness"
	bCallHandler=false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	PerserveHealthPercent = false;
	DoNotUpdateGamestate = false;

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
	VariableLinks(1)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Target Object",PropertyName=TargetObject)
}
