class SeqEvent_GameEventTriggered extends SeqEvent_X2GameState 
	native
	abstract;

var XComGameState_Unit RelevantUnit;
var XComGameState_Player RelevantPlayer;
var name EventID;

event RegisterEvent()
{
	local Object ThisObj;

	if (EventID != '')
	{
		ThisObj = self;
		`XEVENTMGR.RegisterForEvent(ThisObj, EventID, EventTriggered, ELD_OnStateSubmitted);
	}
}

function EventListenerReturn EventTriggered(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	RelevantUnit = none;
	RelevantPlayer = none;

	if (EventData.IsA('XComGameState_Unit'))
	{
		RelevantUnit = XComGameState_Unit(EventData);
	}
	else if (EventData.IsA('XComGameState_Ability'))
	{
		RelevantUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(XComGameState_Ability(EventData).OwnerStateObject.ObjectID))	;
	}
	else if(EventData.IsA('XComGameState_Player'))
	{
		RelevantPlayer = XComGameState_Player(EventData);
	}
	else
	{
		`RedScreen("SeqEvent_GameEventTriggered event" @ EventID @ "has EventData" @ EventData @ "that is not handled. Kismet cannot possibly do anything useful here.");
	}
	
	if (RelevantUnit != none)
		CheckActivate(RelevantUnit.GetVisualizer(), none);

	if (RelevantPlayer != none)
		CheckActivate(RelevantPlayer.GetVisualizer(), none);
	
	return ELR_NoInterrupt;
}

DefaultProperties
{
	ObjCategory="Gameplay"
	ObjName="Game Event Triggered"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=RelevantUnit,bWriteable=TRUE)
}