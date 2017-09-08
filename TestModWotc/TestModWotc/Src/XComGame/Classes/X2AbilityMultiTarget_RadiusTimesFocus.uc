class X2AbilityMultiTarget_RadiusTimesFocus extends X2AbilityMultiTarget_Radius
	dependson(XComWorldData)
	native(Core);

simulated native function float GetTargetRadius(const XComGameState_Ability Ability);
simulated native function GetMultiTargetsForLocation(const XComGameState_Ability Ability, const vector Location, out AvailableTarget Target);