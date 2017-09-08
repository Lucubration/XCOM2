//-----------------------------------------------------------
//  FILE:    SeqAct_CallChosenReinforcements.uc
//  AUTHOR:  James Brawley  --  1/30/2017
//  PURPOSE: Preconfigured reinforcements call node to bring in the chosen
//			 Created for use in Lost and Abandoned, as the schedule has no advent units to trigger the chosen
// 
//-----------------------------------------------------------

class SeqAct_CallChosenReinforcements extends SequenceAction
	dependson(XComAISpawnManager);

// If bUseOverrideTargetLocation is true, this value overrides the target location for the next reinforcement group to spawn.
var() Vector OverrideTargetLocation;
var() bool bUseOverrideTargetLocation;
var() bool bForceScamper;

// When spawning using the OverrideTargatLocation, offset the spawner by this amount of tiles.
var() int IdealSpawnTilesOffset;

// The Name of the Reinforcement Encounter (defined in DefaultMissions.ini) that will be called in
var() Name EncounterID;

// The named modifier on Chosen reveals.  None = normal behavior; 'ChosenSpecialNoReveal' = just frame the scamper; 'ChosenSpecialTopDownReveal' = Quick top down reveal + scamper
var() Name ChosenRevealVisualizationType;

event Activated()
{
	class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(
		EncounterID, 
		0, 
		bUseOverrideTargetLocation, 
		OverrideTargetLocation, 
		IdealSpawnTilesOffset, 
		, 
		true, 
		ChosenRevealVisualizationType,
		false, 
		false,
		true,
		true,
		true,
		true);
}

defaultproperties
{
	ObjCategory="Chosen"
	ObjName="Chosen - Call Reinforcements"
	bConvertedForReplaySystem=true

	bForceScamper=false
}