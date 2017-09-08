class X2BombTemplate_Beags_Escalation extends X2WeaponTemplate
	config(Beags_Escalation_Item);

var array<X2Effect> PlantedBombEffects;
var bool bFriendlyFire, bFriendlyFireWarning;
var float fAngle;

var localized string PlantedAbilityName;
var localized string PlantedAbilityHelpText;

var name OnPlantBarkSoundCue;

DefaultProperties
{
	WeaponCat="beags_escalation_bomb"
	ItemCat="beags_escalation_bomb"
	InventorySlot=eInvSlot_Utility
	StowedLocation=eSlot_BeltHolster
	bMergeAmmo=true
	bSoundOriginatesFromOwnerLocation=false
	bFriendlyFire=true
	bFriendlyFireWarning=true
}