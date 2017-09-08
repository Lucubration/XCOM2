class X2Condition_BattleState extends X2Condition;

var() bool bMissionAborted;
var() bool bMissionNotAborted;
var() bool bCiviliansTargetedByAliens;
var() bool bCiviliansNotTargetedByAliens;
var() bool bIncludeTheLostInEngagedCount;
var() int MinEngagedEnemies;
var() int MaxEngagedEnemies;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
	local XComGameState_BattleData BattleData;
	local StateObjectReference EngagedEnemyRef;
	local int NumEngagedEnemies;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (BattleData == none)
		return 'AA_UnknownError';

	if (bMissionAborted && !BattleData.bMissionAborted)
		return 'AA_AbilityUnavailable';

	if (bMissionNotAborted && BattleData.bMissionAborted)
		return 'AA_AbilityUnavailable';

	if( bCiviliansTargetedByAliens && !BattleData.AreCiviliansAlienTargets() )
		return 'AA_AbilityUnavailable';

	if( bCiviliansNotTargetedByAliens && BattleData.AreCiviliansAlienTargets() )
		return 'AA_AbilityUnavailable';

	NumEngagedEnemies = class'XComGameState_AIPlayerData'.static.GetNumEngagedEnemies(EngagedEnemyRef, bIncludeTheLostInEngagedCount);

	if( (MinEngagedEnemies >= 0 && NumEngagedEnemies < MinEngagedEnemies) ||
		(MaxEngagedEnemies >= 0 && NumEngagedEnemies > MaxEngagedEnemies) )
	{
		return 'AA_AbilityUnavailable';
	}

	return 'AA_Success';
}

defaultproperties
{
	MinEngagedEnemies=-1
	MaxEngagedEnemies=-1
}