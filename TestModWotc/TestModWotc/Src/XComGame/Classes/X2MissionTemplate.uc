//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2MissionTemplate.uc
//  AUTHOR:  Brian Whitman --  4/3/2015
//---------------------------------------------------------------------------------------
//  Copyright (c) 2015 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2MissionTemplate extends X2DataTemplate
	native(Core);

var const localized string DisplayName;				// The primary Objective for this mission before it is completed
var const localized string PostMissionType;			// The primary Objective for this mission after it is completed
var const localized string BriefingImage;
var const localized string Briefing;					// The primary Objective for this mission, as displayed on the Dropship loading screen
var const localized array<string> ObjectiveTextPools; // List of text lines to display in the objectives list in the drop ship mission start screen
var const localized array<string> PreMissionNarratives; // Narrative moment to play on the pre mission dropship

// Callback function to get the squad for the next part of the mission. If unspecified, will just use
// XComHQ.Squad as the mission squad. Override this function to allow complex multipart squad
// behavior, such as what happens in the Lost and Abandoned mission
var delegate<GetMissionSquadDelegate> GetMissionSquadFn;
delegate bool GetMissionSquadDelegate(name MissionTemplate, out array<StateObjectReference> Squad);

// "MissionType" should match the sType parameter in the mission definition ini arrays.
static function GetMissionSquad(string MissionType, out array<StateObjectReference> Squad)
{
	local X2MissionTemplate MissionTemplate;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComTacticalMissionManager MissionManager; 
	local MissionDefinition MissionDef;

	XComHQ =  XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	`assert(XComHQ != none);

	MissionManager = `TACTICALMISSIONMGR;
	if(!MissionManager.GetMissionDefinitionForType(MissionType, MissionDef))
	{
		`Redscreen("X2MissionTemplate::GetMissionSquad: Could not find MissionDefinition for mission sType " $ MissionType);
		Squad = XComHQ.AllSquads[0].SquadMembers;
		return;
	}

	MissionTemplate = class'X2MissionTemplateManager'.static.GetMissionTemplateManager().FindMissionTemplate(MissionDef.MissionName);
	if(MissionTemplate == none)
	{
		`Redscreen("X2MissionTemplate::GetMissionSquad: Could not find template for mission type " $ MissionDef.MissionName);
	}

	if(MissionTemplate != none && MissionTemplate.GetMissionSquadFn != none)
	{
		// this mission type needs to make a special squad
		if(!MissionTemplate.GetMissionSquadFn(MissionDef.MissionName, Squad))
		{
			// just keep using the previous squad, this mission type doesn't want to do anything special
			Squad = XComHQ.Squad;
		}
	}
	else
	{
		// just keep using the previous squad, this mission type doesn't want to do anything special
		Squad = XComHQ.Squad;
	}
}

function int GetNumObjectives()
{
	return ObjectiveTextPools.Length;
}

function string GetObjectiveText(int TextLine, optional name QuestItemTemplateName)
{
	local XGParamTag ParamTag;
	local X2QuestItemTemplate QuestItem;

	if(TextLine < 0 || TextLine >= ObjectiveTextPools.Length)
	{
		return "Error: Invalid objective text line requested.";
	}
	else
	{
		if(QuestItemTemplateName != '')
		{
			ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			QuestItem = X2QuestItemTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(QuestItemTemplateName));

			if(QuestItem != none)
			{
				ParamTag.StrValue0 = QuestItem.GetItemFriendlyName();
				return `XEXPAND.ExpandString(ObjectiveTextPools[TextLine]);
			}
		}
		
		return ObjectiveTextPools[TextLine];
	}
}
event int GetNumChallengeObjectives()
{
	local XComGameStateHistory History;
	local XComGameState_ObjectivesList ObjectiveList;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_ObjectivesList', ObjectiveList)
	{
		break;
	}

	if (ObjectiveList == none)
	{
		return 0;
	}
	else
	{
		return ObjectiveList.ObjectiveDisplayInfos.Length;
	}
}