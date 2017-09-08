// Call reinforcements using standard lost parameters (skip visualizations, etc.)

class SeqAct_CallLostReinforcements extends SequenceAction
	dependson(XComAISpawnManager);

// If >0, this value overrides the number of AI turns until reinforcements are spawned.
var() int OverrideCountdown;

// If bUseOverrideTargetLocation is true, this value overrides the target location for the next reinforcement group to spawn.
var() Vector OverrideTargetLocation;
var() bool bUseOverrideTargetLocation;

// When spawning using the OverrideTargatLocation, offset the spawner by this amount of tiles.
var() int IdealSpawnTilesOffset;

// The Name of the Reinforcement Encounter (defined in DefaultMissions.ini) that will be called in
var() Name EncounterID;

event Activated()
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	if(bUseOverrideTargetLocation)
	{
		class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(EncounterID, OverrideCountdown, bUseOverrideTargetLocation, OverrideTargetLocation, IdealSpawnTilesOffset, , true, 'TheLostSwarm', true, false, true, true, true);
	}
	else
	{
		class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(EncounterID, OverrideCountdown, , , BattleData.LostSpawningDistance, , true, 'TheLostSwarm', true, false, true, true, true);
	}		
}

defaultproperties
{
	ObjCategory="Gameplay"
	ObjName="Call Lost Reinforcements"
	bConvertedForReplaySystem=true
	OverrideCountdown=-1
}