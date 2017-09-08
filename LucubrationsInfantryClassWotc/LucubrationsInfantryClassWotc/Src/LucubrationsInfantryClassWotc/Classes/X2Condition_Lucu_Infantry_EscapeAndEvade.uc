class X2Condition_Lucu_Infantry_EscapeAndEvade extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState, Enemy;
	local array<StateObjectReference> FlankingEnemies;
	local StateObjectReference EnemyRef;
	local float DetectionRadius, EnemyDistance;
	//local int EnemyDistance;
	
	History = `XCOMHISTORY;

	UnitState = XComGameState_Unit(kTarget);

	if (UnitState == none)
		return 'AA_NotAUnit';

	// Check if anyone is flanking us
	class'X2TacticalVisibilityHelpers'.static.GetFlankingEnemiesOfTarget(kTarget.ObjectID, FlankingEnemies);
	foreach FlankingEnemies(EnemyRef)
	{
		// Check each flanker's distance to us compared to their detection radius, accounting for the detection radius modifier of the Escape and Evade ability
		Enemy = XComGameState_Unit(History.GetGameStateForObjectID(EnemyRef.ObjectID));
		DetectionRadius = UnitState.GetConcealmentDetectionDistance(Enemy);
		EnemyDistance = UnitState.TileDistanceBetween(Enemy);
		
		//`LOG("Lucubration Infantry Class: Escape and Evade flanking unit detection (radius=" @ string(DetectionRadius) @ ", distance=" @ string(EnemyDistance) @ ").");

		// If the enemy is too close, we can't use Escape and Evade
		if (EnemyDistance <= DetectionRadius)
			return 'AA_UnitIsFlanked';
	}

	return 'AA_Success'; 
}