//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DLC_3Overdrive.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_DLC_3Overdrive extends X2Effect_Persistent
	config(GameData_SoldierSkills);

var name OverdriveUnitValue;
var config int ShotModifier;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;
	local UnitValue OverdriveValue;

	if (Attacker.HasSoldierAbility('AdaptiveAim'))
		return;

	if (Attacker.GetUnitValue(default.OverdriveUnitValue, OverdriveValue))
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = OverdriveValue.fValue * default.ShotModifier;
		ShotModifiers.AddItem(ShotInfo);
	}
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj, FilterObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	FilterObj = `XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', AbilityActivatedListener, ELD_OnStateSubmitted, , FilterObj);
}

static function EventListenerReturn AbilityActivatedListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit UnitState;
	local XComGameState NewGameState;
	local UnitValue OverdriveValue;

	AbilityState = XComGameState_Ability(EventData);
	UnitState = XComGameState_Unit(EventSource);

	if (GameState.GetContext().InterruptionStatus != eInterruptionStatus_Interrupt && AbilityState.SourceWeapon.ObjectID != 0)
	{
		if (AbilityState.SourceWeapon.ObjectID == UnitState.GetPrimaryWeapon().ObjectID)
		{
			if (AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Overdrive Tracker");
				UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
				UnitState.GetUnitValue(default.OverdriveUnitValue, OverdriveValue);
				UnitState.SetUnitFloatValue(default.OverdriveUnitValue, OverdriveValue.fValue + 1, eCleanup_BeginTurn);
				`TACTICALRULES.SubmitGameState(NewGameState);
			}
		}
	}
	return ELR_NoInterrupt;
}

DefaultProperties
{
	EffectName = "DLC_3Overdrive"
	DuplicateResponse = eDupe_Ignore
	OverdriveUnitValue = "OverdriveShots"
}