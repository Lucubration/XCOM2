class AnimNotify_WithPlayLimits extends AnimNotify
	native(Anim)
	abstract;

struct native NotifyLimitsEnemies
{
	var() bool PlayForAlienOnly;
	var() bool PlayForAdventOnly;
	var() bool PlayForCyberusOnly;
	var() bool PlayForAndromedonOnly;
	var() bool PlayForPsiWitchOnly;
	var() bool PlayForChosenAssassinM1Only;
	var() bool PlayForChosenAssassinM2Only;
	var() bool PlayForChosenAssassinM3Only;
	var() bool PlayForChosenAssassinM4Only;
	var() bool PlayForSpectreM2Only;

	structdefaultproperties
	{
		PlayForAlienOnly = false;
		PlayForAdventOnly = false;
		PlayForCyberusOnly = false;
		PlayForAndromedonOnly = false;
		PlayForPsiWitchOnly = false;
		PlayForChosenAssassinM1Only = false;
		PlayForChosenAssassinM2Only = false;
		PlayForChosenAssassinM3Only = false;
		PlayForChosenAssassinM4Only = false;
		PlayForSpectreM2Only = false;
	}

	structcpptext
	{
		FNotifyLimitsEnemies()
		{
			PlayForAlienOnly = false;
			PlayForAdventOnly = false;
			PlayForCyberusOnly = false;
			PlayForAndromedonOnly = false;
			PlayForPsiWitchOnly = false;
			PlayForChosenAssassinM1Only = false;
			PlayForChosenAssassinM2Only = false;
			PlayForChosenAssassinM3Only = false;
			PlayForChosenAssassinM4Only = false;
			PlayForSpectreM2Only = false;
		}
		FNotifyLimitsEnemies(EEventParm)
		{
			appMemzero(this, sizeof(FNotifyLimitsEnemies));
		}
	}
};

struct native NotifyLimitsSoldierClass
{
	var() bool PlayForRangerOnly;
	var() bool PlayForSharpshooterOnly;
	var() bool PlayForGrenadierOnly;
	var() bool PlayForSpecialistOnly;
	var() bool PlayForPsiOperativeOnly;

	structdefaultproperties
	{
		PlayForRangerOnly = false;
		PlayForSharpshooterOnly = false;
		PlayForGrenadierOnly = false;
		PlayForSpecialistOnly = false;
		PlayForPsiOperativeOnly = false;
	}

	structcpptext
	{
		FNotifyLimitsSoldierClass()
		{
			PlayForRangerOnly = false;
			PlayForSharpshooterOnly = false;
			PlayForGrenadierOnly = false;
			PlayForSpecialistOnly = false;
			PlayForPsiOperativeOnly = false;
		}
		FNotifyLimitsSoldierClass(EEventParm)
		{
			appMemzero(this, sizeof(FNotifyLimitsSoldierClass));
		}
	}
};

struct native NotifyLimits
{
	var() bool RequirementsAreForAttackTarget<ToolTip="These 'play for' limits are tested using the attacked actor (useful for weapon attack fx)">;
	var() bool PlayForHumanOnly;
	var() bool PlayForXcomOnly;
	var() bool PlayForRobotOnly;
	var() NotifyLimitsEnemies Enemies;
	var() NotifyLimitsSoldierClass SoldierClass;

	structdefaultproperties
	{
		RequirementsAreForAttackTarget = false;
		PlayForHumanOnly = false;
		PlayForXcomOnly = false;
		PlayForRobotOnly = false;
	}

	structcpptext
	{
		FNotifyLimits()
		{
			RequirementsAreForAttackTarget = false;
			PlayForHumanOnly = false;
			PlayForXcomOnly = false;
			PlayForRobotOnly = false;
		}
		FNotifyLimits(EEventParm)
		{
			appMemzero(this, sizeof(FNotifyLimits));
		}
	}
};

var() NotifyLimits Limits;

native function bool HasAnyPlayLimits();