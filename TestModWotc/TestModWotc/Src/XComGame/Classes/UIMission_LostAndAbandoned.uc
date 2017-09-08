
class UIMission_LostAndAbandoned extends UIMission;

var public localized string m_strLostAndAbandonedMission;
var public localized string m_strImageGreeble;

//----------------------------------------------------------------------------
// MEMBERS

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	FindMission('MissionSource_LostAndAbandoned');

	BuildScreen();
}

simulated function Name GetLibraryID()
{
	return 'XPACK_Alert_MissionBlades';
}

simulated function BuildScreen()
{
	local XComGameState NewGameState;
	local XComGameState_ResistanceFaction FactionState;

	// Add Interception warning and Shadow Chamber info 
	super.BuildScreen();

	FactionState = GetMission().GetResistanceFaction();
	PlaySFX((FactionState != None) ? FactionState.GetFanfareEvent() : "Geoscape_NewResistOpsMissions");

	XComHQPresentationLayer(Movie.Pres).CAMSaveCurrentLocation();

	if (bInstantInterp)
	{
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM, 0);
	}
	else
	{
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM);
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: View Lost and Abandoned");
	`XEVENTMGR.TriggerEvent('OnViewLostAndAbandoned', , , NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

simulated function BuildMissionPanel()
{
	local XComGameState_ResistanceFaction FactionState;

	FactionState = GetMission().GetResistanceFaction();

	LibraryPanel.MC.BeginFunctionOp("UpdateMissionInfoBlade");
	LibraryPanel.MC.QueueString(m_strImageGreeble);
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(FactionState.GetFactionTitle());
	LibraryPanel.MC.QueueString(FactionState.GetFactionName());
	LibraryPanel.MC.QueueString(FactionState.GetLeaderImage());
	LibraryPanel.MC.QueueString(GetOpName());
	LibraryPanel.MC.QueueString(m_strMissionObjective);
	LibraryPanel.MC.QueueString(GetObjectiveString());
	LibraryPanel.MC.QueueString(m_strReward);
	LibraryPanel.MC.EndOp();

	LibraryPanel.MC.BeginFunctionOp("UpdateMissionReward");
	LibraryPanel.MC.QueueNumber(0);
	LibraryPanel.MC.QueueString(GetRewardString());
	LibraryPanel.MC.QueueString(""); // Rank Icon
	LibraryPanel.MC.QueueString(""); // Class Icon
	LibraryPanel.MC.EndOp();

	UpdateRewards();

	SetFactionIcon(FactionState.GetFactionIcon());

	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.Hide();
	Button3.Hide();
	ConfirmButton.Hide();
}

//bsg-jneal (5.11.17): override BindLibraryItem for controller adjustments
simulated function BindLibraryItem()
{
	super.BindLibraryItem();
	
	if( `ISCONTROLLERACTIVE )
	{
		Button1.SetStyle(eUIButtonStyle_HOTLINK_WHEN_SANS_MOUSE,,true);
		Button1.SetX(-75 - Button1.Width / 2.0);
	}
}
//bsg-jneal (5.11.17): end

function UpdateRewards()
{
	local XComGameState_MissionSite Mission;
	local XComGameState_Reward RewardState;
	local XComGameStateHistory History;
	local int idx, iSlot;

	History = `XCOMHISTORY;
	iSlot = 0;
	Mission = GetMission();

	for( idx = 0; idx < Mission.Rewards.Length; idx++ )
	{
		RewardState = XComGameState_Reward(History.GetGameStateForObjectID(Mission.Rewards[idx].ObjectID));

		if( RewardState != none )
		{
			UpdateMissionReward(iSlot, RewardState.GetRewardString(), RewardState.GetRewardIcon());
			iSlot++;
		}
	}
}

function UpdateMissionReward(int numIndex, string strLabel, string strRank, optional string strClass)
{
	LibraryPanel.MC.BeginFunctionOp("UpdateMissionReward");
	LibraryPanel.MC.QueueNumber(numIndex);
	LibraryPanel.MC.QueueString(strLabel);
	LibraryPanel.MC.QueueString(strRank); //optional
	LibraryPanel.MC.QueueString(strClass); //optional
	LibraryPanel.MC.EndOp();
}

simulated function BuildOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateMissionButtonBlade");
	LibraryPanel.MC.QueueString(m_strLostAndAbandonedMission);
	LibraryPanel.MC.QueueString(m_strLaunchMission);
	LibraryPanel.MC.QueueString(m_strIgnore);
	LibraryPanel.MC.EndOp();
}

function SetFactionIcon(StackedUIIconData factionIcon)
{
	local int i;
	LibraryPanel.MC.BeginFunctionOp("SetFactionIcon");

	LibraryPanel.MC.QueueBoolean(factionIcon.bInvert);
	for (i = 0; i < factionIcon.Images.Length; i++)
	{
		LibraryPanel.MC.QueueString("img:///" $ factionIcon.Images[i]);
	}
	LibraryPanel.MC.EndOp();
}

simulated function OnButtonSizeRealized()
{
	//Override - do nothing
}

//-------------- EVENT HANDLING --------------------------------------------------------

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function EUIState GetLabelColor()
{
	return eUIState_Normal;
}

//==============================================================================

defaultproperties
{
	Package = "/ package/gfxXPACK_Alerts/XPACK_Alerts";
	InputState = eInputState_Consume;
}