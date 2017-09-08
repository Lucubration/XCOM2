//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_LootDropMarker extends X2Action;

//*************************************
var int	LootDropObjectID;
var bool SetVisible;
var int LootExpirationTurnsRemaining;
var TTile LootLocation;

//*************************************

static function X2Action AddToVisualizationTree(out VisualizationActionMetadata ActionMetadata, XComGameStateContext Context,
												optional bool ReparentChildren = false,
												optional X2Action Parent,
												optional array<X2Action> AdditionalParents)
{
	local XComLootDropActor LootDropActor;
	local XComGameState_LootDrop LootDropState;
	local X2Action_StartStopSound SoundAction;
	local XComGameStateVisualizationMgr VisMgr;

	VisMgr = `XCOMVISUALIZATIONMGR;

	LootDropState = XComGameState_LootDrop(ActionMetadata.StateObject_NewState);
	LootDropActor = XComLootDropActor(ActionMetadata.VisualizeActor);

	Parent = super.AddToVisualizationTree(ActionMetadata, Context, ReparentChildren, Parent, AdditionalParents);

	if( LootDropState.HasPsiLoot() )
	{
		SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(ActionMetadata, Context, false, Parent));
		if( !SoundAction.DoesSoundEmitterAlreadyExistForObjectId(LootDropState.ObjectID) )
		{
			SoundAction.Sound = new class'SoundCue';
			SoundAction.Sound.AkEventOverride = AkEvent'XPACK_SoundCharacterFX.Templar_Channel_Loot_Loop';
			SoundAction.iAssociatedGameStateObjectId = LootDropState.ObjectID;
			SoundAction.bIsPositional = true;
			SoundAction.vWorldPosition = LootDropActor.Location;
			SoundAction.bStartPersistentSound = true;
		}
		else
		{
			VisMgr.DestroyAction(SoundAction);
		}
	}

	return Parent;
}

function Init()
{
	Super.Init( );
}

function bool IsTimedOut()
{
	return false;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	function UpdateLootDrop()
	{
		local XComLootDropActor LootDropActor;
		local XComGameState_LootDrop LootDropState;

		LootDropState = XComGameState_LootDrop(Metadata.StateObject_NewState);
		LootDropActor = XComLootDropActor(Metadata.VisualizeActor);

		LootDropActor.SetLootMarker(SetVisible, LootExpirationTurnsRemaining, LootLocation, LootDropState.HasPsiLoot());
	}

Begin:
	UpdateLootDrop();

	CompleteAction();
}

defaultproperties
{
	SetVisible=true
	LootExpirationTurnsRemaining=-1
}

