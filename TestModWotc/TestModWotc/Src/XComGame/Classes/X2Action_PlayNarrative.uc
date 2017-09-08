//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_PlayNarrative extends X2Action;


var XComNarrativeMoment Moment;
var bool WaitForCompletion;
var private bool WaitingForCompletion;
var bool StopExistingNarrative;
var delegate<NarrativeCompleteDelegate> NarrativeCompleteFn;
var bool bCallbackCalled;
var bool bEndOfMissionNarrative; //Permanently fade the camera to black, hide the UI. Use for end of mission narratives
var bool bSkipNarrative;
var array<string> RequiredMatineeNames; // If set, the animation will only play if the matinee matches this name

delegate NarrativeCompleteDelegate();



simulated private function OnFinishedNarrative();

event bool BlocksAbilityActivation()
{
	local XComGameState InitialGameState;
	local XComGameStateContext_Ability AbilityContext;

	InitialGameState = StateChangeContext.GetFirstStateInEventChain();
	AbilityContext = XComGameStateContext_Ability(InitialGameState.GetContext());

	//If this narrative was triggered by movement of the player, then block
	if (AbilityContext != none && 
		AbilityContext.InputContext.MovementPaths.Length > 1 &&
		AbilityContext.bVisualizationOrderIndependent)
	{
		return true;
	}

	return false;
}

function Init()
{
	super.Init();

	bSkipNarrative = !IsRequiredMatineePlaying();
}

function bool IsRequiredMatineePlaying()
{
	local X2Action ParentAction;
	local X2Action_RevealAIBegin RevealAction;

	if (RequiredMatineeNames.Length > 0)
	{
		foreach ParentActions(ParentAction)
		{
			RevealAction = X2Action_RevealAIBegin(ParentAction);
			if (RevealAction == none || RevealAction.Matinees.Length == 0 || RequiredMatineeNames.Find(RevealAction.Matinees[0].ObjComment) == INDEX_NONE)
			{
				return false;
			}
		}
	}

	return true;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	simulated private function OnFinishedNarrative()
	{
		if (NarrativeCompleteFn != none)
		{
			NarrativeCompleteFn();
			bCallbackCalled = true;
		}

		WaitingForCompletion = false;
	}

Begin:

	if (!bSkipNarrative)
	{
		// Waiting for Completion must be set if we have a Narrative Completion delegate
		if (NarrativeCompleteFn != none)
		{
			WaitForCompletion = true;
		}

		if (Moment == none)
		{
			OnFinishedNarrative();
		}
		else
		{
			WaitingForCompletion = WaitForCompletion;

			if (bEndOfMissionNarrative)
			{
				`PRES.HUDHide();
				class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0, 0, 0), vect2d(0, 1), 0.0);
			}

			if (StopExistingNarrative)
			{
				`PRES.m_kNarrativeUIMgr.ClearConversationQueueOfNonTentpoles();
			}

			`PRESBASE.UINarrative(Moment, , OnFinishedNarrative);

			while (WaitingForCompletion)
			{
				Sleep(0.1);
			}
		}
	}

	CompleteAction();
}

function CompleteAction()
{
	if (NarrativeCompleteFn != none && !bCallbackCalled)
	{
		// Must have timed out before callback was called, so call it now
		NarrativeCompleteFn();
		bCallbackCalled = true;
	}

	super.CompleteAction();
}

function bool IsTimedOut()
{
	if(Moment != none && Moment.eType == eNarrMoment_UIOnly)
	{
		return false;
	}

	return super.IsTimedOut();
}

defaultproperties
{
	TimeoutSeconds = 30.0f
}

