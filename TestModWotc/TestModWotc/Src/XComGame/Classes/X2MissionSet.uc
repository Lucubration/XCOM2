//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2MissionSet.uc
//  AUTHOR:  Brian Whitman --  4/3/2015
//---------------------------------------------------------------------------------------
//  Copyright (c) 2015 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2MissionSet extends X2Mission config(GameCore);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2MissionTemplate> Templates;

// XPACK (nesting these at the beginning of the TQL mission list)
        // Resistance Ops
            Templates.AddItem(AddMissionTemplate('GatherSurvivors'));
            Templates.AddItem(AddMissionTemplate('RecoverExpedition'));
            Templates.AddItem(AddMissionTemplate('SwarmDefense'));

        // Guerilla Ops
            Templates.AddItem(AddMissionTemplate('NeutralizeFieldCommander'));
            Templates.AddItem(AddMissionTemplate('SabotageTransmitter'));

        // Stronghold
            Templates.AddItem(AddMissionTemplate('ChosenStrongholdShort'));
            Templates.AddItem(AddMissionTemplate('ChosenStrongholdLong'));

        // Showdown        
            Templates.AddItem(AddMissionTemplate('ChosenShowdown_Assassin'));
            Templates.AddItem(AddMissionTemplate('ChosenShowdown_Warlock'));
            Templates.AddItem(AddMissionTemplate('ChosenShowdown_Hunter'));

        // Supply
            Templates.AddItem(AddMissionTemplate('SupplyExtraction'));

        // Retaliation
            Templates.AddItem(AddMissionTemplate('ChosenRetaliation'));

        // Avenger Defense
            Templates.AddItem(AddAvengerAssaultTemplate());   

        // Covert Ops
            Templates.AddItem(AddMissionTemplate('CovertEscape'));
            Templates.AddItem(AddMissionTemplate('CompoundRescueOperative'));

        // Lost and Abandoned
            Templates.AddItem(AddLostAndAbandonedATemplate());
            Templates.AddItem(AddLostAndAbandonedBTemplate());
            Templates.AddItem(AddLostAndAbandonedCTemplate());

    // Gatecrasher
        Templates.AddItem(AddMissionTemplate('SabotageAdventMonument'));

    // Tutorial Flight Device
        Templates.AddItem(AddMissionTemplate('RecoverFlightDevice'));

    // Guerilla Ops
        Templates.AddItem(AddMissionTemplate('RecoverItem'));
        Templates.AddItem(AddMissionTemplate('RecoverItemADV'));
        Templates.AddItem(AddMissionTemplate('RecoverItemTrain'));
        Templates.AddItem(AddMissionTemplate('RecoverItemVehicle'));

        Templates.AddItem(AddMissionTemplate('DestroyRelay'));

        Templates.AddItem(AddMissionTemplate('HackWorkstation'));
        Templates.AddItem(AddMissionTemplate('HackWorkstationADV'));
        Templates.AddItem(AddMissionTemplate('HackWorkstationTrain'));

        Templates.AddItem(AddMissionTemplate('ProtectDevice'));

    // Council Missions
        Templates.AddItem(AddMissionTemplate('ExtractVIP'));

        Templates.AddItem(AddMissionTemplate('RescueVIP'));
        Templates.AddItem(AddMissionTemplate('RescueVIPVehicle'));

        Templates.AddItem(AddMissionTemplate('NeutralizeTarget'));
        Templates.AddItem(AddMissionTemplate('NeutralizeTargetVehicle'));

    // Supply Missions
        Templates.AddItem(AddMissionTemplate('SupplyLineRaidATT'));
        Templates.AddItem(AddMissionTemplate('SupplyLineRaidTrain'));
        Templates.AddItem(AddMissionTemplate('SupplyLineRaidConvoy'));

        Templates.AddItem(AddMissionTemplate('SecureUFO'));

    // Sabotage Missions
        Templates.AddItem(AddMissionTemplate('SabotageAlienFacility'));

    // Retaliation Missions
        Templates.AddItem(AddMissionTemplate('Terror'));

    // Avenger Defense Missions
        Templates.AddItem(AddMissionTemplate('AvengerDefense'));

    // Golden Path Missions
        Templates.AddItem(AddMissionTemplate('AdventFacilityBLACKSITE'));
        Templates.AddItem(AddMissionTemplate('AdventFacilityFORGE'));
        Templates.AddItem(AddMissionTemplate('AdventFacilityPSIGATE'));

    // Final Mission
        Templates.AddItem(AddMissionTemplate('CentralNetworkBroadcast'));

        Templates.AddItem(AddMissionTemplate('AssaultFortressLeadup'));
        Templates.AddItem(AddMissionTemplate('DestroyAvatarProject'));

    // Special Missions (we want these at the end of the TQL list)
        Templates.AddItem(AddMissionTemplate('TutorialRescueCommander'));
        Templates.AddItem(AddMissionTemplate('TestingMission'));
        Templates.AddItem(AddMissionTemplate('DefeatHumanOpponent'));

    return Templates;
}

static protected function X2MissionTemplate AddMissionTemplate(name missionName)
{
    local X2MissionTemplate Template;
	`CREATE_X2TEMPLATE(class'X2MissionTemplate', Template, missionName);
    return Template;
}

static protected function X2MissionTemplate AddAvengerAssaultTemplate()
{
    local X2MissionTemplate MissionTemplate;

    MissionTemplate = AddMissionTemplate('ChosenAvengerDefense');
    MissionTemplate.GetMissionSquadFn = GetAvengerAssaultSquad;

    return MissionTemplate;
}

static protected function X2MissionTemplate AddLostAndAbandonedATemplate()
{
	local X2MissionTemplate MissionTemplate;

	MissionTemplate = AddMissionTemplate('LostAndAbandonedA');
	MissionTemplate.GetMissionSquadFn = GetLostAndAbandonedSquad;

	return MissionTemplate;
}

static protected function X2MissionTemplate AddLostAndAbandonedBTemplate()
{
	local X2MissionTemplate MissionTemplate;

	MissionTemplate = AddMissionTemplate('LostAndAbandonedB');
	MissionTemplate.GetMissionSquadFn = GetLostAndAbandonedSquad;

	return MissionTemplate;
}

static protected function X2MissionTemplate AddLostAndAbandonedCTemplate()
{
	local X2MissionTemplate MissionTemplate;

	MissionTemplate = AddMissionTemplate('LostAndAbandonedC');
	MissionTemplate.GetMissionSquadFn = GetLostAndAbandonedSquad;

	return MissionTemplate;
}

static protected function bool GetLostAndAbandonedSquad(name MissionTemplate, out array<StateObjectReference> Squad)
{
	local XComGameState_Unit UnitState;
	local XComGameState_BattleData BattleData;
	local XComGameState_HeadquartersXCom XComHQ;
	local int scan;

	XComHQ =  XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	`assert(XComHQ != none);

	if(XComHQ.AllSquads.Length < 2)
	{
		// to support TQL, we dont have separate squads, so just use the main one
		Squad = XComHQ.AllSquads[0].SquadMembers;
	}
	else
	{
		`assert(XComHQ.AllSquads.Length > 0); // the only way for this array to be empty is if mission setup code is broken

		switch(MissionTemplate)
		{
		case 'LostAndAbandonedA':
			Squad = XComHQ.AllSquads[0].SquadMembers;
			break;

		case 'LostAndAbandonedB':
			Squad = XComHQ.AllSquads[1].SquadMembers;
			break;

		case 'LostAndAbandonedC':
			// third leg contains all members from both parts of the mission (see below).
			// We start with the current squad in case we are lanching directly from TQL
			Squad = XComHQ.Squad;
			break;

		default:
			`assert(false); // unsupported mission type
		}
	}

	// if this is the third leg, grab all units from previous legs of the mission as well. It's a big party!
	if(MissionTemplate == 'LostAndAbandonedC')
	{
		BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
		`assert(BattleData != none);

		// snag all xcom units in the current mission
		foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Unit', UnitState)
		{
			if(UnitState.GetTeam() == eTeam_XCom 
				&& !UnitState.IsMindControlled()
				&& !UnitState.GetMyTemplate().bIsCosmetic
				&& Squad.Find('ObjectID', UnitState.ObjectID) == INDEX_NONE
				&& !UnitState.IsIncapacitated() 
				&& !UnitState.IsDead()
				&& !UnitState.IsBeingCarried() )
			{
				Squad.AddItem(UnitState.GetReference());
			}
		}

		for( scan = Squad.Length - 1; scan >= 0; --scan )
		{
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Squad[scan].ObjectId));
			if( UnitState.IsBeingCarried() || UnitState.IsIncapacitated() || UnitState.IsDead() )
			{
				Squad.RemoveItem(Squad[scan]);
			}
		}
	}

	return Squad.Length > 0;
}

static protected function bool GetAvengerAssaultSquad(name MissionTemplate, out array<StateObjectReference> Squad)
{
    local XComGameState_HeadquartersXCom XComHQ;
    local StateObjectReference NextState;
    local ReserveSquad NextSquad;

    XComHQ =  XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    `assert(XComHQ != none);

    `Log("Get Squad for Avenger Assault");

    if(XComHQ.AllSquads.Length < 2)
    {
        // to support TQL, we dont have separate squads, so just use the main one
        Squad = XComHQ.AllSquads[0].SquadMembers;
    }
    else
    {
		Squad.Length = 0;

        foreach XComHQ.AllSquads(NextSquad)
        {
            foreach NextSquad.SquadMembers(NextState)
            {
                Squad.AddItem(NextState);
                `Log("Added to squad "@NextState.ObjectID);
            }
        }
    }

    return Squad.Length > 0;
}
