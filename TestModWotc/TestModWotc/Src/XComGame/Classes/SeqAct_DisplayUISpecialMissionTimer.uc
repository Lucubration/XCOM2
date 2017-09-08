//-----------------------------------------------------------
//Update the text forthe Special Mission countdown timer. 
//-----------------------------------------------------------
class SeqAct_DisplayUISpecialMissionTimer extends SequenceAction;

enum TimerColors
{
	Normal_Blue,
	Bad_Red,
	Good_Green,
	Disabled_Grey
};

var int     NumTurns;
var string  DisplayMsgTitle;
var string  DisplayMsgSubtitle;

var() TimerColors TimerColor;
var() bool IsTimer <Tooltip="Identify timers that should count towards the RemainingTimers stat collection.">;

event Activated()
{
	local int UIState;
	local bool ShouldShow;
	local XComGameState NewGameState;
	local XComGameState_UITimer UiTimer;

	switch(TimerColor)
	{
		case Normal_Blue:   UIState = eUIState_Normal;     break;
		case Bad_Red:       UIState = eUIState_Bad;        break;
		case Good_Green:    UIState = eUIState_Good;       break;
		case Disabled_Grey: UIState = eUIState_Disabled;   break;
	}
	ShouldShow = InputLinks[0].bHasImpulse;
	
	UiTimer = XComGameState_UITimer(`XCOMHISTORY.GetSingleGameStateObjectForClass(class 'XComGameState_UITimer', true));
	NewGameState = class 'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Objective Timer changes");
	if (UiTimer == none)
		UiTimer = XComGameState_UITimer(NewGameState.CreateNewStateObject(class 'XComGameState_UITimer'));
	else
		UiTimer = XComGameState_UITimer(NewGameState.ModifyStateObject(class 'XComGameState_UITimer', UiTimer.ObjectID));

	if (UiTimer.IsSuspended())
	{
		UiTimer.OldUiState = UIState;
	}
	else
	{
		UiTimer.UiState = UIState;
	}

	UiTimer.ShouldShow = ShouldShow;
	UiTimer.DisplayMsgTitle = DisplayMsgTitle;
	UiTimer.DisplayMsgSubtitle = DisplayMsgSubtitle;
	UiTimer.TimerValue = NumTurns;
	UiTimer.IsTimer = IsTimer;
	
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

/**
* Return the version number for this class.  Child classes should increment this method by calling Super then adding
* a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
* link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
* Super.GetObjClassVersion() should be incremented by 1.
*
* @return	the version number for this specific class.
*/
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="UI/Input"
	ObjName="Modify Mission Timer"
	bCallHandler = false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	
	InputLinks(0)=(LinkDesc="Show")
	InputLinks(1)=(LinkDesc="Hide")

	bAutoActivateOutputLinks=true
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0) = (ExpectedType=class'SeqVar_Int',LinkDesc="# Turns Remaining",PropertyName=NumTurns)
	VariableLinks(1) = (ExpectedType = class'SeqVar_String', LinkDesc = "Display Message Title", bWriteable = true, PropertyName = DisplayMsgTitle)
	VariableLinks(2) = (ExpectedType = class'SeqVar_String', LinkDesc = "Display Message Subtitle", bWriteable = true, PropertyName = DisplayMsgSubtitle)

	TimerColor = Bad_Red;
	IsTimer=true;
}
