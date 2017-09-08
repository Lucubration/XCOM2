class PA_XGStrategy extends XGStrategy config(GameData);

state StartingFromTactical
{
	function bool ShowDropshipInterior()
	{	
		local XComGameState_HeadquartersXCom XComHQ;
		local XComGameState_MissionSite MissionState;		
		local bool bSkyrangerTravel;

		XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		if(XComHQ != none)
		{
			MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
		}

		//True if we didn't seamless travel here, and the mission type wanted a skyranger travel ( ie. no avenger defense or other special mission type )
		bSkyrangerTravel = MissionState.GetMissionSource().CustomLoadingMovieName_Outro == "" && 
						   !`XCOMGAME.m_bSeamlessTraveled && 
						   (MissionState == None || MissionState.GetMissionSource().bRequiresSkyrangerTravel);

		return bSkyrangerTravel;
	}

	function SetHQMusicFlag()
	{
		local XComGameState_HeadquartersXCom XComHQ;
		local XComGameState_MissionSite MissionState;
		local bool bLoadingMovieOnReturn;

		XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		if(XComHQ != none)
		{
			MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
		}

		bLoadingMovieOnReturn = !MissionState.GetMissionSource().bRequiresSkyrangerTravel || !class'XComMapManager'.default.bUseSeamlessTravelToStrategy || MissionState.GetMissionSource().CustomLoadingMovieName_Outro != "";

		`XSTRATEGYSOUNDMGR.bSkipPlayHQMusicAfterTactical = !bLoadingMovieOnReturn;
	}

Begin:
	//This is only true if the game is NOT using seamless travel and instead just puts the player into a streamed in drop ship while the rest of the levels stream in around them
	if(ShowDropshipInterior()) 
	{
		//DropshipLocation.Z -= 2000.0f; //Locate the drop ship below the map
		`MAPS.AddStreamingMap("CIN_Loading_Interior", DropshipLocation, DropshipRotation, false);// .bForceNoDupe = true;
		while(!`MAPS.IsStreamingComplete())
		{
			sleep(0.0f);
		}

		`HQPRES.UIStopMovie();

		XComPlayerController(`HQPRES.Owner).NotifyStartTacticalSeamlessLoad();
		class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().ClientSetCameraFade(false);
	}	
	else
	{
		class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0, 0, 0), vect2d(0, 1), 0.0);
	}

	`STRATEGYRULES.GameTime = GetGameTime();
	
	//Have the event manager check for errors
	`XEVENTMGR.ValidateEventManager("while entering strategy! This WILL result in buggy behavior during game play continued with this save.");

	class'PA_StrategyGameRule'.static.CompleteStrategyFromTacticalTransfer();

	m_kGeoscape.Init();

	while(!GetGeoscape().m_kBase.MinimumAvengerStreamedInAndVisible())
	{
		Sleep(0);
	}

	while(`HQPRES.IsBusy())
	{
		Sleep(0);
	}

	GetGeoscape().m_kBase.StreamInBaseRooms(false);

	while(!GetGeoscape().m_kBase.MinimumAvengerStreamedInAndVisible())
	{
		Sleep(0);
	}

	if(ShowDropshipInterior())
	{
		WorldInfo.bContinueToSeamlessTravelDestination = false;
		XComPlayerController(`HQPRES.Owner).NotifyLoadedDestinationMap('');
		while(!WorldInfo.bContinueToSeamlessTravelDestination)
		{
			Sleep(0.0f);
		}

		class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0, 0, 0), vect2d(0, 1), 0.0);
		Sleep(0.1f);

		`MAPS.RemoveStreamingMapByName("CIN_Loading_Interior", false);
	}
	else
	{
		while(class'XComEngine'.static.IsAnyMoviePlaying() && !class'XComEngine'.static.IsLoadingMoviePlaying())
		{
			Sleep(0.0f);
		}
	}

	WorldInfo.MyLocalEnvMapManager.SetEnableCaptures(true);

	Sleep(1.0f); //We don't want to populate the base rooms while capturing the environment, as it is very demanding on the games resources

	GetGeoscape().m_kBase.m_kCrewMgr.PopulateBaseRoomsWithCrew();

	GetGeoscape().m_kBase.SetAvengerVisibility(true);

	SetHQMusicFlag();

	while (!`MAPS.IsStreamingComplete())
	{
		sleep(0.0f);
	}
	class'XComEngine'.static.SetSeamlessTraveled(false); // Turn off seamless travel once all of the maps are loaded

	GoToHQ();
}
