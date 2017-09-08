class X2Effect_CombatStims extends X2Effect_BonusArmor config(GameCore);

var config int ARMOR_CHANCE, ARMOR_MITIGATION;
var private array<name> DamageTypeImmunities;

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	if( DamageTypeImmunities.Find(DamageType) != INDEX_NONE )
	{
		return true;
	}
	return false;
}

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return default.ARMOR_CHANCE; }
function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return default.ARMOR_MITIGATION; }

DefaultProperties
{
	EffectName="CombatStims"
	DuplicateResponse=eDupe_Refresh
	DamageTypeImmunities(0)="Mental"
	DamageTypeImmunities(1)="Disorient"
	DamageTypeImmunities(2)="stun"
	DamageTypeImmunities(3)="Unconscious"
	DamageTypeImmunities(4)="psi"
}