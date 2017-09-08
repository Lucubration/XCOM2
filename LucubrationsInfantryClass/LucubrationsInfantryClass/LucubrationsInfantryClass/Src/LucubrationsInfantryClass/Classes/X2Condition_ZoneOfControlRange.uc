class X2Condition_ZoneOfControlRange extends X2Condition;

var int ReactionFireRadius;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
	return 'AA_Success';
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local int TargetDistanceInTiles;
	local XComGameState_Unit Source, Target;

	Source = XComGameState_Unit(kSource);
	Target = XComGameState_Unit(kTarget);
	
	// Check range from shooter to target. Radius in config is given in tiles
	TargetDistanceInTiles = Source.TileDistanceBetween(Target);
	if (TargetDistanceInTiles > ReactionFireRadius)
	{
		//`LOG("Lucubration Infantry Class: Zone of Control target " @ Target.GetFullName() @ " out of range of " @ Source.GetFullName() @ " (" @ string(TargetDistanceInTiles) @ " > " @ string(ReactionFireRadius) @ ").");

		return 'AA_NotInRange';
	}

	//`LOG("Lucubration Infantry Class: Zone of Control target " @ Target.GetFullName() @ " in range of " @ Source.GetFullName() @ ".");

	return 'AA_Success';
}