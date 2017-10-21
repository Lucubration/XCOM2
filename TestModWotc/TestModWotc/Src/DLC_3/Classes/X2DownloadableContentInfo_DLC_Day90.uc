//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_DLC_Day90.uc
//  AUTHOR:  Joe Weinhoffer
//           
//	Installs Day 90 DLC into new campaigns and loaded ones. New armors, weapons, etc
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_DLC_Day90 extends X2DownloadableContentInfo;

var config array<name> DLCTechs;
var config array<name> DLCObjectives;
var config array<name> DLCStaffSlotFacilities;

var config name DLCAlwaysStartObjective;
var config name DLCOptionalNarrativeObjective;

var config name LostTowersPOIName;
var config int LostTowersPOIForceLevel;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	InitializeManagers();
}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
	local XComGameState_SparkManager SparkMgr;

	InitializeManagers(); // Make sure manager classes are initialized

	SparkMgr = XComGameState_SparkManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_SparkManager'));

	// If the content check for this DLC has not yet been performed, ask the player whether or not it should be enabled for their campaign
	if (!SparkMgr.bContentCheckCompleted)
	{
		EnableDLCContentPopup();
	}
}

static function InitializeManagers()
{

	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_SparkManager SparkMgr;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Day 90 DLC State Objects");

	// Add Spark manager
	SparkMgr = XComGameState_SparkManager(History.GetSingleGameStateObjectForClass(class'XComGameState_SparkManager', true));
	if (SparkMgr == none) // Prevent duplicate Spark Managers
	{
		SparkMgr = XComGameState_SparkManager(NewGameState.CreateNewStateObject(class'XComGameState_SparkManager'));
	}
	
	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

static function AddNewTechGameStates(XComGameState NewGameState)
{
	local X2StrategyElementTemplateManager TechMgr;
	local X2TechTemplate TechTemplate;
	local int idx;

	TechMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	// Iterate through the DLC Techs, find their templates, and build a Tech State Object for each
	for (idx = 0; idx < default.DLCTechs.Length; idx++)
	{
		TechTemplate = X2TechTemplate(TechMgr.FindStrategyElementTemplate(default.DLCTechs[idx]));
		if (TechTemplate != none)
		{
			if (TechTemplate.RewardDeck != '')
			{
				class'XComGameState_Tech'.static.SetUpTechRewardDeck(TechTemplate);
			}

			NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
		}
	}
}

static function AddNewObjectiveGameStates(XComGameState NewGameState)
{
	local X2StrategyElementTemplateManager ObjMgr;
	local XComGameState_Objective ObjectiveState;
	local X2ObjectiveTemplate ObjectiveTemplate;
	local int idx;

	ObjMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	// Iterate through the DLC Objectives, find their templates, and build and activate the Objective State Object for each
	for (idx = 0; idx < default.DLCObjectives.Length; idx++)
	{
		ObjectiveTemplate = X2ObjectiveTemplate(ObjMgr.FindStrategyElementTemplate(default.DLCObjectives[idx]));
		if (ObjectiveTemplate != none)
		{
			ObjectiveState = ObjectiveTemplate.CreateInstanceFromTemplate(NewGameState);
		}

		// Start the main DLC objective.
		if (ObjectiveState.GetMyTemplateName() == default.DLCAlwaysStartObjective)
		{
			ObjectiveState.StartObjective(NewGameState);
		}
	}
}

static function AddNewStaffSlots(XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local X2FacilityTemplate FacilityTemplate;
	local XComGameState_StaffSlot StaffSlotState, ExistingStaffSlot, LinkedStaffSlotState;
	local X2StaffSlotTemplate StaffSlotTemplate;
	local StaffSlotDefinition SlotDef;
	local int i, j, idx;
	local bool bReplaceSlot;
	local X2StrategyElementTemplateManager StratMgr;
	local array<int> SkipIndices;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	for (idx = 0; idx < default.DLCStaffSlotFacilities.Length; idx++)
	{
		FacilityState = XComHQ.GetFacilityByName(default.DLCStaffSlotFacilities[idx]);
		if (FacilityState != none)
		{
			FacilityState = XComGameState_FacilityXCom(NewGameState.ModifyStateObject(class'XComGameState_FacilityXCom', FacilityState.ObjectID));
			FacilityTemplate = FacilityState.GetMyTemplate();

			for (i = 0; i < FacilityTemplate.StaffSlotDefs.Length; i++)
			{
				if(SkipIndices.Find(i) == INDEX_NONE)
				{
					SlotDef = FacilityTemplate.StaffSlotDefs[i];
					// Check to see if the existing staff slot at this index no longer matches the template and needs to be replaced
					bReplaceSlot = false;
					if(i < FacilityState.StaffSlots.Length && FacilityState.StaffSlots[i].ObjectID != 0)
					{
						ExistingStaffSlot = FacilityState.GetStaffSlot(i);
						if(ExistingStaffSlot.GetMyTemplateName() != SlotDef.StaffSlotTemplateName)
						{
							bReplaceSlot = true;
						}
					}

					if(i >= FacilityState.StaffSlots.Length || bReplaceSlot) // Only add a new staff slot if it doesn't already exist or needs to be replaced
					{
						StaffSlotTemplate = X2StaffSlotTemplate(StratMgr.FindStrategyElementTemplate(SlotDef.StaffSlotTemplateName));

						if(StaffSlotTemplate != none)
						{
							// Create slot state and link to this facility
							StaffSlotState = StaffSlotTemplate.CreateInstanceFromTemplate(NewGameState);
							StaffSlotState.Facility = FacilityState.GetReference();

							// Check for starting the slot locked
							if(SlotDef.bStartsLocked)
							{
								StaffSlotState.LockSlot();
							}

							if(bReplaceSlot)
							{
								FacilityState.StaffSlots[i] = StaffSlotState.GetReference();
							}
							else
							{
								FacilityState.StaffSlots.AddItem(StaffSlotState.GetReference());
							}

							// Check rest of list for partner slot
							if(SlotDef.LinkedStaffSlotTemplateName != '')
							{
								StaffSlotTemplate = X2StaffSlotTemplate(StratMgr.FindStrategyElementTemplate(SlotDef.LinkedStaffSlotTemplateName));

								if(StaffSlotTemplate != none)
								{
									for(j = (i + 1); j < FacilityTemplate.StaffSlotDefs.Length; j++)
									{
										SlotDef = FacilityTemplate.StaffSlotDefs[j];

										if(SkipIndices.Find(j) == INDEX_NONE && SlotDef.StaffSlotTemplateName == StaffSlotTemplate.DataName)
										{
											// Check to see if the existing staff slot at this index no longer matches the template and needs to be replaced
											bReplaceSlot = false;
											if(j < FacilityState.StaffSlots.Length && FacilityState.StaffSlots[j].ObjectID != 0)
											{
												ExistingStaffSlot = FacilityState.GetStaffSlot(j);
												if(ExistingStaffSlot.GetMyTemplateName() != SlotDef.StaffSlotTemplateName)
												{
													bReplaceSlot = true;
												}
											}

											if(j >= FacilityState.StaffSlots.Length || bReplaceSlot) // Only add a new staff slot if it doesn't already exist or needs to be replaced
											{
												// Create slot state and link to this facility
												LinkedStaffSlotState = StaffSlotTemplate.CreateInstanceFromTemplate(NewGameState);
												LinkedStaffSlotState.Facility = FacilityState.GetReference();

												// Check for starting the slot locked
												if(SlotDef.bStartsLocked)
												{
													LinkedStaffSlotState.LockSlot();
												}

												// Link the slots
												StaffSlotState.LinkedStaffSlot = LinkedStaffSlotState.GetReference();
												LinkedStaffSlotState.LinkedStaffSlot = StaffSlotState.GetReference();

												if(bReplaceSlot)
												{
													FacilityState.StaffSlots[j] = LinkedStaffSlotState.GetReference();
												}
												else
												{
													FacilityState.StaffSlots.AddItem(LinkedStaffSlotState.GetReference());
												}

												// Add index to list to be skipped since we already added it
												SkipIndices.AddItem(j);
												break;
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}	
}

static function AddAchievementTriggers(Object TriggerObj)
{
	local X2EventManager EventManager;

	// Set up triggers for achievements
	EventManager = `XEVENTMGR;
	EventManager.RegisterForEvent(TriggerObj, 'OnTacticalBeginPlay', class'X2AchievementTracker_DLC_Day90'.static.OnTacticalBeginPlay, ELD_OnStateSubmitted, 50, , true);
	EventManager.RegisterForEvent(TriggerObj, 'TacticalGameEnd', class'X2AchievementTracker_DLC_Day90'.static.OnTacticalGameEnd, ELD_OnStateSubmitted, 50, , true);
	EventManager.RegisterForEvent(TriggerObj, 'PlayerTurnBegun', class'X2AchievementTracker_DLC_Day90'.static.OnPlayerTurnBegun, ELD_OnStateSubmitted, 50, , true);
	EventManager.RegisterForEvent(TriggerObj, 'KillMail', class'X2AchievementTracker_DLC_Day90'.static.OnKillMail, ELD_OnStateSubmitted, 50, , true);
	EventManager.RegisterForEvent(TriggerObj, 'UnitDied', class'X2AchievementTracker_DLC_Day90'.static.OnUnitDied, ELD_OnStateSubmitted, 50, , true);
	EventManager.RegisterForEvent(TriggerObj, 'ItemConstructionCompleted', class'X2AchievementTracker_DLC_Day90'.static.OnItemConstructed, ELD_OnStateSubmitted, 50, , true);
	EventManager.RegisterForEvent(TriggerObj, 'ResearchCompleted', class'X2AchievementTracker_DLC_Day90'.static.OnResearchCompleted, ELD_OnStateSubmitted, 50, , true);
	EventManager.RegisterForEvent(TriggerObj, 'UnitRankUp', class'X2AchievementTracker_DLC_Day90'.static.OnUnitPromoted, ELD_OnStateSubmitted, 50, , true);
	EventManager.RegisterForEvent(TriggerObj, 'OverdriveActivated', class'X2AchievementTracker_DLC_Day90'.static.OnOverdriveActivated, ELD_OnStateSubmitted, 50, , true);
	EventManager.RegisterForEvent(TriggerObj, 'StandardShotActivated', class'X2AchievementTracker_DLC_Day90'.static.OnStandardShotActivated, ELD_OnStateSubmitted, 50, , true);
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
	local XComGameState_CampaignSettings CampaignSettings;
	local XComGameState_SparkManager SparkManager;
	local XComGameState_Objective ObjectiveState;

	foreach StartState.IterateByClassType(class'XComGameState_CampaignSettings', CampaignSettings)
	{
		break;
	}

	// Add Spark manager
	SparkManager = XComGameState_SparkManager(StartState.CreateNewStateObject(class'XComGameState_SparkManager'));
	SparkManager.SetUpManager(StartState);
	SparkManager.bContentCheckCompleted = true; // No need to ask the player about enabling new content on new games
	SparkManager.bContentActivated = true;
	AddAchievementTriggers(SparkManager);

	// Setup Narrative mission/objectives based on content enable
	foreach StartState.IterateByClassType(class'XComGameState_Objective', ObjectiveState)
	{
		if (CampaignSettings.HasOptionalNarrativeDLCEnabled(name(default.DLCIdentifier)))
		{
			if (ObjectiveState.GetMyTemplateName() == default.DLCOptionalNarrativeObjective)
			{
				ObjectiveState.StartObjective(StartState);
				break;
			}
		}
	}
}

/// <summary>
/// Called just before the player launches into a tactical a mission while this DLC / Mod is installed.
/// </summary>
static event OnPreMission(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameStateHistory History;
	local XComGameState_PointOfInterest POIState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_MissionCalendar CalendarState;
	local XComGameState_CampaignSettings CampaignSettings;
	local XComGameState_SparkManager SparkMgr;
	local XComGameState_Unit UnitState;
	local StateObjectReference POIRef;
	local int idx;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	ResHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	CalendarState = XComGameState_MissionCalendar(History.GetSingleGameStateObjectForClass(class'XComGameState_MissionCalendar'));
	CampaignSettings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	SparkMgr = XComGameState_SparkManager(History.GetSingleGameStateObjectForClass(class'XComGameState_SparkManager'));

	// Add Spark Manager to tactical state, in case we need to store off data
	SparkMgr = XComGameState_SparkManager(NewGameState.ModifyStateObject(class'XComGameState_SparkManager', SparkMgr.ObjectID));

	if (SparkMgr.bContentActivated)
	{
		// Only attempt to replace POIs if the player has Narrative content enabled for this DLC, and this mission would have spawned a POI
		// and the tutorial is completed (or not enabled)
		if (CampaignSettings.HasOptionalNarrativeDLCEnabled(name(default.DLCIdentifier)) && MissionState.POIToSpawn.ObjectID != 0 &&
			XComHQ.IsObjectiveCompleted('T0_M10_IntroToBlacksite'))
		{
			foreach History.IterateByClassType(class'XComGameState_PointOfInterest', POIState)
			{
				POIRef = POIState.GetReference();

				// Always looking for an unactivated POI which has never been spawned before, since each of these are unique one-time spawns
				if (ResHQ.ActivePOIs.Find('ObjectID', POIRef.ObjectID) == INDEX_NONE && POIState.NumSpawns < 1 && POIState.GetMyTemplateName() == default.LostTowersPOIName)
				{
					// Try to spawn the Lost Towers POI if the next mission (after the current one) will be at the next force level,
					// and that next force level is the one where the Lost Towers POI should appear
					// Or the force level is already past the Lost Towers spawn threshold
					if ((AlienHQ.GetForceLevel() >= default.LostTowersPOIForceLevel) ||
						((AlienHQ.GetForceLevel() + 1) >= default.LostTowersPOIForceLevel && 
						class'X2StrategyGameRulesetDataStructures'.static.LessThan(AlienHQ.ForceLevelIntervalEndTime, CalendarState.CurrentMissionMonth[0].SpawnDate)))
					{
						// Deactivate the POI which was going to be spawned so it can be used again
						ResHQ.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
						ResHQ.ActivatePOI(NewGameState, POIRef);
						MissionState.POIToSpawn = POIRef;

						break;
					}
				}
			}
		}

		// Unstaff any healing SPARKS from Engineering
		for (idx = 0; idx < XComHQ.Squad.Length; idx++)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[idx].ObjectID));

			if (UnitState.GetSoldierClassTemplateName() == 'Spark' && UnitState.StaffingSlot.ObjectID != 0)
			{
				UnitState.GetStaffSlot().EmptySlot(NewGameState);
			}
		}
	}
}

/// <summary>
/// Called when the player completes a mission while this DLC / Mod is installed.
/// </summary>
static event OnPostMission()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local XComGameState_HeadquartersProjectHealSpark HealProjectState;
	local XComGameState_FacilityXCom EngineeringState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_SparkManager SparkMgr;
	local XComGameState_PointOfInterest POIState;
	local StaffUnitInfo UnitInfo;
	local array<StateObjectReference> SoldiersToTransfer;
	local int idx, SlotIndex, NewBlocksRemaining, NewProjectPointsRemaining;
	local bool bHealProjectFound;
	
	InitializeManagers(); // Make sure manager classes are initialized

	History = `XCOMHISTORY;
	SparkMgr = XComGameState_SparkManager(History.GetSingleGameStateObjectForClass(class'XComGameState_SparkManager'));

	if (SparkMgr.bContentActivated)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Post Mission Update Spark Healing Projects");
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		
		foreach History.IterateByClassType(class'XComGameState_PointOfInterest', POIState)
		{
			if (POIState.GetMyTemplateName() == 'POI_LostTowers' && POIState.bAvailable)
			{
				// Trigger the objective to start the DLC cinematic and VO cues for the Lost Towers mission
				`XEVENTMGR.TriggerEvent('LostTowersPOISpawned', , , NewGameState);
				break;
			}
		}

		// If the unit is in the squad or was spawned from the avenger on the mission, add them to the SoldiersToTransfer array
		SoldiersToTransfer = XComHQ.Squad;
		for (idx = 0; idx < XComHQ.Crew.Length; idx++)
		{
			if (XComHQ.Crew[idx].ObjectID != 0)
			{
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));
				if (UnitState.bSpawnedFromAvenger)
				{
					SoldiersToTransfer.AddItem(XComHQ.Crew[idx]);
				}
			}
		}

		for (idx = 0; idx < SoldiersToTransfer.Length; idx++)
		{
			if (SoldiersToTransfer[idx].ObjectID != 0)
			{
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SoldiersToTransfer[idx].ObjectID));
				if (UnitState.GetSoldierClassTemplateName() == 'Spark')
				{
					// Update Spark healing projects and restart them if a Engineering repair slot is available
					if (!UnitState.IsDead() && !UnitState.bCaptured && (UnitState.IsInjured() || UnitState.GetStatus() == eStatus_Healing))
					{
						UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SoldiersToTransfer[idx].ObjectID));
						UnitState.SetStatus(eStatus_Healing);

						// If the spark already had a healing project active, update it for their current health
						bHealProjectFound = false;
						foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectHealSpark', HealProjectState)
						{
							if (HealProjectState.ProjectFocus == UnitState.GetReference())
							{
								bHealProjectFound = true;
								NewBlocksRemaining = UnitState.GetBaseStat(eStat_HP) - UnitState.GetCurrentStat(eStat_HP);
								if (NewBlocksRemaining > HealProjectState.BlocksRemaining) // The unit was injured again, so update the time to heal
								{
									HealProjectState = XComGameState_HeadquartersProjectHealSpark(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersProjectHealSpark', HealProjectState.ObjectID));

									do // Calculate new wound length again, but ensure it is greater than the previous time, since the unit is more injured
									{
										NewProjectPointsRemaining = HealProjectState.GetWoundPoints(UnitState);
									} until(NewProjectPointsRemaining > HealProjectState.ProjectPointsRemaining);

									HealProjectState.ProjectPointsRemaining = NewProjectPointsRemaining;
									HealProjectState.BlocksRemaining = NewBlocksRemaining;
									HealProjectState.PointsPerBlock = Round(float(NewProjectPointsRemaining) / float(NewBlocksRemaining));
									HealProjectState.BlockPointsRemaining = HealProjectState.PointsPerBlock;
									HealProjectState.UpdateWorkPerHour();
									HealProjectState.StartDateTime = `STRATEGYRULES.GameTime;
									HealProjectState.SetProjectedCompletionDateTime(HealProjectState.StartDateTime);
								}

								break;
							}
						}

						if (!bHealProjectFound) // An existing heal project was not found, so start one for this unit
						{
							HealProjectState = XComGameState_HeadquartersProjectHealSpark(NewGameState.CreateNewStateObject(class'XComGameState_HeadquartersProjectHealSpark'));
							HealProjectState.SetProjectFocus(UnitState.GetReference(), NewGameState);
							XComHQ.Projects.AddItem(HealProjectState.GetReference());
							HealProjectState.bForcePaused = true;
						}

						// Get the Engineering facility and staff the unit in it if there is an open slot
						EngineeringState = XComHQ.GetFacilityByName('Storage'); // Only one Engineering exists, so safe to do this
						if (EngineeringState != none)
						{
							for (SlotIndex = 0; SlotIndex < EngineeringState.StaffSlots.Length; ++SlotIndex)
							{
								//If this slot has not already been modified (filled) in this tactical transfer, check to see if it's valid
								SlotState = XComGameState_StaffSlot(NewGameState.GetGameStateForObjectID(EngineeringState.StaffSlots[SlotIndex].ObjectID));
								if (SlotState == None)
								{
									SlotState = EngineeringState.GetStaffSlot(SlotIndex);

									// If this is a valid soldier slot in Engineering, restaff the Spark to restart their healing project
									if (!SlotState.IsLocked() && SlotState.IsSlotEmpty() && SlotState.IsSoldierSlot())
									{
										UnitInfo.UnitRef = UnitState.GetReference();
										SlotState.FillSlot(UnitInfo, NewGameState);
										break;
									}
								}
							}
						}

						HealProjectState.OnPowerStateOrStaffingChange();
					}
				}
			}
		}

		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}

/// <summary>
/// Called after the player exits the post-mission sequence while this DLC / Mod is installed.
/// </summary>
static event OnExitPostMissionSequence()
{
	local XComGameState_SparkManager SparkMgr;
	
	// Spark Manager should always exist here, because OnPostMission is called before OnExitPostMissionSequence, and InitializeManagers is called there
	SparkMgr = XComGameState_SparkManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_SparkManager'));

	// If the content check for this DLC has not yet been performed, ask the player whether or not it should be enabled for their campaign
	if (!SparkMgr.bContentCheckCompleted)
	{
		EnableDLCContentPopup();
	}
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	class'X2Helpers_DLC_Day90'.static.OnPostAbilityTemplatesCreated();
	class'X2Helpers_DLC_Day90'.static.OnPostItemTemplatesCreated();
	class'X2Helpers_DLC_Day90'.static.OnPostTechTemplatesCreated();
	class'X2Helpers_DLC_Day90'.static.OnPostCharacterTemplatesCreated();
	class'X2Helpers_DLC_Day90'.static.OnPostFacilityTemplatesCreated();
	class'X2Helpers_DLC_Day90'.static.OnPostStaffSlotTemplatesCreated();
}

simulated function EnableDLCContentPopupCallback_Ex(Name eAction)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_SparkManager SparkMgr;
	local XComGameState_CampaignSettings CampaignSettings;

	super.EnableDLCContentPopupCallback_Ex(eAction);

	History = `XCOMHISTORY;
	SparkMgr = XComGameState_SparkManager(History.GetSingleGameStateObjectForClass(class'XComGameState_SparkManager'));
	CampaignSettings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Callback Enable Shen's Last Gift Content");

	// If enabling DLC content from this popup, it is from a loaded save where the DLC wasn't previously installed
	// So if narrative content was somehow enabled, it should be turned off
	if (CampaignSettings.HasOptionalNarrativeDLCEnabled(name(default.DLCIdentifier)))
	{
		CampaignSettings = XComGameState_CampaignSettings(NewGameState.ModifyStateObject(class'XComGameState_CampaignSettings', CampaignSettings.ObjectID));
		CampaignSettings.RemoveOptionalNarrativeDLC(name(default.DLCIdentifier));
	}

	SparkMgr = XComGameState_SparkManager(NewGameState.ModifyStateObject(class'XComGameState_SparkManager', SparkMgr.ObjectID));
	SparkMgr.bContentCheckCompleted = true;

	if (eAction == 'eUIAction_Accept')
	{
		// Content accepted, initiate activation sequence!
		SparkMgr.bContentActivated = true;
		SparkMgr.SetUpManager(NewGameState);
		AddNewTechGameStates(NewGameState);
		AddNewObjectiveGameStates(NewGameState);
		AddNewStaffSlots(NewGameState);
		AddAchievementTriggers(SparkMgr);
	}

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

/// <summary>
/// Calls DLC specific popup handlers to route messages to correct display functions
/// </summary>
static function bool DisplayQueuedDynamicPopup(DynamicPropertySet PropertySet)
{
	if (PropertySet.PrimaryRoutingKey == 'UIAlert_DLC_Day90')
	{
		CallUIAlert_DLC_Day90(PropertySet);
		return true;
	}

	return false;
}

static function CallUIAlert_DLC_Day90(const out DynamicPropertySet PropertySet)
{
	local XComHQPresentationLayer Pres;
	local UIAlert_DLC_Day90 Alert;

	Pres = `HQPRES;

	Alert = Pres.Spawn(class'UIAlert_DLC_Day90', Pres);
	Alert.DisplayPropertySet = PropertySet;
	Alert.eAlertName = PropertySet.SecondaryRoutingKey;

	Pres.ScreenStack.Push(Alert);
}

//---------------------------------------------------------------------------------------
//-------------------------------- DLC CHEATS -------------------------------------------
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
// Call in strategy to add Shen as a normal soldier to your crew
exec function AddLostTowersShenToCrew()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if(UnitState.GetMyTemplateName() == 'LostTowersShen')
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: AddLostTowersShenToCrew");
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
			XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			XComHQ.AddToCrew(NewGameState, UnitState);
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
	}
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);

	switch(Type)
	{
	case 'HUNTERPROTOCOL_CHANCE':
		OutString = string(class'X2Ability_SparkAbilitySet'.default.HUNTERPROTOCOL_CHANCE);
		return true;
	case 'OVERDRIVE_RECOILPENALTY':
		OutString = string(class'X2Effect_DLC_3Overdrive'.default.ShotModifier);
		return true;
	case 'RAINMAKER_BONUSDAMAGE':
		OutString = string(class'X2Ability_SparkAbilitySet'.default.RAINMAKER_DMG_ROCKETLAUNCHER);
		return true;
	case 'RAINMAKER_BONUSRADIUS':
		OutString = string(int(class'X2Ability_SparkAbilitySet'.default.RAINMAKER_RADIUS_ROCKETLAUNCHER));
		return true;
	case 'RAINMAKER_BONUSDIAMETER':
		OutString = string(int(class'X2Ability_SparkAbilitySet'.default.RAINMAKER_CONEDIAMETER_FLAMETHROWER));
		return true;
	case 'RAINMAKER_BONUSLENGTH':
		OutString = string(int(class'X2Ability_SparkAbilitySet'.default.RAINMAKER_CONELENGTH_FLAMETHROWER));
		return true;
	case 'REPAIR_HEALHP':
		OutString = string(class'X2Ability_SparkAbilitySet'.default.REPAIR_HP);
		return true;
	case 'REPAIR_CHARGES':
		OutString = string(class'X2Ability_SparkAbilitySet'.default.REPAIR_CHARGES);
		return true;
	case 'SACRIFICE_DEFENSE':
		OutString = string(class'X2Ability_SparkAbilitySet'.default.SACRIFICE_DEFENSE);
		return true;
	case 'SACRIFICE_ARMOR':
		OutString = string(class'X2Ability_SparkAbilitySet'.default.SACRIFICE_ARMOR);
		return true;
	case 'BOMBARD_CHARGES':
		OutString = string(class'X2Ability_SparkAbilitySet'.default.BOMBARD_CHARGES);
		return true;
	case 'NOVA_DAMAGE':
		OutString = string(int(class'X2Effect_DLC_3_Nova'.default.SourcePerTickIncrease));
		return true;
	}
	return false;
}

/// <summary>
/// Called from XComGameState_Unit:GatherUnitAbilitiesForInit after the game has built what it believes is the full list of
/// abilities for the unit based on character, class, equipment, et cetera. You can add or remove abilities in SetupData.
/// </summary>
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local int i, AbilityIndex;

	switch(UnitState.GetMyTemplateName())
	{
	case 'SparkSoldier':
	case 'LostTowersSpark':
		//  Remove all of the base game heavy weapon abilities (which will have been replaced with a spark specific version)
		for (i = 0; i < class'X2Helpers_DLC_Day90'.default.SparkHeavyWeaponAbilitiesForBit.Length; ++i)
		{
			AbilityIndex = SetupData.Find('TemplateName', class'X2Helpers_DLC_Day90'.default.SparkHeavyWeaponAbilitiesForBit[i]);
			if (AbilityIndex != INDEX_NONE)
				SetupData.Remove(AbilityIndex, 1);
		}
		break;
	}
}