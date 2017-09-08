class X2Effect_HomingMine extends X2Effect_Persistent;

var() name AbilityToTrigger;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;
	local XComGameState_Unit TargetUnit;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', EffectGameState.HomingMineListener, ELD_OnStateSubmitted, , TargetUnit);
	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', EffectGameState.HomingMineListener, ELD_OnStateSubmitted, , TargetUnit);
}

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local XComGameState_Unit SourceUnit;

	if (class'XComGameStateContext_Ability'.static.IsHitResultMiss(CurrentResult) && X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != none)
	{
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

		if (SourceUnit.GetTeam() == Attacker.GetTeam())		//	guarantee shot for squadmates only
		{
			NewHitResult = eHit_Success;
			return true;
		}
	}
	return false;
}

simulated function GetAOETiles(XComGameState_Unit EffectSource, XComGameState_Unit EffectTarget, out array<TTile> AOETiles)
{
	local X2AbilityTemplate AbilityTemplate;
	local XGUnit OwnerVisualizer;
	local XComGameStateHistory History;
	local XComGameState_Ability Ability;

	History = `XCOMHISTORY;

	Ability = XComGameState_Ability(History.GetGameStateForObjectID(EffectSource.FindAbility(AbilityToTrigger).ObjectID));
	if( Ability != None )
	{
		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityToTrigger);
		if( AbilityTemplate != None )
		{
			OwnerVisualizer = XGUnit(History.GetVisualizer(EffectTarget.ObjectID));
			if( OwnerVisualizer != None )
			{
				if( AbilityTemplate.AbilityMultiTargetStyle != None )
				{
					AbilityTemplate.AbilityMultiTargetStyle.GetValidTilesForLocation(Ability, OwnerVisualizer.Location, AOETiles);
				}

				if( AbilityTemplate.AbilityTargetStyle != None )
				{
					AbilityTemplate.AbilityTargetStyle.GetValidTilesForLocation(Ability, OwnerVisualizer.Location, AOETiles);
				}
			}
		}
	}
}

function bool ShouldUseMidpointCameraForTarget(XComGameState_Ability AbilityState, XComGameState_Unit Target)
{
	return true;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Allow
	EffectName = "HomingMine"
	bCanBeRedirected = false
}