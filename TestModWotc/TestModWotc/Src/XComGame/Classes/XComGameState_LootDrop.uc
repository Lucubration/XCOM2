//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LootDrop.uc
//  AUTHOR:  Dan Kaplan  --  10/20/2015
//  PURPOSE: This object represents the instance data for a loot drop in the tactical game for
//           X-Com
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComGameState_LootDrop extends XComGameState_BaseObject 
	implements(Lootable, X2VisualizedInterface)
	native(Core);

var() array<StateObjectReference> LootableItemRefs;
var() TTile TileLocation;
var() string LastLootOwnerName;
var() int LootSourceID;

// The number of turns before this LootDrop's carried loot expires
const MaxLootExpirationTurns = 3;
var() int LootExpirationTurnsRemaining;								//Number of turns remaining until the loot on this LootDrop will be destroyed (if > -1)

//////////////////////////////////////////////////////////////////
// Construction

static function CreateLootDrop(XComGameState NewGameState, const out array<XComGameState_Item> LootItems, Lootable LootSource, bool bExpireLoot)
{
	local XComGameState_LootDrop LootDrop;
	local XComGameState_Item ItemState;
	local X2EventManager EventManager;
	local Object ThisObj;

	if( LootItems.Length > 0 )
	{
		LootDrop = XComGameState_LootDrop(NewGameState.CreateNewStateObject(class'XComGameState_LootDrop'));

		ThisObj = LootDrop;
		EventManager = `XEVENTMGR;
		EventManager.RegisterForEvent(ThisObj, 'PlayerTurnBegun', OnPlayerTurnBegun, ELD_OnStateSubmitted);
		EventManager.RegisterForEvent(ThisObj, 'LootDropCreated', OnLootDropCreated, ELD_OnStateSubmitted);
		EventManager.TriggerEvent('LootDropCreated', ThisObj, ThisObj, NewGameState);

		LootDrop.LootExpirationTurnsRemaining = MaxLootExpirationTurns;

		if( !bExpireLoot )
		{
			++LootDrop.LootExpirationTurnsRemaining;
		}

		LootDrop.TileLocation = LootSource.GetLootLocation();
		LootDrop.LastLootOwnerName = LootSource.GetLootingName();
		LootDrop.LootSourceID = XComGameState_BaseObject(LootSource).ObjectID;

		foreach LootItems(ItemState)
		{
			LootDrop.LootableItemRefs.AddItem(ItemState.GetReference());
		}

		if( `CHEATMGR == None || !`CHEATMGR.bDisableLootFountain )
		{
			NewGameState.GetContext().PostBuildVisualizationFn.AddItem(LootDrop.VisualizeLootFountain);
		}
	}
}

function CheckIfEmptyAndRemoveEvents()
{
	local Object SelfObject;

	if( HasLoot() == false )
	{
		SelfObject = self;
		`XEVENTMGR.UnRegisterFromAllEvents(SelfObject);
	}
}

//////////////////////////////////////////////////////////////////
// X2VisualizedInterface Interface

function Actor FindOrCreateVisualizer(optional XComGameState Gamestate = none)
{
	local XComLootDropActor MyVisualizer;
	local XComGameStateHistory History;
	local Vector WorldLocation;
	local XComTacticalController TacticalController;
	local XGUnit ActiveUnit;
	local XComGameState_Unit SelectedUnit;

	History = `XCOMHISTORY;

	MyVisualizer = XComLootDropActor(History.GetVisualizer(ObjectID));
	
	if( MyVisualizer == None )
	{
		WorldLocation = `XWORLD.GetPositionFromTileCoordinates(TileLocation);
		MyVisualizer = `XCOMGAME.Spawn(class'XComLootDropActor', , , WorldLocation);
		MyVisualizer.SetObjectID(ObjectID);
		`XCOMVISUALIZATIONMGR.RegisterObserver(MyVisualizer);
		History.SetVisualizer(ObjectID, MyVisualizer);

		MyVisualizer.InitMaterials();

		TacticalController = XComTacticalController(`XWORLDINFO.GetALocalPlayerController());
		ActiveUnit = TacticalController.GetActiveUnit();
		SelectedUnit = XComGameState_Unit(History.GetGameStateForObjectID(ActiveUnit.ObjectID));
		if( SelectedUnit != None )
		{
			MyVisualizer.UpdateLootMarkersForSelectedUnit(SelectedUnit);
		}
	}

	return MyVisualizer;
}

function SyncVisualizer(optional XComGameState GameState = none)
{
}

function AppendAdditionalSyncActions(out VisualizationActionMetadata ActionMetadata, const XComGameStateContext Context)
{
	local X2Action_LootDropMarker LootDropMarker;

	if( HasLoot() )
	{
		class'X2Action_LootFountain'.static.AddToVisualizationTree(ActionMetadata, GetParentGameState().GetContext());

		LootDropMarker = X2Action_LootDropMarker(class'X2Action_LootDropMarker'.static.AddToVisualizationTree(ActionMetadata, GetParentGameState().GetContext()));
		LootDropMarker.LootDropObjectID = ObjectID;
		LootDropMarker.LootExpirationTurnsRemaining = LootExpirationTurnsRemaining;
		LootDropMarker.LootLocation = GetLootLocation();
		LootDropMarker.SetVisible = (LootExpirationTurnsRemaining > 0 && HasAvailableLoot());
	}
}

//////////////////////////////////////////////////////////////////
// Lootable Interface

simulated event bool HasLoot()
{
	return LootableItemRefs.Length > 0;
}

simulated event bool HasAvailableLoot()
{
	return HasLoot();
}

function bool HasAvailableLootForLooter(StateObjectReference LooterRef)
{
	return class'Helpers'.static.HasAvailableLootInternal(self, LooterRef);
}

function Lootable MakeAvailableLoot(XComGameState ModifyGameState);

function array<StateObjectReference> GetAvailableLoot()
{
	return LootableItemRefs;
}

function AddLoot(StateObjectReference ItemRef, XComGameState ModifyGameState)
{
	local XComGameState_LootDrop NewLootDropState;

	NewLootDropState = XComGameState_LootDrop(ModifyGameState.ModifyStateObject(class'XComGameState_LootDrop', ObjectID));

	NewLootDropState.LootableItemRefs.AddItem(ItemRef);
}

function RemoveLoot(StateObjectReference ItemRef, XComGameState ModifyGameState)
{
	local XComGameState_LootDrop NewLootDropState;

	NewLootDropState = XComGameState_LootDrop(ModifyGameState.ModifyStateObject(class'XComGameState_LootDrop', ObjectID));

	NewLootDropState.LootableItemRefs.RemoveItem(ItemRef);
	NewLootDropState.CheckIfEmptyAndRemoveEvents();
}


function string GetLootingName()
{
	local XComGameState_BaseObject SourceObjectState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	SourceObjectState = History.GetGameStateForObjectID(LootSourceID);
	if( SourceObjectState != None )
	{
		return Lootable(SourceObjectState).GetLootingName();
	}

	return LastLootOwnerName;
}

simulated function TTile GetLootLocation()
{
	return TileLocation;
}

function VisualizeLootFountain(XComGameState VisualizeGameState)
{
	class'Helpers'.static.VisualizeLootFountainInternal(self, VisualizeGameState);
	BuildVisualizationForLootTicked(VisualizeGameState);
}

function VisualizeLootFountainMove(XComGameState VisualizeGameState)
{
	BuildVisualizationForLootTicked( VisualizeGameState );
}

function bool GetLoot(StateObjectReference ItemRef, StateObjectReference LooterRef, XComGameState ModifyGameState)
{
	ModifyGameState.GetContext().PostBuildVisualizationFn.AddItem(BuildVisualizationForLootTicked);
	return class'Helpers'.static.GetLootInternal(self, ItemRef, LooterRef, ModifyGameState);
}

function bool LeaveLoot(StateObjectReference ItemRef, StateObjectReference LooterRef, XComGameState ModifyGameState)
{
	return class'Helpers'.static.LeaveLootInternal(self, ItemRef, LooterRef, ModifyGameState);
}

function UpdateLootSparklesEnabled(bool bHighlightObject);


function EventListenerReturn OnLootDropCreated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_LootDrop LootDropState;
	local StateObjectReference AbilityRef;
	local XComGameStateContext_Ability NewAbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit Iter;
	local XComWorldData WorldData;
	local vector SourcePos, TargetPos;
	local float LootCheckDistanceSq;
	local XComGameStateHistory History;

	// search for nearby looters who should immediately loot
	WorldData = `XWORLD;
	History = `XCOMHISTORY;
	TargetPos = WorldData.GetPositionFromTileCoordinates(TileLocation);

	LootDropState = XComGameState_LootDrop(EventData);
	if( LootDropState.HasLoot() )
	{
		foreach History.IterateByClassType(class'XComGameState_Unit', Iter)
		{
			if( Iter.IsAbleToAct() )
			{
				AbilityRef.ObjectID = -1;
				AbilityRef = Iter.FindAbility('Loot');
				if( AbilityRef.ObjectID > 0 )
				{
					// check if a friendly unit is within loot range and able to act
					SourcePos = WorldData.GetPositionFromTileCoordinates(Iter.TileLocation);
					LootCheckDistanceSq = VSizeSq(TargetPos - SourcePos);
					if( LootCheckDistanceSq < Square(class'X2Ability_DefaultAbilitySet'.default.LOOT_RANGE) )
					{
						AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));

						if( AbilityState != None )
						{
							NewAbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, LootDropState.ObjectID);
							if( NewAbilityContext.Validate() )
							{
								`XCOMGAME.GameRuleset.SubmitGameStateContext(NewAbilityContext);
							}
						}

						break;
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn OnPlayerTurnBegun(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_LootDrop NewLootDropState;
	local X2TacticalGameRuleset Ruleset;

	if( XComGameState_Player(EventSource).GetTeam() == eTeam_XCom )
	{
		// check if this is an AI that needs to update loot expiration timer
		if( HasAvailableLoot() && LootExpirationTurnsRemaining > 0 )
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Timed Loot Timer");
			NewLootDropState = XComGameState_LootDrop(NewGameState.ModifyStateObject(class'XComGameState_LootDrop', ObjectID));
			--NewLootDropState.LootExpirationTurnsRemaining;
			if( NewLootDropState.LootExpirationTurnsRemaining <= 0 )
			{
				// time expired, clear the remaining loot
				NewLootDropState.LootableItemRefs.Remove(0, NewLootDropState.LootableItemRefs.Length);
				NewLootDropState.CheckIfEmptyAndRemoveEvents();

				// Use special visualization effect for this loot clear
				XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = BuildVisualizationForLootExpired;
			}
			else
			{
				XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = BuildVisualizationForLootTicked;
			}

			Ruleset = X2TacticalGameRuleset(`XCOMGAME.GameRuleset);
			Ruleset.SubmitGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}

function BuildVisualizationForLootTicked(XComGameState VisualizeGameState)
{
	local VisualizationActionMetadata ActionMetadata;
	local XComGameStateHistory History;
	local XComGameState_LootDrop LootDropState;
	local X2Action_LootDropMarker LootDropMarker;

	History = `XCOMHISTORY;
	History.GetCurrentAndPreviousGameStatesForObjectID(ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, eReturnType_Reference, VisualizeGameState.HistoryIndex);
	LootDropState = XComGameState_LootDrop(ActionMetadata.StateObject_NewState);

	ActionMetadata.VisualizeActor = LootDropState.GetVisualizer();

	LootDropMarker = X2Action_LootDropMarker(class'X2Action_LootDropMarker'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	LootDropMarker.LootDropObjectID = ObjectID;
	LootDropMarker.LootExpirationTurnsRemaining = LootDropState.LootExpirationTurnsRemaining;
	LootDropMarker.LootLocation = LootDropState.GetLootLocation();
	LootDropMarker.SetVisible = (LootDropState.LootExpirationTurnsRemaining > 0 && HasAvailableLoot());

	}


function BuildVisualizationForLootExpired(XComGameState VisualizeGameState)
{
	local VisualizationActionMetadata ActionMetadata, EmptyTrack;
	local XComGameStateHistory History;
	local XComGameState_LootDrop LootDropState, OldLootDropState;
	local X2Action_PlayEffect LootExpiredEffectAction;
	local X2Action_Delay DelayAction;
	local XComContentManager ContentManager;
	local TTile EffectLocationTile;
	local XComWorldData World;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local X2Action_LootDropMarker LootDropMarker;
	local string Display;
	local array<StateObjectReference> LootItemRefs;
	local StateObjectReference LootItemRef;	
	local XComGameStateContext VisualizeStateContext;
	local X2Action_CameraLookAt CameraLookAt;
	local X2Action_StartStopSound SoundAction;

	VisualizeStateContext = VisualizeGameState.GetContext();
	World = `XWORLD;
	ContentManager = `CONTENT;
	History = `XCOMHISTORY;

	// Add a Track for the loot drop
	History.GetCurrentAndPreviousGameStatesForObjectID(ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, eReturnType_Reference, VisualizeGameState.HistoryIndex);
	LootDropState = XComGameState_LootDrop(ActionMetadata.StateObject_NewState);

	if( !OldLootDropState.HasPsiLoot() )
	{
		Display = class'XLocalizedData'.default.LootExpiredMsg;
	}
	else
	{
		Display = class'XLocalizedData'.default.PsiLootExpiredMsg;
	}

	OldLootDropState = XComGameState_LootDrop(ActionMetadata.StateObject_OldState);
	LootItemRefs = OldLootDropState.GetAvailableLoot();
	

	ActionMetadata.VisualizeActor = LootDropState.GetVisualizer();

	CameraLookAt = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, VisualizeStateContext));
	CameraLookAt.LookAtObject = ActionMetadata.StateObject_NewState;
	//CameraLookAt.LookAtDuration = Delay;
	CameraLookAt.BlockUntilActorOnScreen = true;
	CameraLookAt.UseTether = false;
	CameraLookAt.DesiredCameraPriority = eCameraPriority_GameActions; // increased camera priority so it doesn't get stomped

	LootDropMarker = X2Action_LootDropMarker(class'X2Action_LootDropMarker'.static.AddToVisualizationTree(ActionMetadata, VisualizeStateContext));
	LootDropMarker.LootDropObjectID = ObjectID;
	LootDropMarker.LootExpirationTurnsRemaining = LootDropState.LootExpirationTurnsRemaining;
	LootDropMarker.LootLocation = LootDropState.GetLootLocation();
	LootDropMarker.SetVisible = false;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeStateContext));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(SoundCue'SoundFX.ElectricalSparkCue', Display, '', eColor_Bad, , 0, false, eTeam_XCom);

	if( !OldLootDropState.HasPsiLoot() )
	{
		LootExpiredEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeStateContext));
		EffectLocationTile = LootDropState.GetLootLocation();
		LootExpiredEffectAction.EffectLocation = World.GetPositionFromTileCoordinates(EffectLocationTile);
		LootExpiredEffectAction.EffectName = ContentManager.LootExpiredEffectPathName;
		LootExpiredEffectAction.bStopEffect = false;
	}
	else
	{
		SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(ActionMetadata, VisualizeStateContext));
		SoundAction.Sound = new class'SoundCue';
		SoundAction.Sound.AkEventOverride = AkEvent'XPACK_SoundCharacterFX.Stop_Templar_Channel_Loot_Loop';
		SoundAction.iAssociatedGameStateObjectId = LootDropState.ObjectID;
		SoundAction.bIsPositional = true;
		SoundAction.vWorldPosition = History.GetVisualizer(LootDropState.ObjectID).Location;
		SoundAction.bStopPersistentSound = true;
	}

	class'X2Action_LootDestruction'.static.AddToVisualizationTree(ActionMetadata, VisualizeStateContext);

	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, VisualizeStateContext));
	DelayAction.Duration = 1.5;

	
	// add a track for each loot item
	foreach LootItemRefs(LootItemRef)
	{
		ActionMetadata = EmptyTrack;
		History.GetCurrentAndPreviousGameStatesForObjectID(LootItemRef.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, eReturnType_Reference, VisualizeGameState.HistoryIndex);
		ActionMetadata.VisualizeActor = History.GetVisualizer(LootItemRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeStateContext);

		LootExpiredEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeStateContext));
		LootExpiredEffectAction.EffectLocation = ActionMetadata.VisualizeActor.Location;
		LootExpiredEffectAction.EffectName = ContentManager.LootItemExpiredEffectPathName;
		LootExpiredEffectAction.bStopEffect = false;

			}
}

simulated function bool HasPsiLoot()
{
	local XComGameStateHistory History;
	local XComGameState_Item ItemState;
	local int i;

	History = `XCOMHISTORY;
	for (i = 0; i < LootableItemRefs.Length; ++i)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(LootableItemRefs[i].ObjectID));
		if (ItemState != none && X2FocusLootItemTemplate(ItemState.GetMyTemplate()) != none)
			return true;
	}
	return false;
}

simulated function bool HasNonPsiLoot()
{
	local XComGameStateHistory History;
	local XComGameState_Item ItemState;
	local int i;

	History = `XCOMHISTORY;
	for (i = 0; i < LootableItemRefs.Length; ++i)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(LootableItemRefs[i].ObjectID));
		if (ItemState != none && X2FocusLootItemTemplate(ItemState.GetMyTemplate()) == none)
			return true;
	}
	return false;
}

//////////////////////////////////////////////////////////////////
// DefProps

DefaultProperties
{
	bTacticalTransient=true
}
