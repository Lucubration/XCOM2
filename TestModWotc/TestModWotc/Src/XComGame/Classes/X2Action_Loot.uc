//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Loot extends X2Action;

//Cached info for performing the action
//*************************************
var CustomAnimParams            Params;
var bool                        bLootingComplete;

// the socket on the receiving pawn that will accept each loot item
var Name						LootReceptionSocket;

// The length of time it will take each loot item to be slurped up
var float						LootSlurpTime;

var float						LootStartTimeSeconds;
var Vector						LootStartLoc;

var array<Actor>				LootVisActors;
var array<int>					LootVisActorsObjectIDs;
var array<string>				LootVisActorItemPickupStrings;
var int							LootableObjectID;

var Lootable					OldLootableObjectState;
var Lootable					NewLootableObjectState;

var XComGameState_Unit			OldUnitState, NewUnitState;
var AnimNodeSequence			PlayingSequence;

//*************************************

static function AddToVisualizationTreeIfLooted(Lootable LootableObject, XComGameStateContext Context, out VisualizationActionMetadata InTrack)
{
	local XComGameStateHistory History;
	local X2Action_Loot LootAction;
	local XComGameState_BaseObject LootableObjectState;
	local Lootable PreviousLootable;
	local X2Action_StartStopSound SoundAction;
	
	if(LootableObject != none) //  && !LootableObject.HasLoot())   jbouscher: the new item may in fact still have loot on it if the unit could not pick all of it up
	{
		History = `XCOMHISTORY;
		LootableObjectState = XComGameState_BaseObject(LootableObject);
		PreviousLootable = Lootable(History.GetGameStateForObjectID(LootableObjectState.ObjectID,, Context.AssociatedState.HistoryIndex - 1));

		if(PreviousLootable.HasLoot())
		{
			if( PreviousLootable.HasPsiLoot() && !LootableObject.HasPsiLoot() )
			{
				SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(InTrack, Context));
				SoundAction.Sound = new class'SoundCue';
				SoundAction.Sound.AkEventOverride = AkEvent'XPACK_SoundCharacterFX.Stop_Templar_Channel_Loot_Loop';
				SoundAction.iAssociatedGameStateObjectId = LootableObjectState.ObjectID;
				SoundAction.bIsPositional = true;
				SoundAction.vWorldPosition = History.GetVisualizer(LootableObjectState.ObjectID).Location;
				SoundAction.bStopPersistentSound = true;
			}
			LootAction = X2Action_Loot(AddToVisualizationTree(InTrack, Context));
			LootAction.LootableObjectID = LootableObjectState.ObjectID;
		}
	}
}

function Init()
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local int OldHistoryIndex, NewHistoryIndex, LootObjectID;
	local array<StateObjectReference> LootItemRefs, UnobtainedLootItemRefs;
	local Actor LootVisActor;
	local XGParamTag kTag;
	local XComGameState_Item ItemState;
	local XComPresentationLayer Presentation;

	super.Init();
	
	Presentation = `PRES;
	History = `XCOMHISTORY;
	bLootingComplete = false;

	UnitState = XComGameState_Unit(Metadata.StateObject_NewState);
	`assert(UnitState != none);

	NewHistoryIndex = Metadata.StateObject_NewState.GetParentGameState().HistoryIndex;
	OldHistoryIndex = NewHistoryIndex - 1;
	OldUnitState = XComGameState_Unit(Metadata.StateObject_OldState);
	NewUnitState = XComGameState_Unit(Metadata.StateObject_NewState);

	OldLootableObjectState = Lootable(History.GetGameStateForObjectID(LootableObjectID, , OldHistoryIndex));
	NewLootableObjectState = Lootable(History.GetGameStateForObjectID(LootableObjectID, , NewHistoryIndex));

	if( OldLootableObjectState != None )
	{
		kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		LootItemRefs = OldLootableObjectState.GetAvailableLoot();
		UnobtainedLootItemRefs = NewLootableObjectState.GetAvailableLoot();

		while( LootItemRefs.Length > 0 )
		{
			LootObjectID = LootItemRefs[LootItemRefs.Length - 1].ObjectID;
			LootVisActor = History.GetVisualizer(LootObjectID);
			if( LootVisActor != None && UnobtainedLootItemRefs.Find('ObjectID', LootObjectID) == INDEX_NONE )
			{
				LootVisActors.AddItem(LootVisActor);
				LootVisActorsObjectIDs.AddItem(LootObjectID);

				ItemState = XComGameState_Item(History.GetGameStateForObjectID(LootObjectID, , OldHistoryIndex));
				kTag.StrValue0 = ItemState.GetMyTemplate().GetItemFriendlyName();
				LootVisActorItemPickupStrings.AddItem(`XEXPAND.ExpandString(Presentation.m_strTimedLoot));

				// have to clear the visualizer from the map, since it is about to be destroyed
				History.SetVisualizer(LootObjectID, None);
			}
			LootItemRefs.Remove(LootItemRefs.Length - 1, 1);
		}
	}
}

function bool IsTimedOut()
{
	return false;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	function BeginSlurp()
	{
		local XComGameStateHistory History;
		local ParticleSystemComponent FXComponent;
		local X2ItemTemplate ItemTemplate;
		local XComGameState_Item LootItemState;
		local XComTacticalController TacticalController;
		local XGUnit ActiveUnit;
		local XComGameState_Unit SelectedUnit;
		local float ParameterValue;
		local Vector VectorValue;

		History = `XCOMHISTORY;

		if( LootVisActors.Length > 0 )
		{
			LootStartTimeSeconds = WorldInfo.TimeSeconds;
			LootStartLoc = LootVisActors[0].Location;
			if( LootVisActors[0] != None )
			{
				LootVisActors[0].SetPhysics(PHYS_Interpolating);

				LootItemState = XComGameState_Item(History.GetGameStateForObjectID(LootVisActorsObjectIDs[0]));
				ItemTemplate = LootItemState.GetMyTemplate();
				if( ItemTemplate.LootParticleSystemEnding != None )
				{
					foreach LootVisActors[0].AllOwnedComponents(class'ParticleSystemComponent', FXComponent)
					{
						// Jwats: Swap the particles for the ending particle system
						LootVisActors[0].DetachComponent(FXComponent);
						FXComponent = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(ItemTemplate.LootParticleSystemEnding, LootVisActors[0].Location, LootVisActors[0].Rotation, LootVisActors[0]);
						LootVisActors[0].AttachComponent(FXComponent);

						TacticalController = XComTacticalController(`XWORLDINFO.GetALocalPlayerController());
						ActiveUnit = TacticalController.GetActiveUnit();
						SelectedUnit = XComGameState_Unit(History.GetGameStateForObjectID(ActiveUnit.ObjectID));
						if( SelectedUnit != None )
						{
							ParameterValue = SelectedUnit.GetSoldierClassTemplateName() == 'Templar' ? 1.0f : 0.0f;
							VectorValue.X = ParameterValue;
							VectorValue.Y = ParameterValue;
							VectorValue.Z = ParameterValue;
							FXComponent.SetVectorParameter('Templar', VectorValue);
							FXComponent.SetFloatParameter('Templar', ParameterValue);
						}
						break;
					}
				}
			}
		}
	}

	function UpdateSlurp()
	{
		local float TimeSinceStart;
		local float Alpha;
		local Vector TargetLocation;

		TimeSinceStart = WorldInfo.TimeSeconds - LootStartTimeSeconds;

		if( TimeSinceStart >= LootSlurpTime )
		{
			`PRES.Notify(LootVisActorItemPickupStrings[0]);
			LootVisActors[0].Destroy();
			LootVisActors.Remove(0, 1);
			LootVisActorsObjectIDs.Remove(0, 1);
			LootVisActorItemPickupStrings.Remove(0, 1);
			BeginSlurp();
		}
		else
		{
			Alpha = (TimeSinceStart * TimeSinceStart) / (LootSlurpTime * LootSlurpTime);
			UnitPawn.Mesh.GetSocketWorldLocationAndRotation(LootReceptionSocket, TargetLocation);
			LootVisActors[0].SetLocation(VLerp(LootStartLoc, TargetLocation, Alpha));
		}
	}

Begin:
	// highlight loot sparkles for the old state
	OldLootableObjectState.UpdateLootSparklesEnabled(true);

	// Start looting anim
	if( OldLootableObjectState.HasNonPsiLoot() )
	{
		Params.AnimName = 'HL_LootBodyStart';
		Params.PlayRate = GetNonCriticalAnimationSpeed();
		if( UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName) )
		{
		PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
		if( Metadata.VisualizeActor.CustomTimeDilation < 1.0 )
		{
			Sleep(PlayingSequence.AnimSeq.SequenceLength * PlayingSequence.Rate * Metadata.VisualizeActor.CustomTimeDilation);
		}
		else
		{
			FinishAnim(PlayingSequence);
		}
		}


		// Loop while the UI is displayed
		Params.AnimName = 'HL_LootLoop';
		Params.Looping = true;
		if( UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName) )
		{
		UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
		}

		// show the UI, and wait for it to finish before playing the slurp
		`PRES.UIInventoryTactical(NewUnitState, OldLootableObjectState, OnUIInventoryTacticalClosed);
		while( !bLootingComplete )
		{
			Sleep(0.1f);
		}
	}
	// clear loot sparkles based on the new state
	NewLootableObjectState.UpdateLootSparklesEnabled(false);

	BeginSlurp();
	while( LootVisActors.Length > 0 )
	{
		UpdateSlurp();
		Sleep(0.001f);
	}

	if( OldLootableObjectState.HasNonPsiLoot() )
	{
		Params.AnimName = 'HL_LootStop';
		Params.Looping = false;
		Params.PlayRate = GetNonCriticalAnimationSpeed();
		if( UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName) )
		{
		PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
		if( Metadata.VisualizeActor.CustomTimeDilation < 1.0 )
		{
			Sleep(PlayingSequence.AnimSeq.SequenceLength * PlayingSequence.Rate * Metadata.VisualizeActor.CustomTimeDilation);
		}
		else
		{
			FinishAnim(PlayingSequence);
		}
		}
		
		Unit.UnitSpeak('LootCaptured');
	}

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}

simulated function OnUIInventoryTacticalClosed()
{
	bLootingComplete = true;
}

defaultproperties
{
	LootReceptionSocket = "L_Hand"
	LootSlurpTime = 0.25
	LootStartTimeSeconds = -1.0
}

