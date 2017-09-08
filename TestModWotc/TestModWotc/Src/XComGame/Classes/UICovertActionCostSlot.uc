//---------------------------------------------------------------------------------------
//  FILE:    UICovertActionCostSlot.uc
//  AUTHOR:  Joe Weinhoffer
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class UICovertActionCostSlot extends UICovertActionSlot
	dependson(UIPersonnel, XComGameState_CovertAction);

var StrategyCost Cost;
var StateObjectReference RewardRef;
var int CostIndex;

var localized string m_strPayCost;
var localized string m_strClearCost;
var localized string m_strNoResourcesAvailable;

//-----------------------------------------------------------------------------
function UICovertActionSlot InitStaffSlot(UICovertActionSlotContainer OwningContainer, StateObjectReference Action, int _MCIndex, int _SlotIndex, delegate<OnSlotUpdated> onSlotUpdatedDel)
{
	local XComGameState_CovertAction ActionState;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(Action.ObjectID));
	Cost = ActionState.CostSlots[_SlotIndex].Cost;
	RewardRef = ActionState.CostSlots[_SlotIndex].RewardRef;
	CostIndex = _SlotIndex;
	
	super.InitStaffSlot(OwningContainer, Action, _MCIndex, _SlotIndex, onSlotUpdatedDel);

	return self;
}

function UpdateData()
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction ActionState;
	local XComGameState_Reward RewardState;
	local XComGameState_HeadquartersXCom XComHQ;
	local string CostString, RewardString, CostImage, Button;
	local array<StrategyCostScalar> CostScalars;

	History = `XCOMHISTORY;
	RewardState = XComGameState_Reward(History.GetGameStateForObjectID(RewardRef.ObjectID));
	ActionState = GetAction();
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	
	CostScalars.Length = 0;
	CostString = class'UIUtilities_Strategy'.static.GetStrategyCostString(Cost, CostScalars);
	CostImage = GetAction().GetCostSlotImage(CostIndex);
	
	if( RewardState != none )
	{
		if( ActionState.bCompleted )
		{
			RewardString = RewardState.GetRewardString();
		}
		else if (IsCostPurchased())
		{
			RewardString = class'UIUtilities_Text'.static.GetColoredText(RewardState.GetRewardPreviewString(), eUIState_Good);
		}
		else if(XComHQ.CanAffordAllStrategyCosts(Cost, CostScalars))
		{
			RewardString = class'UIUtilities_Text'.static.GetColoredText(RewardState.GetRewardPreviewString(), eUIState_Normal);
		}
		else
		{
			RewardString = class'UIUtilities_Text'.static.GetColoredText(RewardState.GetRewardPreviewString(), eUIState_Disabled);
		}
	}
		
	eState = eUIState_Normal;
	
	if(!IsCostPurchased())
	{
		if (!ActionState.bStarted)
		{
			Button = m_strPayCost;
			if (!XComHQ.CanAffordAllStrategyCosts(Cost, CostScalars))
			{
				RewardString @= "\n" $ class'UIUtilities_Text'.static.GetColoredText(m_strNoResourcesAvailable, eUIState_Disabled);
				eState = eUIState_Disabled;
			}
		}
		else
		{
			eState = eUIState_Disabled;
		}
	}
	else
	{
		// The reward was purchased, so set to good state
		eState = eUIState_Good;

		if (!ActionState.bStarted)
		{
			Button = m_strClearCost;
		}
	}

	Update(CostString, RewardString, Button, CostImage);
}

function HandleClick(string ButtonName)
{
	local XComGameState NewGameState;
	local XComGameState_CovertAction ActionState;

	if (!GetAction().bCompleted)
	{
		if (!IsCostPurchased())
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clear Cost in Covert Action");
			ActionState = XComGameState_CovertAction(NewGameState.ModifyStateObject(class'XComGameState_CovertAction', ActionRef.ObjectID));
			ActionState.CostSlots[CostIndex].bPurchased = true;
			ActionState.UpdateNegatedRisks(NewGameState);
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

			if (Cost.ResourceCosts.Length > 0)
			{
				switch (Cost.ResourceCosts[0].ItemTemplateName)
				{
				case 'EleriumDust':
				case 'AlienAlloy':
				case 'Supplies':	`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent("UI_CovertOps_AddSupplies"); break;
				case 'Intel':		`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent("UI_CovertOps_AddIntel"); break;
				}
			}

			UpdateDisplay();
		}
		else
		{
			ClearSlot();
		}
	}

	`HQPRES.m_kAvengerHUD.UpdateResources();
}

function ClearSlot()
{
	local XComGameState NewGameState;
	local XComGameState_CovertAction ActionState;

	if (IsCostPurchased())
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clear Cost in Covert Action");
		ActionState = XComGameState_CovertAction(NewGameState.ModifyStateObject(class'XComGameState_CovertAction', ActionRef.ObjectID));
		ActionState.CostSlots[CostIndex].bPurchased = false;
		ActionState.UpdateNegatedRisks(NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

		`XSTRATEGYSOUNDMGR.PlayPersistentSoundEvent("StrategyUI_Staff_Remove");

		UpdateDisplay();
	}
	super.ClearSlot();

	`HQPRES.m_kAvengerHUD.UpdateResources();
}

function bool IsCostPurchased()
{
	return GetAction().CostSlots[CostIndex].bPurchased;
}

//==============================================================================
