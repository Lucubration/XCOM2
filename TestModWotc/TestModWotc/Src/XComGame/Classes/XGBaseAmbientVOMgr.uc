class XGBaseAmbientVOMgr extends Actor 
	config(GameCore);

struct TimedMusingInfo
{
	var float InitialDelay;          // in seconds
	var float TimeBetween;           // in seconds
	var array<XComNarrativeMoment> Narratives;
	var bool OncePerSpeakerPerMission;		// Only play moments from this group once per speaker per every mission XCOM completes
};

struct NeedsAttentionInfo
{
	var float InitialDelay;          // in seconds
	var float TimeBetween;           // in seconds
	var array<StateObjectReference> NeedsAttention;
};

struct EventMusingInfo
{
	var float TimeBetween;           // in seconds
	var float LastEvent;
	var array<XComNarrativeMoment> Narratives;
};

var private config TimedMusingInfo CentralMusings;
var private config TimedMusingInfo ChosenMusings;
var private config TimedMusingInfo RadioMusings;
var private config TimedMusingInfo RadioLongMusings;
var private config NeedsAttentionInfo NeedsAttentionCallouts;
var private config EventMusingInfo TyganMusings;
var private config EventMusingInfo ShenMusings;
var private float NextCentralAmbientTime;                        // time in world seconds when next event should happen. this is used to block general ambient VO from playing too close to tygan/shen VO
var private float NextRadioAmbientTime;					// Keep a separate tracker for the Radio DJ
var private float NextChosenAmbientTime;				// Keep a separate tracker for Chosen VO

var private bool CentralAmbientActive;
var private bool RadioAmbientActive;
var private bool ChosenAmbientActive;
var private bool NeedsAttentionActive;

var private bool bPlayedRadio;
var private bool bPlayedChosen;

var private XComHQPresentationLayer HQPresLayer;
var private X2AmbientNarrativeCriteriaTemplateManager AmbientCriteriaMgr;
var private X2DynamicNarrativeTemplateManager AmbientConditionMgr;
var private XComNarrativeMoment ActiveMusing;
var private XComNarrativeMoment ChosenActiveMusing;

function Init()
{
	local XComHeadquartersCamera HQCamera;
	HQCamera = XComHeadquartersCamera(XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).PlayerController.PlayerCamera);

	AmbientCriteriaMgr = class'X2AmbientNarrativeCriteriaTemplateManager'.static.GetAmbientNarrativeCriteriaTemplateManager();
	AmbientConditionMgr = class'X2DynamicNarrativeTemplateManager'.static.GetDynamicNarrativeTemplateManager();

	HQPresLayer = `HQPRES;
	CentralAmbientActive = false;
	RadioAmbientActive = false;
	ChosenAmbientActive = false;

	HQCamera.EnteringAvengerView = EnableAvengerAmbientVO;
	HQCamera.EnteringArmoryView = EnableAvengerAmbientVO;
	HQCamera.EnteringBarView = EnableRadioBarVO;
	HQCamera.EnteringPhotoboothView = EnableRadioPhotoboothVO;
	HQCamera.EnteringGeoscapeView = DisableAllAmbientVO;
	HQCamera.EnteringFacilityView = DisableAllMusingAmbientVO;

	BuildAmbientNarrativeList();

	TyganMusings.LastEvent = WorldInfo.TimeSeconds - TyganMusings.TimeBetween;
	ShenMusings.LastEvent = WorldInfo.TimeSeconds - ShenMusings.TimeBetween;

	NextCentralAmbientTime = 0;
	NextRadioAmbientTime = 0;
	NextChosenAmbientTime = 0;
}

private function BuildAmbientNarrativeList()
{
	local XComNarrativeMoment Moment;

	foreach HQPresLayer.m_kNarrative.m_arrNarrativeMoments(Moment)
	{
		if ((Moment.AmbientCriteriaTypeName != '' || Moment.AmbientConditionTypeNames.Length > 0) && Moment.arrConversations.Length > 0)
		{
			switch (Moment.AmbientSpeaker)
			{
			case 'HeadScientist':
				TyganMusings.Narratives.AddItem(Moment);
				break;
			case 'HeadEngineer':
				ShenMusings.Narratives.AddItem(Moment);
				break;
			case 'ResistanceDJ':
			case 'Singer':
				RadioMusings.Narratives.AddItem(Moment);
				RadioLongMusings.Narratives.AddItem(Moment);
				break;
			case 'ChosenAssassin':
			case 'ChosenSniper':
			case 'ChosenWarlock':
				ChosenMusings.Narratives.AddItem(Moment);
				break;
			default:
				CentralMusings.Narratives.AddItem(Moment);
				break;
			}			
		}
	}
}

private function EnableAvengerAmbientVO()
{
	EnableNeedsAttentionVO();

	if (!CentralAmbientActive)
	{
		CentralAmbientActive = true;
		SetTimerForNextAmbientEvent(NextCentralAmbientTime, CentralMusings, nameof(OnCentralAmbientVOCheck));
	}

	DisableRadioMusingAmbientVO(); // Turn off the Radio
	DisableChosenAmbientVO();
}

private function EnableRadioBarVO()
{
	if (!RadioAmbientActive)
	{
		RadioAmbientActive = true;
		SetTimerForNextAmbientEvent(NextRadioAmbientTime, RadioMusings, nameof(OnRadioAmbientVOCheck));
	}
}

private function EnableRadioPhotoboothVO()
{
	if (!RadioAmbientActive)
	{
		RadioAmbientActive = true;
		SetTimerForNextAmbientEvent(NextRadioAmbientTime, RadioLongMusings, nameof(OnRadioLongAmbientVOCheck));
	}

	DisableCentralMusingAmbientVO();
	DisableNeedsAttentionVO();
}

function EnableNeedsAttentionVO()
{
	if(!NeedsAttentionActive)
	{
		NeedsAttentionActive = true;
		if(NeedsAttentionCallouts.NeedsAttention.Length > 0)
		{
			SetTimer(NeedsAttentionCallouts.InitialDelay, true, nameof(OnNeedsAttentionVO));
		}
	}
}

private function DisableAllAmbientVO()
{
	// If there is a musing playing, stop it when entering the Geoscape
	if (ActiveMusing != none)
	{
		HQPresLayer.m_kNarrativeUIMgr.StopNarrative(ActiveMusing);
		ActiveMusing = none;
	}
	
	DisableNeedsAttentionVO();
	DisableAllMusingAmbientVO();
	EnableChosenAmbientVO();
}

private function DisableAllMusingAmbientVO()
{
	DisableCentralMusingAmbientVO();
	DisableRadioMusingAmbientVO();
	DisableChosenAmbientVO(); // Safety check
}

private function DisableCentralMusingAmbientVO()
{
	if (CentralAmbientActive)
	{
		CentralAmbientActive = false;
		ClearTimer(nameof(OnCentralAmbientVOCheck));
	}
}

private function DisableRadioMusingAmbientVO()
{
	if (RadioAmbientActive)
	{
		RadioAmbientActive = false;
		ClearTimer(nameof(OnRadioAmbientVOCheck));
		ClearTimer(nameof(OnRadioLongAmbientVOCheck));
	}
}

private function DisableNeedsAttentionVO()
{
	if (NeedsAttentionActive)
	{
		NeedsAttentionActive = false;
		ClearTimer(nameof(OnNeedsAttentionVO));
	}
}

private function OnCentralAmbientVOCheck()
{
	PlayAmbientNarrative(NextCentralAmbientTime, CentralMusings, nameof(OnCentralAmbientVOCheck));
}

private function OnRadioAmbientVOCheck()
{
	PlayAmbientNarrative(NextRadioAmbientTime, RadioMusings, nameof(OnRadioAmbientVOCheck));
}

private function OnRadioLongAmbientVOCheck()
{
	PlayAmbientNarrative(NextRadioAmbientTime, RadioLongMusings, nameof(OnRadioLongAmbientVOCheck));
}

private function UpdateNeedsAttentionFromStates()
{
	local XComGameState_FacilityXCom FacilityState;
	local StateObjectReference FacilityRef;
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	foreach XComHQ.Facilities(FacilityRef)
	{
		if (FacilityRef.ObjectID != 0)
		{
			FacilityState = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(FacilityRef.ObjectID));
			if (FacilityState.NeedsAttention())
			{
				TriggerNeedAttentionVO(FacilityRef, false);
			}
			else
			{
				if ((NeedsAttentionCallouts.NeedsAttention.Find('ObjectID', FacilityRef.ObjectID) != INDEX_NONE))
				{
					// newly NOT in need of attention
					ClearNeedAttentionVO(FacilityRef);
				}
			}
		}
	}
}

private function bool PlayAppropriateNeedsAttentionVO()
{
	local XComNarrativeMoment AttentionNarrative;
	local XComGameState_FacilityXCom FacilityState;
	local StateObjectReference FacilityRef;
	local UIScreen TopScreen;
	local UIFacility FacilityScreen;
	
	TopScreen = HQPresLayer.ScreenStack.GetCurrentScreen();
	FacilityScreen = UIFacility(TopScreen);

	if (!HQPresLayer.m_kNarrativeUIMgr.bPaused &&
		!HQPresLayer.m_kNarrativeUIMgr.AnyActiveConversations())
	{
		if (FacilityScreen != none || UIFacilityGrid(TopScreen) != none)
		{
			foreach NeedsAttentionCallouts.NeedsAttention(FacilityRef)
			{
				FacilityState = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(FacilityRef.ObjectID));
				AttentionNarrative = XComNarrativeMoment(`CONTENT.RequestGameArchetype(FacilityState.GetMyTemplate().NeedsAttentionNarrative));

				if (AttentionNarrative != none)
				{
					// if a non-ambient musing VO hasn't been played recently then and we aren't in the facility associated with this reminder then play the narrative
					if (WorldInfo.TimeSeconds >= HQPresLayer.m_kNarrativeUIMgr.GetLastVOTime() + NeedsAttentionCallouts.InitialDelay && 
					   (FacilityScreen == none || FacilityScreen.FacilityRef.ObjectID != FacilityRef.ObjectID))
					{
						if (AttentionNarrative.LastAmbientPlayTime == 0)
						{
							// first time playing newly added in need of attention callout
							PlayNarrativeMoment(AttentionNarrative);

							NeedsAttentionCallouts.NeedsAttention.RemoveItem(FacilityRef);
							NeedsAttentionCallouts.NeedsAttention.AddItem(FacilityRef);
							return true;
						}
						else if (WorldInfo.TimeSeconds >= (AttentionNarrative.LastAmbientPlayTime + NeedsAttentionCallouts.TimeBetween))
						{
							// repeat playing in need of attention callout NeedsAttentionCallouts.TimeBetween seconds later (give or take depending on other narrative moments playing)
							PlayNarrativeMoment(AttentionNarrative);

							NeedsAttentionCallouts.NeedsAttention.RemoveItem(FacilityRef);
							NeedsAttentionCallouts.NeedsAttention.AddItem(FacilityRef);
							return true;
						}
					}
				}
			}
		}
	}

	return false;
}

private function UpdateLastPlayedTimeForNeedsAttention()
{
	local XComNarrativeMoment AttentionNarrative;
	local XComGameState_FacilityXCom FacilityState;
	local StateObjectReference FacilityRef;
	
	foreach NeedsAttentionCallouts.NeedsAttention(FacilityRef)
	{
		FacilityState = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(FacilityRef.ObjectID));
		AttentionNarrative = XComNarrativeMoment(`CONTENT.RequestGameArchetype(FacilityState.GetMyTemplate().NeedsAttentionNarrative));

		if (AttentionNarrative != none)
		{
			AttentionNarrative.LastAmbientPlayTime = WorldInfo.TimeSeconds;
		}
	}
}

private function OnNeedsAttentionVO()
{
	UpdateNeedsAttentionFromStates();

	if (NeedsAttentionCallouts.NeedsAttention.Length == 0)
		return;



	if (!NeedsAttentionActive)
		return;

	if (PlayAppropriateNeedsAttentionVO())
	{
		UpdateLastPlayedTimeForNeedsAttention();
	}
}

function ClearNeedAttentionVO(StateObjectReference FacilityRef)
{
	NeedsAttentionCallouts.NeedsAttention.RemoveItem(FacilityRef);
}

function TriggerNeedAttentionVO(StateObjectReference FacilityRef, optional bool bImmediate)
{
	local XComNarrativeMoment AttentionNarrative;
	local XComGameState_FacilityXCom FacilityState;

	if (bImmediate)
	{
		FacilityState = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(FacilityRef.ObjectID));
		AttentionNarrative = XComNarrativeMoment(`CONTENT.RequestGameArchetype(FacilityState.GetMyTemplate().NeedsAttentionNarrative));

		if(AttentionNarrative != none)
		{
			AttentionNarrative.LastAmbientPlayTime = 0;
		}

		NeedsAttentionCallouts.NeedsAttention.RemoveItem(FacilityRef);
		NeedsAttentionCallouts.NeedsAttention.InsertItem(0, FacilityRef);
	}
	else
	{
		if (NeedsAttentionCallouts.NeedsAttention.Find('ObjectID', FacilityRef.ObjectID) == INDEX_NONE)
		{
			NeedsAttentionCallouts.NeedsAttention.AddItem(FacilityRef);
		}
	}
}

function TriggerTyganVOEvent()
{
	TriggerVOEvent(TyganMusings);
}

function TriggerShenVOEvent()
{
	TriggerVOEvent(ShenMusings);
}

private function XComNarrativeMoment ChooseNarrativeMoment(array<XComNarrativeMoment> Narratives, optional bool bLimitOncePerSpeaker)
{
	local XComNarrativeMoment Moment;
	local array<XComNarrativeMoment> BestMoments;
	local X2AmbientNarrativeCriteriaTemplate Criteria, BlockingCriteria;
	local X2DynamicNarrativeConditionTemplate Condition;
	local float CurrentBestPriority;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local int NarrativeInfoIdx;
	local name AmbientMomentName, AmbientConditionName;
	local bool bCanNarrativeBePlayed;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	if (XComHQ == none)
		return none;
	
	foreach Narratives(Moment)
	{
		if (Moment.AmbientMaxPlayCount > 0)
		{
			NarrativeInfoIdx = XComHQ.PlayedAmbientNarrativeMoments.Find('QualifiedName', PathName(Moment));
			if (NarrativeInfoIdx != -1 && XComHQ.PlayedAmbientNarrativeMoments[NarrativeInfoIdx].PlayCount >= Moment.AmbientMaxPlayCount)
				continue;
		}
		
		if (bLimitOncePerSpeaker && XComHQ.PlayedAmbientSpeakers.Find(Moment.AmbientSpeaker) != INDEX_NONE)
			continue;
		
		// Check if there is any blocking criteria, and if it has been met block the moment
		BlockingCriteria = AmbientCriteriaMgr.FindAmbientCriteriaTemplate(Moment.AmbientBlockingTypeName);
		if (BlockingCriteria != none && BlockingCriteria.IsAmbientPlayCriteriaMet(Moment))
		{
			continue; // Narrative blocked, skip to the next moment
		}
		
		bCanNarrativeBePlayed = true; // Reset flag for Criteria and Condition loops

		// Check the primary criteria, make sure that it HAS been met if one exists
		Criteria = AmbientCriteriaMgr.FindAmbientCriteriaTemplate(Moment.AmbientCriteriaTypeName);			
		if (Criteria != none)
		{
			if (Criteria.IsAmbientPlayCriteriaMet(Moment))
			{
				// Then iterate through any additional criteria and check if they are met
				foreach Moment.AdditionalAmbientCriteriaTypeNames(AmbientMomentName)
				{
					Criteria = AmbientCriteriaMgr.FindAmbientCriteriaTemplate(AmbientMomentName);
					if (Criteria == none || !Criteria.IsAmbientPlayCriteriaMet(Moment))
					{
						bCanNarrativeBePlayed = false;
						break;
					}
				}
			}
			else
			{
				continue; // Primary criteria failed, skip to the next moment
			}
		}
		

		// No need to check Conditions if the Criteria were already failed
		if (bCanNarrativeBePlayed)
		{
			// Check if there are any narrative conditions which need to be satisfied
			foreach Moment.AmbientConditionTypeNames(AmbientConditionName)
			{
				Condition = X2DynamicNarrativeConditionTemplate(AmbientConditionMgr.FindDynamicNarrativeTemplate(AmbientConditionName));
				if (Condition == None || !Condition.IsConditionMet(None, None, None))
				{
					bCanNarrativeBePlayed = false;
					break;
				}
			}
		}

		if (bCanNarrativeBePlayed)
		{
			if (Moment.AmbientPriority == CurrentBestPriority)
			{
				BestMoments.AddItem(Moment);
			}
			else if (Moment.AmbientPriority > CurrentBestPriority)
			{
				BestMoments.Length = 0;
				CurrentBestPriority = Moment.AmbientPriority;
				BestMoments.AddItem(Moment);
			}
		}
	}

	if (BestMoments.Length == 0)
		return none;

	return BestMoments[Rand(BestMoments.Length)];
}

private function UpdatePlayedAmbientNarrativeList(out XComGameState_HeadquartersXCom XComHQ, XComNarrativeMoment Moment)
{
	local int NarrativeInfoIdx;
	local string QualifiedName;
	local AmbientNarrativeInfo NarrativeInfo;

	QualifiedName = PathName(Moment);
	NarrativeInfoIdx = XComHQ.PlayedAmbientNarrativeMoments.Find('QualifiedName', QualifiedName);
	if (NarrativeInfoIdx != -1)
	{
		NarrativeInfo = XComHQ.PlayedAmbientNarrativeMoments[NarrativeInfoIdx];
		`assert(NarrativeInfo.QualifiedName == QualifiedName);
		NarrativeInfo.PlayCount++;
		XComHQ.PlayedAmbientNarrativeMoments[NarrativeInfoIdx] = NarrativeInfo;
	}
	else
	{
		NarrativeInfo.QualifiedName = QualifiedName;
		NarrativeInfo.PlayCount = 1;
		XComHQ.PlayedAmbientNarrativeMoments.AddItem(NarrativeInfo);
	}

	if (Moment.AmbientSpeaker != '' && XComHQ.PlayedAmbientSpeakers.Find(Moment.AmbientSpeaker) == INDEX_NONE)
	{
		XComHQ.PlayedAmbientSpeakers.AddItem(Moment.AmbientSpeaker);
	}
}

private function PlayNarrativeMoment(XComNarrativeMoment Moment)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameStateContext_ChangeContainer ChangeContainer;

	History = `XCOMHISTORY;
		
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Update Played VO");
	NewGameState = History.CreateNewGameState(true, ChangeContainer);
	
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
	
	`assert(XComHQ != none);

	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	HQPresLayer.UINarrative(Moment);
	ActiveMusing = Moment;

	Moment.LastAmbientPlayTime = WorldInfo.TimeSeconds;

	UpdatePlayedAmbientNarrativeList(XComHQ, Moment);

	`GAMERULES.SubmitGameState(NewGameState);
}

/***************************************/
/*        Chosen Ambient VO            */
/***************************************/
private function EnableChosenAmbientVO()
{
	// Only turn on Chosen VO if at least one is met when entering the Geoscape
	if (!ChosenAmbientActive && class'XComGameState_HeadquartersAlien'.static.HaveMetAnyChosen())
	{
		ChosenAmbientActive = true;
		SetTimerForNextAmbientEvent(NextChosenAmbientTime, ChosenMusings, nameof(OnChosenAmbientVOCheck));
	}
}

function DisableChosenAmbientVO()
{
	if (ChosenAmbientActive)
	{
		ChosenAmbientActive = false;
		ClearTimer(nameof(OnChosenAmbientVOCheck));
	}

	// If there is a Chosen musing playing, stop it when leaving the Geoscape
	if (ChosenActiveMusing != none)
	{
		HQPresLayer.m_kNarrativeUIMgr.StopNarrative(ChosenActiveMusing);
	}
}

private function OnChosenAmbientVOCheck()
{
	PlayAmbientNarrative(NextChosenAmbientTime, ChosenMusings, nameof(OnChosenAmbientVOCheck));
}

/***************************************/
/*        HELPER FUNCTIONS             */
/***************************************/

private function bool IsAmbientVOAllowed()
{
	local UIStrategyMap StrategyMap;

	if (`XPROFILESETTINGS.Data.m_bAmbientVO && !HQPresLayer.m_kNarrativeUIMgr.bPaused &&
		!class'XComGameState_HeadquartersXCom'.static.AnyTutorialObjectivesInProgress())
	{
		// Ensure there are no active conversations
		if (!HQPresLayer.m_kNarrativeUIMgr.AnyActiveConversations() && !class'SeqAct_Interp'.static.NativeIsAnyMatineePlaying())
		{
			// If the player is looking at the strategy map, check that they aren't in flight mode and no other popups are on the screen
			StrategyMap = HQPresLayer.StrategyMap2D;
			if (StrategyMap == none || StrategyMap.m_eUIState != eSMS_Flight && HQPresLayer.ScreenStack.IsCurrentClass(class'UIStrategyMap'))
			{
				return true;
			}
		}
	}

	return false;
}

private function SetTimerForNextAmbientEvent(float NextAmbientTime, TimedMusingInfo MusingInfo, name CallbackName)
{
	local float NextTime;

	// if its the first time or its been longer then the normal time between ambient VOs so restart with the initial delay
	if (NextAmbientTime == 0 || WorldInfo.TimeSeconds >= NextAmbientTime)
	{
		NextTime = MusingInfo.InitialDelay;
	}
	else
	{
		NextTime = NextAmbientTime - WorldInfo.TimeSeconds;
	}

	SetTimer(NextTime, false, CallbackName);
}

private function PlayAmbientNarrative(out float NextAmbientTime, TimedMusingInfo MusingInfo, name CallbackName)
{
	local XComNarrativeMoment Moment;

	if (IsAmbientVOAllowed()) // Ensure there are no active conversations
	{
		// if a non-ambient musing VO hasn't been played recently then pick a musing and play it, otherwise trigger a wait for the standard initial delay
		if (WorldInfo.TimeSeconds > HQPresLayer.m_kNarrativeUIMgr.GetLastVOTime() + MusingInfo.InitialDelay)
		{
			Moment = ChooseNarrativeMoment(MusingInfo.Narratives, MusingInfo.OncePerSpeakerPerMission);
			if (Moment != none)
			{
				PlayNarrativeMoment(Moment);
			}

			// Reset the timer even if a line wasn't found, since all of the activation conditions were met
			NextAmbientTime = WorldInfo.TimeSeconds + MusingInfo.TimeBetween; // Reset the time when the next line should trigger with the standard delay
		}
	}

	SetTimerForNextAmbientEvent(NextAmbientTime, MusingInfo, CallbackName);
}

function TriggerVOEvent(out EventMusingInfo MusingInfo)
{
	local XComNarrativeMoment Moment;

	if (IsAmbientVOAllowed())
	{
		if (WorldInfo.TimeSeconds - MusingInfo.LastEvent > MusingInfo.TimeBetween)
		{
			Moment = ChooseNarrativeMoment(MusingInfo.Narratives);
			if (Moment != none)
			{
				PlayNarrativeMoment(Moment);
				MusingInfo.LastEvent = WorldInfo.TimeSeconds;
			}
		}
	}
}

defaultproperties
{
	CentralAmbientActive = false
	RadioAmbientActive false;
	ChosenAmbientActive = false
	NeedsAttentionActive = false
} 