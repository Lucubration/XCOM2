class X2AbilityMultiTarget_ClaymoreRadius extends X2AbilityMultiTarget_Radius
	native(Core);

var private{private} float m_fCachedRadius;

var int ClaymoreEnvironmentalDamage;

simulated native protected function GetTilesToCheckForLocation(const XComGameState_Ability Ability,
															   const out vector Location,
															   out vector TileExtent, // maximum extent of the returned tiles from Location
															   out array<TilePosPair> CheckTiles);

simulated native function float GetTargetRadius(const XComGameState_Ability Ability);
simulated native protected function bool ActorBlocksRadialDamage(Actor CheckActor, const out vector Location, int EnvironmentDamage);

defaultproperties
{
	// this is the default value here: class'XComDestructibleActor_Action_RadialDamage'.default.EnvironmentalDamage
	// but Unreal won't let me put that as the rvalue of the assignment in the default properties.
	ClaymoreEnvironmentalDamage=10
}