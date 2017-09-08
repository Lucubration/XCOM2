class X2Condition_DarkEvent extends X2Condition;

var() bool bStilettoRounds;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if (AlienHQ == none)
		return 'AA_UnknownError';

	if (bStilettoRounds && !AlienHQ.bStilettoRounds)
		return 'AA_AbilityUnavailable';

	return 'AA_Success';
}