// Literally a copy of X2Effect_ApplyWeaponDamage except that I replace the action
class X2Effect_Lucu_Infantry_ApplyWeaponDamage_ZoneOfControl extends X2Effect_ApplyWeaponDamage;

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_Lucu_Infantry_ApplyWeaponDamageToUnit_ZoneOfControl UnitAction;	
	local X2Action_PlaySoundAndFlyOver FlyOverAction;
	local XComGameState_Unit UnitState;
	
	local name EffectName;
	local int x, OverwatchExclusion;
	local bool bRemovedEffect;
	
	if (ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
	{	
		//`LOG("Lucubration Infantry Class: Zone of Control X2Effect_Lucu_Infantry_ApplyWeaponDamage_ZoneOfControl adding X2Action_ApplyWeaponDamageToUnit_ZoneOfControl visualization to tree.");

		UnitAction = X2Action_Lucu_Infantry_ApplyWeaponDamageToUnit_ZoneOfControl(class'X2Action_Lucu_Infantry_ApplyWeaponDamageToUnit_ZoneOfControl'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));//auto-parent to damage initiating action
		UnitAction.OriginatingEffect = self;

		if (EffectApplyResult == 'AA_Success')
		{
			UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
			if (XComGameState_Unit(ActionMetadata.StateObject_OldState).NumAllReserveActionPoints() > 0 && UnitState.NumAllReserveActionPoints() == 0)
			{
				FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
				bRemovedEffect = false;
				for (x = 0; x < UnitState.AppliedEffects.Length; ++x)
				{
					EffectName = UnitState.AppliedEffectNames[x];

					if (EffectName == class'X2Effect_Suppression'.default.EffectName)
					{
						FlyOverAction.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.SuppressionRemovedMsg, '', eColor_Bad);
						bRemovedEffect = true;
					}
				}

				if (!bRemovedEffect)
				{
					FlyOverAction.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
				}
			}
		}
		else
		{
			OverwatchExclusion = class'X2Ability_DefaultAbilitySet'.default.OverwatchExcludeReasons.Find(EffectApplyResult);
			if (OverwatchExclusion != INDEX_NONE)
			{
				FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
				FlyOverAction.SetSoundAndFlyOverParameters(none, class'X2AbilityTemplateManager'.static.GetDisplayStringForAvailabilityCode(EffectApplyResult), '', eColor_Bad);
			}
			else
			{
				super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
			}
		}
	}
	else if( ActionMetadata.StateObject_NewState.IsA('XComGameState_EnvironmentDamage')
			|| ActionMetadata.StateObject_NewState.IsA('XComGameState_Destructible') )
	{
		if(EffectApplyResult == 'AA_Success')
		{
			//All non-unit damage is routed through XComGameState_EnvironmentDamage state objects, which represent an environmental damage event
			//It is expected that LastActionAdded will be none (causing the action to be autoparented) in most cases.
			//However we pass it in so that when building visualizations, callers can get the action parented to the right thing if they need it to be.
			class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), , ActionMetadata.LastActionAdded );
		}
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	local X2Action_CameraLookAt LookAtAction;
	local X2Action_Delay DelayAction;
	local Actor UnitVisualizer;
	local X2Action_Lucu_Infantry_ApplyWeaponDamageToUnit_ZoneOfControl UnitAction;
	local XComGameStateContext_TickEffect TickContext;
	local XComGameState_Effect TickedEffect;

	if( ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit') )
	{
		//  cosmetic units should not take damage
		if (XComGameState_Unit(ActionMetadata.StateObject_NewState).GetMyTemplate().bIsCosmetic)
			return;

		UnitVisualizer = XComGameState_Unit(ActionMetadata.StateObject_NewState).GetVisualizer();
		LookAtAction = X2Action_CameraLookAt( class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		LookAtAction.LookAtActor = UnitVisualizer;
		LookAtAction.BlockUntilActorOnScreen = true;
		LookAtAction.UseTether = false;
		LookAtAction.LookAtDuration = 2.0f;
		LookAtAction.DesiredCameraPriority = eCameraPriority_GameActions;

		UnitAction = X2Action_Lucu_Infantry_ApplyWeaponDamageToUnit_ZoneOfControl(class'X2Action_Lucu_Infantry_ApplyWeaponDamageToUnit_ZoneOfControl'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));//auto-parent to damage initiating action
		UnitAction.TickIndex = TickIndex;

		UnitAction.OriginatingEffect = self;

		//The "ancestor effect" for the weapon damage action should be the ticking effect that caused us.
		//This is needed to correctly identify the damage event to use.
		TickContext = XComGameStateContext_TickEffect(VisualizeGameState.GetContext());
		if (TickContext != None && TickContext.TickedEffect.ObjectID != 0)
		{
			TickedEffect = XComGameState_Effect(VisualizeGameState.GetGameStateForObjectID(TickContext.TickedEffect.ObjectID));
			if (TickedEffect != None)
				UnitAction.AncestorEffect = TickedEffect.GetX2Effect();
		}

		// the camera action is not longer blocking (but will hang out for a short duration), so add a delay function to 
		// prevent further visualization from occuring
		DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		DelayAction.Duration = LookAtAction.LookAtDuration;
	}
	else if( ActionMetadata.StateObject_NewState.IsA('XComGameState_EnvironmentDamage')
			|| ActionMetadata.StateObject_NewState.IsA('XComGameState_Destructible') )
	{
			//All non-unit damage is routed through XComGameState_EnvironmentDamage state objects, which represent an environmental damage event 
			class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext());//auto-parent to damage initiating action
	}
}
