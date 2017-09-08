class X2AbilityMultiTarget_Cone extends X2AbilityMultiTarget_Radius native(Core);

struct native AbilityGrantedBonusCone
{
	var name RequiredAbility;
	var float fBonusDiameter;
	var float fBonusLength;
};

var() float ConeEndDiameter;
var() float ConeLength;
var() bool bUseWeaponRangeForLength;
var() array<AbilityGrantedBonusCone> AbilityBonusCones;
var() bool bLockShooterZ;	//	cone will only return tiles on the same Z as the shooter

function AddBonusConeSize(name AbilityName, float BonusDiameter, float BonusLength)
{
	local AbilityGrantedBonusCone BonusCone;

	BonusCone.RequiredAbility = AbilityName;
	BonusCone.fBonusDiameter = BonusDiameter;
	BonusCone.fBonusLength = BonusLength;
	AbilityBonusCones.AddItem(BonusCone);
}

native function float GetConeLength(const XComGameState_Ability Ability);
native function float GetConeEndDiameter(const XComGameState_Ability Ability);
simulated native function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles);
// GetTilesProxy - Get tiles in area given the source being in a different location from where he is now.
// This function does not check for collisions like the main function above does.
simulated native function GetTilesProxy(const XComGameState_Ability Ability, const vector TargetLocation, const vector SourceLocation, out array<TTile> ValidTiles);
//Return the Valid Uncollided tiles into ValidTiles and everything else into InValidTiles
simulated native function GetCollisionValidTilesForLocation( const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles, out array<TTile> InValidTiles);

// Returns distance in Units this Ability can reach from the source location.  -1 if unlimited range.
simulated native function float GetHitRange(const XComGameState_Ability Ability);