class SeqAct_CallReinforcements extends SequenceAction
	dependson(XComAISpawnManager);

// If >1, this value overrides the number of AI turns until reinforcements are spawned.
var() int OverrideCountdown;

// If bUseOverrideTargetLocation is true, this value overrides the target location for the next reinforcement group to spawn.
var() Vector OverrideTargetLocation;
var() bool bUseOverrideTargetLocation;

// When spawning using the OverrideTargatLocation, offset the spawner by this amount of tiles.
var() int IdealSpawnTilesOffset;

// The Name of the Reinforcement Encounter (defined in DefaultMissions.ini) that will be called in
var() Name EncounterID;

// The name of the visualization type to use when this group spawns.  Currently valid types: 'ATT', 'PsiGate', '' (no visualization)
var() Name VisualizationType;

// If true, reinforcements should not spawn within XCom's LOS
var() bool bDontSpawnInXComLOS;

// If true, reinforcements must spawn within XCom's LOS
var() bool bMustSpawnInXComLOS;

// If true, reinforcements won't land in hazard tiles
var() bool bDontSpawnInHazards;

// If true, reinforcements will always alert and scamper
var() bool bForceScamper;

// If true, this reinforcement group will always orient strongly towards the line of play
var() bool bAlwaysOrientAlongLOP;

event Activated()
{
	class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(
		EncounterID, 
		OverrideCountdown, 
		bUseOverrideTargetLocation, 
		OverrideTargetLocation, 
		IdealSpawnTilesOffset, 
		, 
		true, 
		VisualizationType, 
		bDontSpawnInXComLOS, 
		bMustSpawnInXComLOS,
		bDontSpawnInHazards,
		bForceScamper,
		bAlwaysOrientAlongLOP);
}

defaultproperties
{
	ObjCategory="Gameplay"
	ObjName="Call Reinforcements"
	bConvertedForReplaySystem=true
	VisualizationType="ATT"
	bDontSpawnInXComLOS=true
	bDontSpawnInHazards=true
	bForceScamper=true
}