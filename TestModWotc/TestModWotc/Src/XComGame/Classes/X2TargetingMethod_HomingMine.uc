class X2TargetingMethod_HomingMine extends X2TargetingMethod_TopDown;

function GetTargetLocations(out array<Vector> TargetLocations)
{
	local XGUnit TargetUnit;
	local StateObjectReference ShooterRef;

	TargetLocations.Length = 0;
	TargetUnit = XGUnit(GetTargetedActor());
	if( TargetUnit != None )
	{
		ShooterRef.ObjectID = FiringUnit.ObjectID;
		TargetLocations.AddItem(TargetUnit.GetShootAtLocation(eHit_Success, ShooterRef));
	}
	else
	{
		TargetLocations.AddItem(GetTargetedActor().Location);
	}
}

DefaultProperties
{
	ProjectileTimingStyle = "Timing_Grenade"
	OrdnanceTypeName = "Ordnance_Grenade"
}