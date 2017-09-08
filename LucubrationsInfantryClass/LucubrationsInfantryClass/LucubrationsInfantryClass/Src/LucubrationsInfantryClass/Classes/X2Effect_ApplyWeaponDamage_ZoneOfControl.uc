// Literally a copy of X2Effect_ApplyWeaponDamage except that I replace the action
class X2Effect_ApplyWeaponDamage_ZoneOfControl extends X2Effect_ApplyWeaponDamage;

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, name EffectApplyResult)
{
	local X2Action_ApplyWeaponDamageToUnit_ZoneOfControl UnitAction;	
	local X2Action_PlaySoundAndFlyOver FlyOverAction;
	local XComGameState_Unit UnitState;
	
	local name EffectName;
	local int x, OverwatchExclusion;
	local bool bRemovedEffect;
	
	if( BuildTrack.StateObject_NewState.IsA('XComGameState_Unit') )
	{	
		//`LOG("Lucubration Infantry Class: Zone of Control X2Effect_ApplyWeaponDamage_ZoneOfControl adding X2Action_ApplyWeaponDamageToUnit_ZoneOfControl visualization to track.");

		UnitAction = X2Action_ApplyWeaponDamageToUnit_ZoneOfControl(class'X2Action_ApplyWeaponDamageToUnit_ZoneOfControl'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
		UnitAction.OriginatingEffect = self;

		if (EffectApplyResult == 'AA_Success')
		{
			UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
			if (XComGameState_Unit(BuildTrack.StateObject_OldState).NumAllReserveActionPoints() > 0 && UnitState.NumAllReserveActionPoints() == 0)
			{
				FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
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
				FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
				FlyOverAction.SetSoundAndFlyOverParameters(none, class'X2AbilityTemplateManager'.static.GetDisplayStringForAvailabilityCode(EffectApplyResult), '', eColor_Bad);
			}
			else
			{
				super.AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, EffectApplyResult);
			}
		}
	}
	else if( BuildTrack.StateObject_NewState.IsA('XComGameState_EnvironmentDamage')
			|| BuildTrack.StateObject_NewState.IsA('XComGameState_Destructible') )
	{
		if(EffectApplyResult == 'AA_Success')
		{
			//All non-unit damage is routed through XComGameState_EnvironmentDamage state objects, which represent an environmental damage event 
			class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext());
		}
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
	local X2Action_CameraLookAt LookAtAction;
	local Actor UnitVisualizer;
	local X2Action_ApplyWeaponDamageToUnit_ZoneOfControl UnitAction;
	local XComGameStateContext_TickEffect TickContext;
	local XComGameState_Effect TickedEffect;

	if( BuildTrack.StateObject_NewState.IsA('XComGameState_Unit') )
	{
		//  cosmetic units should not take damage
		if (XComGameState_Unit(BuildTrack.StateObject_NewState).GetMyTemplate().bIsCosmetic)
			return;
			
		//`LOG("Lucubration Infantry Class: Zone of Control X2Effect_ApplyWeaponDamage_ZoneOfControl adding X2Action_ApplyWeaponDamageToUnit_ZoneOfControl visualization to track.");

		UnitVisualizer = XComGameState_Unit(BuildTrack.StateObject_NewState).GetVisualizer();
		LookAtAction = X2Action_CameraLookAt( class'X2Action_CameraLookAt'.static.CreateVisualizationAction( VisualizeGameState.GetContext(), BuildTrack.TrackActor ));
		LookAtAction.LookAtActor = UnitVisualizer;
		LookAtAction.BlockUntilFinished = true;
		LookAtAction.UseTether = false;
		LookAtAction.LookAtDuration = 0.0f;
		LookAtAction.DesiredCameraPriority = eCameraPriority_GameActions;
		BuildTrack.TrackActions.InsertItem(0, LookAtAction);

		UnitAction = X2Action_ApplyWeaponDamageToUnit_ZoneOfControl(class'X2Action_ApplyWeaponDamageToUnit_ZoneOfControl'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
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

		LookAtAction = X2Action_CameraLookAt( class'X2Action_CameraLookAt'.static.CreateVisualizationAction( VisualizeGameState.GetContext() ));
		LookAtAction.LookAtActor = UnitVisualizer;
		LookAtAction.BlockUntilFinished = true;
		LookAtAction.UseTether = false;
		LookAtAction.LookAtDuration = 2.0f;
		BuildTrack.TrackActions.AddItem(LookAtAction);
	}
	else if( BuildTrack.StateObject_NewState.IsA('XComGameState_EnvironmentDamage')
			|| BuildTrack.StateObject_NewState.IsA('XComGameState_Destructible') )
	{
			//All non-unit damage is routed through XComGameState_EnvironmentDamage state objects, which represent an environmental damage event 
			class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext());
	}
}
