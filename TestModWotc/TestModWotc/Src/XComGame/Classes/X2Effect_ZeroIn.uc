class X2Effect_ZeroIn extends X2Effect_Persistent
	config(GameData_SoldierSkills);

var config int CritPerShot;
var config int LockedInAimPerShot;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectGameState.ZeroInListener, ELD_OnStateSubmitted, , `XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item SourceWeapon;
	local ShotModifierInfo ShotMod;
	local UnitValue ShotsValue, TargetValue;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none && SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon && !bIndirectFire)
	{
		Attacker.GetUnitValue('ZeroInShots', ShotsValue);
		Attacker.GetUnitValue('ZeroInTarget', TargetValue);
		
		if (ShotsValue.fValue > 0)
		{
			ShotMod.ModType = eHit_Crit;
			ShotMod.Reason = FriendlyName;
			ShotMod.Value = ShotsValue.fValue * default.CritPerShot;
			ShotModifiers.AddItem(ShotMod);

			if (TargetValue.fValue == Target.ObjectID)
			{
				ShotMod.ModType = eHit_Success;
				ShotMod.Reason = FriendlyName;
				ShotMod.Value = ShotsValue.fValue * default.LockedInAimPerShot;
				ShotModifiers.AddItem(ShotMod);
			}
		}
	}
}

DefaultProperties
{
	EffectName="ZeroIn"
	DuplicateResponse=eDupe_Ignore
}