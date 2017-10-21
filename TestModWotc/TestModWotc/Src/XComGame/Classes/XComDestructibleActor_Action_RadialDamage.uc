class XComDestructibleActor_Action_RadialDamage extends XComDestructibleActor_Action
	dependson (X2Effect_World)
	native(Destruction);

var(XComDestructibleActor_Action) float DamageTileRadius;
var(XComDestructibleActor_Action) float EnvironmentalDamage;
var(XComDestructibleActor_Action) float UnitDamage;
var(XComDestructibleActor_Action) float ArmorShred;
var(XComDestructibleActor_Action) name DamageTypeName<DynamicList = "DamageTypeList">;
var(XComDestructibleActor_Action) float Momentum;
var(XComDestructibleActor_Action) bool AffectFragileOnly;
var(XComDestructibleActor_Action) class<X2Effect_World> TileEffect;
var(XComDestructibleActor_Action) float EffectCoverage;
var(XComDestructibleActor_Action) int LostActivationSoundIncrease;

var array<StateObjectReference> CachedUnits;

cpptext
{
public:
	virtual void GetDynamicListValues(const FString& ListName, TArray<FString>& Values);
}


native function GetBlastExtents(out TTile Min, out TTile Max);
native function NativePreActivateResponse();
native function GetUnitsInBlastRadius(out array<XComGameState_Unit> Units);

event PreActivate()
{
	local array<XComGameState_Unit> Units;
	local XComGameState_Unit It;

	super.PreActivate();

	GetUnitsInBlastRadius( Units );

	foreach Units(It)
	{
		CachedUnits.AddItem( It.GetReference() );
	}
}

event PreActivateResponse( )
{
	super.PreActivateResponse();

	NativePreActivateResponse();
}

defaultproperties
{
	DamageTileRadius = 1;
	EnvironmentalDamage = 10;
	UnitDamage = 0;
	DamageTypeName = "Explosion"
	Momentum = 3000.0f;
	AffectFragileOnly = false;
	TileEffect = none;
	EffectCoverage = 50;
	ArmorShred=1;
	LostActivationSoundIncrease=30
}
