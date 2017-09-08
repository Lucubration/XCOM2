//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_InitFOW extends X2Action;

function Init()
{
	super.Init();
}

function bool CheckInterrupted()
{
	return false;
}

function InitFOW()
{
	local XComWorldData WorldData;

	WorldData = `XWORLD;

	//RAM - the interface for the world data could perhaps be simpler...

	WorldData.bEnableFOW = true; // JMS - always start out with FOW on
	WorldData.bDebugEnableFOW = true;
	WorldData.bEnableFOWUpdate = true;
	`BATTLE.m_kLevel.SetupXComFOW(true);	
	WorldData.bFOWTextureBufferIsDirty = true;// Make the FOW Texture update as sometimes the client doesn't catch that it's units have moved
	WorldData.bDisableVisibilityUpdates = false;
	WorldData.ForceUpdateAllFOWViewers( );

	// do an explict set at the end so that any gameplay modifiers to fow visibility (such as sitreps)
	// have a chance to do their thing
	`BATTLE.SetFOW(true);
}

simulated state Executing
{
Begin:
	InitFOW();

	CompleteAction();
}

DefaultProperties
{
}
