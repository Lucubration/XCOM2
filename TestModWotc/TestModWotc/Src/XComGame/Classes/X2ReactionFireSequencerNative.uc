//---------------------------------------------------------------------------------------
//  FILE:    X2ReactionFireSequencer.uc
//  AUTHOR:  Ryan McFall --  07/08/2015
//  PURPOSE: Pulls together logic that formerly lived in X2Actions related to firing with
//			 the goal of compartmentalizing the specialized logic needed to control the 
//			 camera and slo mo rates of actors participating in a reaction fire sequence.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2ReactionFireSequencerNative extends Actor native(Core) config(Camera);

var protectedwrite XComGameStateHistory History;
var protectedwrite int ReactionFireCount;

var protectedwrite X2Camera_OverTheShoulder TargetCam; //Used to cut to a shot where the target is in the foreground and the shooter is in the background
var protectedwrite AkEvent SlomoStartSound;
var protectedwrite AkEvent SlomoStopSound;
var protectedwrite bool bFancyOverwatchActivated;

//Track information about what the target is for the current reaction fire sequence
var protectedwrite Actor TargetVisualizer;
var protectedwrite X2VisualizerInterface TargetVisualizerInterface;

var protectedwrite const config float ReactionFireWorldSloMoRate;
var protectedwrite float ReactionFireTargetSloMoRate;

struct native ReactionFireInstance
{
	var int ShooterObjectID;
	var int TargetObjectID;
	var X2Action_ExitCover ExitCoverAction; // The reaction fire mgr will make this action wait until the shooting action is ready to be shown
	var X2Camera ShooterCam;
	var bool bStarted; //tracks whether this instance was started or not
	var bool bReadyForNext; //tracks whether this instance is 'done' or not
	var bool bComplete; // tracks whether this instance has been popped off the set of reactions
	var Vector ShotDir; //Direction of the shot for this reaction fire. Used to order / sort the reaction fire sequence
};
var protectedwrite array<ReactionFireInstance> ReactionFireInstances;
var protectedwrite array<X2Camera> AddedCameras; //This is an array that contains all cameras that have been added to the camera stack. Used to make sure they all get removed at the end of the sequence.

/// <summary>
/// Returns the number of reaction fire events remaining in the interrupt chain
/// </summary>
protected function int GetNumRemainingReactionFires(XComGameStateContext_Ability FiringAbilityContext, optional out XComGameStateContext_Ability OutNextReactionFire, optional out int NumTilesVisibleToShooters)
{
	local int Index;
	local XComGameStateHistory LocalHistory;
	local XComGameState TestState;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityToHitCalc_StandardAim ToHitCalc;
	local XComGameStateContext CheckContext;
	local XComGameStateContext_Ability CheckAbilityContext;
	local XComGameState InterruptedState, ResumeState;
	local XComGameStateContext_Ability InterruptedAbility;
	local XComGameStateContext_Ability ResumeAbility;
	local array<int> ShooterObjectIDs;
	local int NumReactionFireShots;
	local int ShooterIndex;
	local int TargetObjectID;
	local int TargetPathIndex;
	local int PathTileIndex;
	local PathingResultData PathingData;
	local bool bShootersCanSee;
	local int FirstInterruptStep;

	LocalHistory = `XCOMHISTORY;

		InterruptedState = FiringAbilityContext.GetInterruptedState();
	if (InterruptedState == none) // non-interrupt reaction fire (return fire et al).
		return 0;

	InterruptedAbility = XComGameStateContext_Ability(InterruptedState.GetContext());
	`assert( InterruptedAbility != none );
	FirstInterruptStep = InterruptedAbility.ResultContext.InterruptionStep;
	TargetObjectID = InterruptedAbility.InputContext.SourceObject.ObjectID;
	ShooterObjectIDs.Length = 0;

	NumTilesVisibleToShooters = 0; //Default to no tiles visible. Either the unit died or immediately broke LOS with the shooters.
	for (Index = FiringAbilityContext.AssociatedState.HistoryIndex + 1; Index < LocalHistory.GetNumGameStates(); ++Index)
	{
		TestState = LocalHistory.GetGameStateFromHistory(Index);

		//Exit if we have left our event chain. Will happen in cases where there is no resume
		CheckContext = TestState.GetContext();
		if (CheckContext.EventChainStartIndex != FiringAbilityContext.EventChainStartIndex)
		{
			break;
		}

		//Exit if we found the resume state
		if (InterruptedAbility.ResumeHistoryIndex != -1 &&
			InterruptedAbility.ResumeHistoryIndex == TestState.HistoryIndex)
		{
			//Here, were traverse the interrupt chain checking for more interrupts along this unit's path. We treat an additional interrupt 
			//in the same way we would treat the unit moving behind a wall - the reaction fire sequence shouldn't last past it.
			if (InterruptedState.GetContext() != None && InterruptedState.GetContext().GetResumeState() != None)
			{
				ResumeAbility = XComGameStateContext_Ability(InterruptedState.GetContext().GetResumeState().GetContext());
			}
			while (ResumeAbility != none && ResumeAbility.InterruptionStatus == eInterruptionStatus_Interrupt)
			{
				InterruptedState = LocalHistory.GetGameStateFromHistory(ResumeAbility.AssociatedState.HistoryIndex + 1);
				if (XComGameStateContext_Ability(InterruptedState.GetContext()) != none)
				{
					//Interrupted by an ability - abort.
					break;
				}

				//Get the resume context and repeat
				ResumeState = InterruptedState.GetContext().GetResumeState();
				ResumeAbility = ResumeState != none ? XComGameStateContext_Ability(ResumeState.GetContext()) : none;
			}

			//We know at this point that there will be no further interruptions along this path. Now see how many tiles we can see along the path
			if (ResumeAbility == None || ResumeAbility.InterruptionStatus != eInterruptionStatus_Interrupt)
			{
				//Find the path results representing the unit that is moving and being fired at. Will not do anything if there was no move / path results.
				for (TargetPathIndex = 0; TargetPathIndex < InterruptedAbility.ResultContext.PathResults.Length; ++TargetPathIndex)
				{
					//Handle group moves such as alien patrols, specialist + gremlin. Find the right target unit.
					if (InterruptedAbility.ResultContext.PathResults[TargetPathIndex].PathTileData.Length > 0 &&
						InterruptedAbility.ResultContext.PathResults[TargetPathIndex].PathTileData[0].SourceObjectID == TargetObjectID)
					{
						//Iterate the path, finding out how many tiles of the resume path that the overwatching units can see
						PathingData = InterruptedAbility.ResultContext.PathResults[TargetPathIndex];

						//For each tile the unit moves through during this reaction fire sequence, check to see whether the shooters can see them at that tile as recorded by
						//the path results array ( filled out when the most is submitted to the ruleset ).
						for (PathTileIndex = FirstInterruptStep; PathTileIndex < PathingData.PathTileData.Length; ++PathTileIndex)
						{
							bShootersCanSee = true;
							for (ShooterIndex = 0; ShooterIndex < ShooterObjectIDs.Length; ++ShooterIndex)
							{
								if (PathingData.PathTileData[PathTileIndex].VisibleEnemies.Find('SourceID', ShooterObjectIDs[ShooterIndex]) == -1)
								{
									bShootersCanSee = false;
									break;
								}
							}

							//All the shooters could see this tile, increment the number of tiles visible to the shooters
							if (bShootersCanSee)
							{
								++NumTilesVisibleToShooters;
							}
						}
					}
				}
			}

			break;
		}

		CheckAbilityContext = XComGameStateContext_Ability(TestState.GetContext());
		if (CheckAbilityContext != none)
		{
			AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(CheckAbilityContext.InputContext.AbilityTemplateName);
			if (AbilityTemplate != none)
			{
				ToHitCalc = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);
				if (ToHitCalc != none && ToHitCalc.bReactionFire)
				{
					++NumReactionFireShots;
					if (NumReactionFireShots == 1)
					{
						OutNextReactionFire = CheckAbilityContext;
					}

					ShooterObjectIDs.AddItem(CheckAbilityContext.InputContext.SourceObject.ObjectID);
				}
			}
		}
	}

	return NumReactionFireShots;
}

//Inserts the given reaction fire instance into ReactionFireInstances. The system will attempt to order them 
//such that the camera moves in a clockwise sweep
native function InsertReactionFireInstance(const out ReactionFireInstance NewInstance);

//Responsible for making sure the various actors involved in the reaction fire sequence have their time dilation set correctly
native function UpdateTimeDilation();

defaultproperties
{
	SlomoStartSound = AkEvent'SoundTacticalUI.TacticalUI_SlowMo_Start'
	SlomoStopSound = AkEvent'SoundTacticalUI.TacticalUI_SlowMo_Stop'
	ReactionFireTargetSloMoRate = 0.2
}