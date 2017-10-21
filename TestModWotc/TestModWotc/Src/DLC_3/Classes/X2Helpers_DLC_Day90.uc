//---------------------------------------------------------------------------------------
//  FILE:    X2Helpers_DLC_Day90.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Helpers_DLC_Day90 extends Object
	config(GameCore)
	abstract;

var config name	DefaultSparkArmor; // Used during Spark creation to not overwrite character pool customizations
var config array<name> DefaultSparkEquipment; // Items which will be added to the HQ inventory for Spark loadouts
var config array<Name> IgnoreAbilitiesForOverdrive;
var config array<Name> AllowedAbilitiesForSparkSelfDestruct;
var config array<Name> SparkHeavyWeaponAbilitiesForBit;
var config array<Name> AllowSparkStaffSlots;
var config array<name> CharacterTemplatesForInteractions;

//---------------------------------------------------------------------------------------
static function CreateSparkSoldier(XComGameState NewGameState, optional StateObjectReference CopiedSpark, optional XComGameState_Tech SparkCreatorTech)
{
	local XComGameStateHistory History;
	local XComOnlineProfileSettings ProfileSettings;
	local X2CharacterTemplateManager CharTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit NewSparkState, CopiedSparkState;

	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	}

	CopiedSparkState = XComGameState_Unit(History.GetGameStateForObjectID(CopiedSpark.ObjectID));

	// Either copy lost towers unit or generate a new unit from the character pool
	if(CopiedSparkState != none)
	{
		CharTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
		CharacterTemplate = CharTemplateMgr.FindCharacterTemplate('SparkSoldier');

		NewSparkState = CharacterTemplate.CreateInstanceFromTemplate(NewGameState);
		NewSparkState.SetTAppearance(CopiedSparkState.kAppearance);
		NewSparkState.SetCharacterName(CopiedSparkState.GetFirstName(), CopiedSparkState.GetLastName(), CopiedSparkState.GetNickName());
		NewSparkState.SetCountry(CopiedSparkState.GetCountry());

		NewSparkState.SetCurrentStat(eStat_HP, CopiedSparkState.GetCurrentStat(eStat_HP));
		NewSparkState.AddXp(CopiedSparkState.GetXPValue() - NewSparkState.GetXPValue());
		NewSparkState.CopyKills(CopiedSparkState);
		NewSparkState.CopyKillAssists(CopiedSparkState);
	}
	else
	{
		// Create a Spark from the Character Pool (will be randomized if no Sparks have been created)
		ProfileSettings = `XPROFILESETTINGS;
		NewSparkState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, ProfileSettings.Data.m_eCharPoolUsage, 'SparkSoldier');
		NewSparkState.RandomizeStats();
		NewSparkState.ApplyInventoryLoadout(NewGameState);
	}
	
	// Make sure the new Spark has the best gear available (will also update to appropriate armor customizations)
	NewSparkState.ApplySquaddieLoadout(NewGameState);
	NewSparkState.ApplyBestGearLoadout(NewGameState);

	NewSparkState.kAppearance.nmPawn = 'XCom_Soldier_Spark';
	NewSparkState.kAppearance.iAttitude = 2; // Force the attitude to be Normal
	NewSparkState.UpdatePersonalityTemplate(); // Grab the personality based on the one set in kAppearance
	NewSparkState.SetStatus(eStatus_Active);
	NewSparkState.bNeedsNewClassPopup = false;

	XComHQ.AddToCrew(NewGameState, NewSparkState);

	if (SparkCreatorTech != none)
	{
		SparkCreatorTech.UnitRewardRef = NewSparkState.GetReference();
	}
}
//---------------------------------------------------------------------------------------
// Create instances of the Spark Armor, Weapon, and BIT and add them to the HQ Inventory
static function CreateSparkEquipment(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local X2ItemTemplateManager ItemMgr;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_HeadquartersXCom XComHQ;
	local int idx;

	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	}

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	// Iterate through the Spark Equipment, find their templates, and build and activate the Item State Object for each
	for (idx = 0; idx < default.DefaultSparkEquipment.Length; idx++)
	{
		ItemTemplate = ItemMgr.FindItemTemplate(default.DefaultSparkEquipment[idx]);
		if (ItemTemplate != none && !XComHQ.HasItem(ItemTemplate))
		{
			ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			XComHQ.AddItemToHQInventory(ItemState);
		}
	}
}

//---------------------------------------------------------------------------------------
static function XComGameState_HeadquartersProjectHealSpark GetHealSparkProject(StateObjectReference UnitRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectHealSpark HealSparkProject;
	local int idx;

	History = `XCOMHISTORY;
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	for (idx = 0; idx < XComHQ.Projects.Length; idx++)
	{
		HealSparkProject = XComGameState_HeadquartersProjectHealSpark(History.GetGameStateForObjectID(XComHQ.Projects[idx].ObjectID));

		if (HealSparkProject != none)
		{
			if (UnitRef == HealSparkProject.ProjectFocus)
			{
				return HealSparkProject;
			}
		}
	}

	return none;
}

//---------------------------------------------------------------------------------------
// Only returns true if narrative content is enabled AND completed, OR if XPack DLC Integration is turned on
static function bool IsLostTowersNarrativeContentComplete()
{
	local XComGameState_CampaignSettings CampaignSettings;
	
	CampaignSettings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	if (CampaignSettings.HasIntegratedDLCEnabled())
	{
		return true; // When DLC is integrated, count this as narrative content being completed
	}
	else if (CampaignSettings.HasOptionalNarrativeDLCEnabled(name(class'X2DownloadableContentInfo_DLC_Day90'.default.DLCIdentifier)))
	{
		if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_LostTowersMissionComplete'))
		{
			return true;
		}
	}

	return false;
}

static function BuildUIAlert_DLC_Day90(
	out DynamicPropertySet PropertySet,
	Name AlertName,
	delegate<X2StrategyGameRulesetDataStructures.AlertCallback> CallbackFunction,
	Name EventToTrigger,
	string SoundToPlay,
	bool bImmediateDisplay)
{
	class'X2StrategyGameRulesetDataStructures'.static.BuildDynamicPropertySet(PropertySet, 'UIAlert_DLC_Day90', AlertName, CallbackFunction, bImmediateDisplay, true, true, false);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicNameProperty(PropertySet, 'EventToTrigger', EventToTrigger);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicStringProperty(PropertySet, 'SoundToPlay', SoundToPlay);
}

static function ShowLostTowersPOIPopup(StateObjectReference POIRef)
{
	local XComHQPresentationLayer Pres;
	local DynamicPropertySet PropertySet;

	Pres = `HQPRES;

	BuildUIAlert_DLC_Day90(PropertySet, 'eAlert_LostTowersScanningSite', Pres.POIAlertCB, '', "Geoscape_POIReveal", false);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicIntProperty(PropertySet, 'POIRef', POIRef.ObjectID);
	class'XComPresentationLayerBase'.static.QueueDynamicPopup(PropertySet);
}

static function ShowLostTowersPOICompletePopup(StateObjectReference POIRef)
{
	local XComHQPresentationLayer Pres;
	local DynamicPropertySet PropertySet;

	Pres = `HQPRES;

	BuildUIAlert_DLC_Day90(PropertySet, 'eAlert_LostTowersScanComplete', Pres.POICompleteCB, '', "Geoscape_POIReached", true);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicIntProperty(PropertySet, 'POIRef', POIRef.ObjectID);
	class'XComPresentationLayerBase'.static.QueueDynamicPopup(PropertySet);
}

static function ShowSparkSquadSelectInfoPopup()
{
	local DynamicPropertySet PropertySet;

	BuildUIAlert_DLC_Day90(PropertySet, 'eAlert_SparkSquadSelectInfo', none, '', "Geoscape_CrewMemberLevelledUp", true);
	class'XComPresentationLayerBase'.static.QueueDynamicPopup(PropertySet);
}

static function OnPostAbilityTemplatesCreated()
{
	local array<name> TemplateNames;
	local array<X2AbilityTemplate> AbilityTemplates;
	local name TemplateName;
	local X2AbilityTemplateManager AbilityMgr;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCost Cost;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitEffects SelfDestructExcludeEffects;

	SelfDestructExcludeEffects = new class'X2Condition_UnitEffects';
	SelfDestructExcludeEffects.AddExcludeEffect(class'X2Ability_SparkAbilitySet'.default.SparkSelfDestructEffectName, 'AA_UnitIsSelfDestructing');

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityMgr.GetTemplateNames(TemplateNames);
	foreach TemplateNames(TemplateName)
	{
		AbilityMgr.FindAbilityTemplateAllDifficulties(TemplateName, AbilityTemplates);

		if( default.IgnoreAbilitiesForOverdrive.Find(TemplateName) != INDEX_NONE )
		{
			// We may still want to disable abilities that are not allowed during Self-Destruct. (i.e. Overwatch)
			foreach AbilityTemplates(AbilityTemplate)
			{
				if( default.AllowedAbilitiesForSparkSelfDestruct.Find(TemplateName) == INDEX_NONE )
				{
					AbilityTemplate.AbilityShooterConditions.AddItem(SelfDestructExcludeEffects);
				}
			}
			continue;
		}

		foreach AbilityTemplates(AbilityTemplate)
		{
			foreach AbilityTemplate.AbilityCosts(Cost)
			{
				ActionPointCost = X2AbilityCost_ActionPoints(Cost);
				if (ActionPointCost != None)
				{
					ActionPointCost.DoNotConsumeAllEffects.AddItem('DLC_3Overdrive');
				}
			}

			if(TemplateName == 'IntrusionProtocol')
			{
				AbilityTemplate.AdditionalAbilities.AddItem('IntrusionProtocol_Hack_ElevatorControl');
			}
			else if(TemplateName == 'Hack')
			{
				AbilityTemplate.AdditionalAbilities.AddItem('Hack_ElevatorControl');
			}

			if (default.AllowedAbilitiesForSparkSelfDestruct.Find(TemplateName) == INDEX_NONE)
			{
				AbilityTemplate.AbilityShooterConditions.AddItem(SelfDestructExcludeEffects);
			}
		}
	}
}

static function OnPostItemTemplatesCreated()
{
	local AltGameArchetypeUse GameArch;
	local X2ItemTemplateManager ItemMgr;
	local array<name> TemplateNames;
	local name TemplateName;
	local array<X2DataTemplate> DataTemplates;
	local X2WeaponTemplate WeaponTemplate;
	local int ScanTemplates;
	local string NewAbilityName;
	
	GameArch.UseGameArchetypeFn = SparkHeavyWeaponCheck;
	
	GameArch.ArchetypeString = "DLC_3_Spark_Heavy.WP_Heavy_RocketLauncher";
	AddAltGameArchetype(GameArch, 'RocketLauncher')	;

	GameArch.ArchetypeString = "DLC_3_Spark_Heavy.WP_Heavy_ShredderGun";
	AddAltGameArchetype(GameArch, 'ShredderGun');

	GameArch.ArchetypeString = "DLC_3_Spark_Heavy.WP_Heavy_Flamethrower";
	AddAltGameArchetype(GameArch, 'Flamethrower');

	GameArch.ArchetypeString = "DLC_3_Spark_Heavy.WP_Heavy_Flamethrower_Lv2";
	AddAltGameArchetype(GameArch, 'FlamethrowerMk2');

	GameArch.ArchetypeString = "DLC_3_Spark_Heavy.WP_Heavy_BlasterLauncher";
	AddAltGameArchetype(GameArch, 'BlasterLauncher');

	GameArch.ArchetypeString = "DLC_3_Spark_Heavy.WP_Heavy_PlasmaBlaster";
	AddAltGameArchetype(GameArch, 'PlasmaBlaster');

	GameArch.ArchetypeString = "DLC_3_Spark_Heavy.WP_Heavy_ShredstormCannon";
	AddAltGameArchetype(GameArch, 'ShredstormCannon');

	GameArch.UseGameArchetypeFn = BitHeavyWeaponCheck;

	GameArch.ArchetypeString = "DLC_3_Bit_Heavy.WP_Heavy_RocketLauncher";
	AddAltGameArchetype(GameArch, 'RocketLauncher')	;

	GameArch.ArchetypeString = "DLC_3_Bit_Heavy.WP_Heavy_ShredderGun";
	AddAltGameArchetype(GameArch, 'ShredderGun');

	GameArch.ArchetypeString = "DLC_3_Bit_Heavy.WP_Heavy_Flamethrower";
	AddAltGameArchetype(GameArch, 'Flamethrower');

	GameArch.ArchetypeString = "DLC_3_Bit_Heavy.WP_Heavy_Flamethrower_Lv2";
	AddAltGameArchetype(GameArch, 'FlamethrowerMk2');

	GameArch.ArchetypeString = "DLC_3_Bit_Heavy.WP_Heavy_BlasterLauncher";
	AddAltGameArchetype(GameArch, 'BlasterLauncher');

	GameArch.ArchetypeString = "DLC_3_Bit_Heavy.WP_Heavy_PlasmaBlaster";
	AddAltGameArchetype(GameArch, 'PlasmaBlaster');

	GameArch.ArchetypeString = "DLC_3_Bit_Heavy.WP_Heavy_ShredstormCannon";
	AddAltGameArchetype(GameArch, 'ShredstormCannon');

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemMgr.GetTemplateNames(TemplateNames);

	foreach TemplateNames(TemplateName)
	{
		ItemMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
		
		for( ScanTemplates = 0; ScanTemplates < DataTemplates.Length; ++ScanTemplates )
		{
			WeaponTemplate = X2WeaponTemplate(DataTemplates[ScanTemplates]);
			// Add the new spark only ability
			if( WeaponTemplate != None && default.SparkHeavyWeaponAbilitiesForBit.Find(TemplateName) != INDEX_NONE )
			{
				NewAbilityName = "Spark" $ TemplateName;
				WeaponTemplate.Abilities.AddItem(Name(NewAbilityName));
			}
		}
	}
}

static function OnPostTechTemplatesCreated()
{
	local StrategyRequirement AltTechReq, AltSpecialReq;

	AltTechReq.RequiredTechs.AddItem('MechanizedWarfare');
	AddAltTechRequirement(AltTechReq, 'HeavyWeapons');

	AltSpecialReq.SpecialRequirementsFn = IsLostTowersNarrativeContentComplete;
	AddAltTechRequirement(AltSpecialReq, 'HeavyWeapons');
}

static function AddAltTechRequirement(StrategyRequirement AltReq, Name BaseTemplateName)
{
	local X2StrategyElementTemplateManager StrategyTemplateMgr;
	local X2TechTemplate TechTemplate;
	local array<X2DataTemplate> DataTemplates;
	local int i;

	StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	StrategyTemplateMgr.FindDataTemplateAllDifficulties(BaseTemplateName, DataTemplates);

	for (i = 0; i < DataTemplates.Length; ++i)
	{
		TechTemplate = X2TechTemplate(DataTemplates[i]);
		if (TechTemplate != none)
		{
			TechTemplate.AlternateRequirements.AddItem(AltReq);
		}
	}
}

static function OnPostCharacterTemplatesCreated()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate SoldierTemplate;
	local array<X2DataTemplate> DataTemplates;
	local name NameIter;
	local int i;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	
	foreach default.CharacterTemplatesForInteractions(NameIter)
	{
		CharacterTemplateMgr.FindDataTemplateAllDifficulties(NameIter, DataTemplates);
		for (i = 0; i < DataTemplates.Length; ++i)
		{
			SoldierTemplate = X2CharacterTemplate(DataTemplates[i]);
			if (SoldierTemplate != none)
			{
				SoldierTemplate.Abilities.AddItem('Interact_ActivateSpark');
				SoldierTemplate.Abilities.AddItem('Interact_AtmosphereComputer');
				SoldierTemplate.Abilities.AddItem('Interact_UseElevator');
			}
		}
	}
}

static function OnPostFacilityTemplatesCreated()
{
	local X2StrategyElementTemplateManager StratMgr;
	local X2FacilityTemplate FacilityTemplate;
	local AuxMapInfo MapInfo;
	local array<X2DataTemplate> AllHangarTemplates;
	local X2DataTemplate Template;

	// Grab manager
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	// Find all armory/hangar templates
	StratMgr.FindDataTemplateAllDifficulties('Hangar', AllHangarTemplates);

	foreach AllHangarTemplates(Template)
	{
		// Add Aux Maps to the template
		FacilityTemplate = X2FacilityTemplate(Template);
		MapInfo.MapName = "CIN_SoldierIntros_DLC3";
		MapInfo.InitiallyVisible = true;
		FacilityTemplate.AuxMaps.AddItem(MapInfo);
	}
}

static function OnPostStaffSlotTemplatesCreated()
{
	local X2StrategyElementTemplateManager StrategyTemplateMgr;
	local X2StaffSlotTemplate StaffSlotTemplate;
	local X2DataTemplate Template;
	local array<X2DataTemplate> DataTemplates;
	local array<name> TemplateNames;
	local name TemplateName;

	StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();		
	StrategyTemplateMgr.GetTemplateNames(TemplateNames);

	foreach TemplateNames(TemplateName)
	{
		// Sparks are allowed to be staffed in a specific list of slots
		if (default.AllowSparkStaffSlots.Find(TemplateName) == INDEX_NONE)
		{
			StrategyTemplateMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
			foreach DataTemplates(Template)
			{
				// Otherwise don't allow Sparks to be staffed in any normal soldier slot
				StaffSlotTemplate = X2StaffSlotTemplate(Template);
				if (StaffSlotTemplate != none && StaffSlotTemplate.bSoldierSlot)
				{
					StaffSlotTemplate.ExcludeClasses.AddItem('Spark');
				}
			}
		}
	}
}


static function AddAltGameArchetype(AltGameArchetypeUse GameArch, Name BaseTemplateName)
{
	local X2ItemTemplateManager ItemMgr;
	local X2WeaponTemplate WeaponTemplate;
	local array<X2DataTemplate> DataTemplates;
	local int i;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemMgr.FindDataTemplateAllDifficulties(BaseTemplateName, DataTemplates);
	for (i = 0; i < DataTemplates.Length; ++i)
	{
		WeaponTemplate = X2WeaponTemplate(DataTemplates[i]);
		if (WeaponTemplate != none)
		{
			WeaponTemplate.AltGameArchetypeArray.AddItem(GameArch);
		}
	}
}

static function bool SparkHeavyWeaponCheck(XComGameState_Item ItemState, XComGameState_Unit UnitState, string ConsiderArchetype)
{
	switch(UnitState.GetMyTemplateName())
	{
	case 'SparkSoldier':
	case 'LostTowersSpark':
		return true;
	}
	return false;
}

static function bool BitHeavyWeaponCheck(XComGameState_Item ItemState, XComGameState_Unit UnitState, string ConsiderArchetype)
{
	switch(UnitState.GetMyTemplateName())
	{
	case 'SparkBitMk1':
	case 'SparkBitMk2':
	case 'SparkBitMk3':
		return true;
	}
	return false;
}

static function bool IsFeralMECUnit(XComGameState_Unit UnitState)
{
	local Name CharacterGroupName;
	CharacterGroupName = UnitState.GetMyTemplate().CharacterGroupName;
	return  CharacterGroupName == class'X2Character_DLC_Day90Characters'.const.FERAL_MEC_GROUP_NAME;
}

static function bool GetOverloadableFeralMECUnits(out array<XComGameState_Unit> FeralMECList_Out, XGPlayer OwningPlayer)
{
	local array<XComGameState_Unit> UnitList;
	local XComGameState_Unit UnitState;
	OwningPlayer.GetPlayableUnits(UnitList, true);
	foreach UnitList(UnitState)
	{
		if( IsFeralMECUnit(UnitState) 
		   && !UnitState.IsUnrevealedAI() 
		   && !UnitState.IsUnitAffectedByEffectName(class'X2Ability_SparkAbilitySet'.default.SparkSelfDestructEffectName)
		   && UnitState.NumActionPoints() > 0 )

		{
			FeralMECList_Out.AddItem(UnitState);
		}
	}
	return FeralMECList_Out.Length > 0;
}