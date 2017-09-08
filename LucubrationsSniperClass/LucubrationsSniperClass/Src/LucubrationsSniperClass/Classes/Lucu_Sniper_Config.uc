class Lucu_Sniper_Config extends Object
	config(LucubrationsSniperClass);

var config int Version;

var config int SniperTrainingAimPenalty;
var config int ZeroInAimBonus;
var config int ZeroInCritBonus;
var config float BallisticsExpertHitModRoot;
var config int PrecisionShotCooldown;
var config int PrecisionShotCritBonus;
var config array<int> PrecisionShotDamageBonus;
var config int TargetLeadingAimBonus;
var config int TargetLeadingGrazePenalty;
var config int HideCritBonus;
var config int FollowUpGrants;
var config int RelocationGrants;
var config int SabotRoundAmmo;
var config int SabotRoundCooldown;
var config int SabotRoundEnvironmentalDamage;
var config array<int> SabotRoundArmorPenetration;
var config array<int> SabotRoundDamageBonus;
var config array<int> VitalPointTargetingDamageBonus;

static function LoadUserConfig()
{
	local int UserConfigVersion, DefaultConfigVersion;

	UserConfigVersion = default.Version;
	DefaultConfigVersion = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.Version;

	// Perform any config versioning to make sure all values are stored in the user's config, even new default ones
	if (UserConfigVersion < DefaultConfigVersion)
	{
		while (UserConfigVersion < DefaultConfigVersion)
		{
			if (!UpdateUserConfigValues(UserConfigVersion))
			{
				// If the config versioning fails, return without saving over the user's config and without replacing default values for the templates
				return;
			}
		}

		// Once we've successfully performed any updates, save the user's config. The user's config should now be up-to-date with the latest version
		StaticSaveConfig();
	}

	// Replace the default values that will be used when building the templates
	LoadUserConfigValues();
}

static function LoadUserConfigValues()
{
	// This will replace the default config values in memory with any from the user's config. The new values will be used to build the templates.
	// This should always be kept up-to-date with the latest version
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SniperTrainingAimPenalty = default.SniperTrainingAimPenalty;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.ZeroInAimBonus = default.ZeroInAimBonus;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.ZeroInCritBonus = default.ZeroInCritBonus;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.BallisticsExpertHitModRoot = default.BallisticsExpertHitModRoot;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.PrecisionShotCooldown = default.PrecisionShotCooldown;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.PrecisionShotCritBonus = default.PrecisionShotCritBonus;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.PrecisionShotDamageBonus = default.PrecisionShotDamageBonus;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.TargetLeadingAimBonus = default.TargetLeadingAimBonus;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.TargetLeadingGrazePenalty = default.TargetLeadingGrazePenalty;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.HideCritBonus = default.HideCritBonus;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.FollowUpGrants = default.FollowUpGrants;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.RelocationGrants = default.RelocationGrants;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundAmmo = default.SabotRoundAmmo;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundCooldown = default.SabotRoundCooldown;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundEnvironmentalDamage = default.SabotRoundEnvironmentalDamage;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundArmorPenetration = default.SabotRoundArmorPenetration;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundEnvironmentalDamage = default.SabotRoundEnvironmentalDamage;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundDamageBonus = default.SabotRoundDamageBonus;
	class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.VitalPointTargetingDamageBonus = default.VitalPointTargetingDamageBonus;
}

static function bool UpdateUserConfigValues(out int UserConfigVersion)
{
	// Config versioning system. Each new config version should incrementally update the user config with only the new default values found in that version
	switch (UserConfigVersion)
	{
		case 0:
			default.Version = 1;
			default.SniperTrainingAimPenalty = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SniperTrainingAimPenalty;
			default.ZeroInAimBonus = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.ZeroInAimBonus;
			default.ZeroInCritBonus = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.ZeroInCritBonus;
			default.BallisticsExpertHitModRoot = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.BallisticsExpertHitModRoot;
			default.PrecisionShotCooldown = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.PrecisionShotCooldown;
			default.PrecisionShotCritBonus = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.PrecisionShotCritBonus;
			default.PrecisionShotDamageBonus = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.PrecisionShotDamageBonus;
			default.TargetLeadingAimBonus = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.TargetLeadingAimBonus;
			default.TargetLeadingGrazePenalty = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.TargetLeadingGrazePenalty;
			default.HideCritBonus = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.HideCritBonus;
			default.FollowUpGrants = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.FollowUpGrants;
			default.RelocationGrants = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.RelocationGrants;
			default.SabotRoundAmmo = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundAmmo;
			default.SabotRoundCooldown = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundCooldown;
			default.SabotRoundArmorPenetration = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundArmorPenetration;
			default.SabotRoundEnvironmentalDamage = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundEnvironmentalDamage;
			default.SabotRoundDamageBonus = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundDamageBonus;
			default.VitalPointTargetingDamageBonus = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.VitalPointTargetingDamageBonus;
			break;

		default:
			`REDSCREEN("Lucubrations Sniper Class: Unknown user config version " @ string(UserConfigVersion) @ " cannot be updated.");
			`LOG("Lucubrations Sniper Class: Unknown user config version " @ string(UserConfigVersion) @ " cannot be updated.");
			return false;
	}

	`LOG("Lucubrations Sniper Class: Updated user config version " @ string(UserConfigVersion) @ " to version " @ string(default.Version) @ ".");

	UserConfigVersion = default.Version;

	return true;
}
