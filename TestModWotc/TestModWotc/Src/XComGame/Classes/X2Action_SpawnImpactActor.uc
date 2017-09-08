//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------

class X2Action_SpawnImpactActor extends X2Action;


// The path name of the impact actor archetype to be spawned.
var string ImpactActorName;

var vector ImpactLocation;
var vector ImpactNormal;

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	simulated private function SpawnActor( )
	{
		local XComProjectileImpactActor ImpactArchetype, Impact;

		ImpactArchetype = XComProjectileImpactActor( DynamicLoadObject( ImpactActorName, class'XComProjectileImpactActor' ) );

		Impact = Spawn( class'XComProjectileImpactActor', self, ,
			ImpactLocation, Rotator(ImpactNormal),	ImpactArchetype, true );

		if (Impact != none)
		{
			Trace( Impact.HitLocation, Impact.HitNormal, ImpactLocation - vect(0, 0, 5), ImpactLocation + vect(0, 0, 5), true,
				vect( 0, 0, 0 ), Impact.TraceInfo );

			Impact.TraceLocation = Impact.HitLocation; 
			Impact.TraceNormal = Impact.HitNormal;
			Impact.Init( );
		}
	}

Begin:
	SpawnActor( );

	CompleteAction();
}

defaultproperties
{
	ImpactActorName="Impact_GameData.Impacts_Explosions_Sm"
}