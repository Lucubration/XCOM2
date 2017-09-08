class X2AbilityMultiTarget_Volt extends X2AbilityMultiTargetStyle
	native(Core)
	config(GameData_SoldierSkills);

var config float DistanceBetweenTargets;		//	distance in unreal units squared

simulated native function GetMultiTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets);
simulated native function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles);