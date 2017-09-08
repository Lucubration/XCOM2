class X2Effect_Aura extends X2Effect_Persistent;

var Array<Name> EventsToUpdate;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;
	local int ScanEvents;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'UnitMoveFinished', class'XComGameState_Effect'.static.AuraUpdateSingleTarget, ELD_OnStateSubmitted);

	for( ScanEvents = 0; ScanEvents < EventsToUpdate.Length; ++ScanEvents )
	{
		EventMgr.RegisterForEvent(EffectObj, EventsToUpdate[ScanEvents], class'XComGameState_Effect'.static.AuraUpdateSingleTarget, ELD_OnStateSubmitted);
	}
}

simulated function RemoveAllTargets(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed)
{
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnit;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Effect CurrentEffect;
	local int i;

	History = `XCOMHISTORY;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	if( AbilityState != None )
	{
		AbilityTemplate = AbilityState.GetMyTemplate();
		foreach History.IterateByClassType(class'XComGameState_Unit', TargetUnit)
		{
			for( i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i )
			{
				// Add/remove multi target effect
				CurrentEffect = TargetUnit.GetUnitAffectedByEffectState(X2Effect_Persistent(AbilityTemplate.AbilityMultiTargetEffects[i]).EffectName);
				if( CurrentEffect != None && CurrentEffect.ApplyEffectParameters.SourceStateObjectRef == ApplyEffectParameters.SourceStateObjectRef )
				{
					CurrentEffect.RemoveEffect(NewGameState, NewGameState);
				}
			}
		}
	}
}

function UpdateSingleTarget(const out EffectAppliedData ApplyEffectParameters, XComGameState_Unit TargetUnit, XComGameState NewGameState)
{
	local XComGameState_Effect CurrentEffect;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_BaseObject NewTargetState;
	local bool bAddStateObject;
	local int i;
	local Name EffectAttachmentResult;
	local EffectAppliedData NewApplyEffectParameters;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	if( AbilityState != None )
	{
		AbilityTemplate = AbilityState.GetMyTemplate();

		NewTargetState = NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID);

		bAddStateObject = false;

		NewApplyEffectParameters = ApplyEffectParameters;
		NewApplyEffectParameters.EffectRef.LookupType = TELT_AbilityMultiTargetEffects;
		NewApplyEffectParameters.TargetStateObjectRef = TargetUnit.GetReference();

		for( i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i )
		{
			NewApplyEffectParameters.EffectRef.TemplateEffectLookupArrayIndex = i;
			EffectAttachmentResult = AbilityTemplate.AbilityMultiTargetEffects[i].ApplyEffect(NewApplyEffectParameters, NewTargetState, NewGameState);

			if( EffectAttachmentResult != 'AA_Success' && EffectAttachmentResult != 'AA_DuplicateEffectIgnored' && EffectAttachmentResult != 'AA_EffectRefreshed' )
			{
				// Remove the effect
				CurrentEffect = TargetUnit.GetUnitAffectedByEffectState(X2Effect_Persistent(AbilityTemplate.AbilityMultiTargetEffects[i]).EffectName);
				if( CurrentEffect != None && CurrentEffect.ApplyEffectParameters.SourceStateObjectRef == ApplyEffectParameters.SourceStateObjectRef )
				{
					CurrentEffect.RemoveEffect(NewGameState, NewGameState);
					bAddStateObject = true;
				}
			}

			// If it didn't attach, now check to see if the effect is already attached
			bAddStateObject = bAddStateObject || (EffectAttachmentResult == 'AA_Success');
		}
	}

	if( !bAddStateObject )
	{
		NewGameState.PurgeGameStateForObjectID(NewTargetState.ObjectID);
	}
}



DefaultProperties
{
	DuplicateResponse=eDupe_Ignore
	EffectRemovedFn=RemoveAllTargets
}