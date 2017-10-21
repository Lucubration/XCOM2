class X2Effect_DLC_Day60DecrementEffectCounter extends X2Effect_RemoveEffects;


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Effect EffectState;
	local int CurrentEventChainStartIndex;
	local name EffectName;
	local int i;
	local XComGameState_Player ActivePlayer;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState == none)
	{
		return;
	}

	// store this off so we don't need to read it every time through the loop below
	CurrentEventChainStartIndex = `XCOMHISTORY.GetEventChainStartIndex();
	ActivePlayer = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID));

	foreach EffectNamesToRemove(EffectName)
	{
		EffectState = UnitState.GetUnitAffectedByEffectState(EffectName);
		if( EffectState != None )
		{
			if( EffectName == class'X2AbilityTemplateManager'.default.StunnedName )
			{
				if( UnitState.StunnedActionPoints > 1 )
				{
					--UnitState.StunnedActionPoints;
				}
				else
				{
					UnitState.StunnedActionPoints = 0;
					for( i = 0; i < UnitState.StunnedThisTurn; ++i )
					{
						UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
					}
					UnitState.StunnedThisTurn = 0;
					EffectState = UnitState.GetUnitAffectedByEffectState(class'X2AbilityTemplateManager'.default.StunnedName);
					if( EffectState != None )
					{
						EffectState.RemoveEffect(NewGameState, NewGameState);
					}
				}
			}
			else
			{
				// only tick effects that were not just applied (i.e., part of the same event chain)
				if(CurrentEventChainStartIndex != EffectState.GetParentGameState().GetContext().EventChainStartIndex)
				{
					if( !EffectState.TickEffect(NewGameState, false, ActivePlayer) )
					{
						EffectState.RemoveEffect(NewGameState, NewGameState);
					}
				}
			}
		}
	}
}


simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent Effect;
	local int TickIndex;

	if (EffectApplyResult != 'AA_Success')
		return;

	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
	TickIndex = 0;

	//  The base class will do removal visualization, we just need to handle ticks
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		Effect = EffectState.GetX2Effect();
		if (!EffectState.bRemoved 
			&& EffectNamesToRemove.Find(Effect.EffectName) != INDEX_NONE
			&& EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ActionMetadata.StateObject_NewState.ObjectID)
		{
			Effect.AddX2ActionsForVisualization_Tick(VisualizeGameState, ActionMetadata, TickIndex++, EffectState);
		}
	}
}
