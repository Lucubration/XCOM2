//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserv3ed.
//---------------------------------------------------------------------------------------
class X2Action_Fire_Wave extends X2Action_Fire
	config(GameData);

var config float WaveSpeed;

var AnimNodeSequence PlayingSequence;
var Array<int> ObjectIDsForTimer;
var Array<float> TimersOrder;
var Array<bool> WorldDamage;
var float WaveTime;

function Init()
{
	Super.Init();
	TimeoutSeconds = 15.0f;
}

function NotifyTargetsAbilityApplied()
{
	local int MultiTargetIndex;
	local XComGameState_InteractiveObject InteractiveObject;
	local Actor CurrentActor;
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;

	CurrentActor = `XCOMHISTORY.GetVisualizer(PrimaryTargetID);
	if( CurrentActor != None )
	{
		AddTimer(PrimaryTargetID, CurrentActor.Location);
	}
	
	for( MultiTargetIndex = 0; MultiTargetIndex < AbilityContext.InputContext.MultiTargets.length; ++MultiTargetIndex )
	{
		CurrentActor = `XCOMHISTORY.GetVisualizer(AbilityContext.InputContext.MultiTargets[MultiTargetIndex].ObjectID);
		if( CurrentActor != None )
		{
			AddTimer(AbilityContext.InputContext.MultiTargets[MultiTargetIndex].ObjectID, CurrentActor.Location);
		}
	}

	// find all the interactive objects that are within half a tile of the arc segment
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
	{
		CurrentActor = `XCOMHISTORY.GetVisualizer(InteractiveObject.ObjectID);
		if( CurrentActor != None )
		{
			AddTimer(InteractiveObject.ObjectID, CurrentActor.Location);
		}
	}

	// find all the environmental damage that are within half a tile of the arc segment
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		AddTimer(EnvironmentDamageEvent.ObjectID, EnvironmentDamageEvent.HitLocation);
	}

	WaveTime = 0;
	// Jwats: Make sure we don't timeout before sending all our events
	if( TimersOrder.Length != 0 )
	{
		TimeoutSeconds += TimersOrder[TimersOrder.Length - 1];
	}
}

function AddTimer(int ObjectID, Vector TestLocation)
{
	local float DistanceToActor;
	local float TimerDuration;
	local int TimerIndex;
	local bool Placed;

	DistanceToActor = VSize2D(TestLocation - UnitPawn.Location);
	TimerDuration = DistanceToActor / WaveSpeed;
	Placed = false;
	for( TimerIndex = 0; TimerIndex < TimersOrder.Length; ++TimerIndex )
	{
		if( TimerDuration < TimersOrder[TimerIndex] )
		{
			TimersOrder.InsertItem(TimerIndex, TimerDuration);
			ObjectIDsForTimer.InsertItem(TimerIndex, ObjectID);
			Placed = true;
			break;
		}
	}

	if( !Placed )
	{
		TimersOrder.AddItem(TimerDuration);
		ObjectIDsForTimer.AddItem(ObjectID);
	}
}

function HandleSingleTarget(int Index)
{
	local int TargetObjectID;

	TargetObjectID = ObjectIDsForTimer[Index];
	if( TargetObjectID > 0 )
	{
		`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', History.GetGameStateForObjectID( TargetObjectID ), self);
		`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', History.GetGameStateForObjectID(TargetObjectID), self);
		ObjectIDsForTimer.Remove(Index, 1);
		TimersOrder.Remove(Index, 1);
	}
}

function bool ShouldWaitToComplete()
{
	local bool RetVal;

	RetVal = Super.ShouldWaitToComplete() || TimersOrder.Length != 0;

	return RetVal;
}

state Executing
{
	simulated event Tick(float fDeltaT)
	{
		local int ScanTimers;

		super.Tick(fDeltaT);

		WaveTime += fDeltaT;
		for( ScanTimers = 0; ScanTimers < TimersOrder.Length; ScanTimers++ )
		{
			if( WaveTime >= TimersOrder[ScanTimers] )
			{
				HandleSingleTarget(ScanTimers);
				ScanTimers -= 1;
			}
			else
			{
				break;
			}
		}
	}
}

DefaultProperties
{
	bNotifyMultiTargetsAtOnce = false;
}
