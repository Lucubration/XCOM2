//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor.
//-----------------------------------------------------------
class X2Action_AbilityPerkStart extends X2Action
	dependson(XComPerkContentInst)
	native(Unit);

var privatewrite XComGameStateContext_Ability StartingAbility;
var privatewrite XComGameStateContext_AuraUpdate UpdatingAura;
var X2Effect_Persistent PersistentPerkEffect;

var private XGUnit CasterUnit;
var private name AbilityName;

var private XGUnit TrackUnit;

var bool NotifyTargetTracks;
var bool TrackHasNoFireAction;

var privatewrite bool NeedsDelay;
var private bool ImpactNotified;

function Init()
{
	local XComGameState_Effect CurrentEffect;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;

	super.Init();

	TrackUnit = XGUnit(Metadata.VisualizeActor);
	CasterUnit = TrackUnit;

	StartingAbility = XComGameStateContext_Ability(StateChangeContext);
	UpdatingAura = XComGameStateContext_AuraUpdate(StateChangeContext);

	if (StartingAbility != none)
	{
		CasterUnit = XGUnit( `XCOMHISTORY.GetVisualizer( StartingAbility.InputContext.SourceObject.ObjectID ) );
		AbilityName = StartingAbility.InputContext.AbilityTemplateName;
	}
	else if (UpdatingAura != none)
	{

		History = `XCOMHISTORY;

		foreach UpdatingAura.AssociatedState.IterateByClassType(class'XComGameState_Effect', CurrentEffect)
		{
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(CurrentEffect.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			if (AbilityState != none)
			{
				// the first ability we see is okay, and all the others should be the same ability
				`assert( (AbilityName == '') || (AbilityName == AbilityState.GetMyTemplateName()) );
				AbilityName = AbilityState.GetMyTemplateName( );
			}
		}
	}
}

event bool BlocksAbilityActivation()
{
	return false;
}

event string GetAbilityName( )
{
	return string(AbilityName);
}

function string SummaryString()
{
	local XComGameState_Effect CurrentEffect;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;

	if (XComGameStateContext_Ability(StateChangeContext) != none)
	{
		return "PerkStart" @ string(XComGameStateContext_Ability(StateChangeContext).InputContext.AbilityTemplateName);
	}
	else if (XComGameStateContext_AuraUpdate(StateChangeContext) != none)
	{

		History = `XCOMHISTORY;

		foreach XComGameStateContext_AuraUpdate(StateChangeContext).AssociatedState.IterateByClassType(class'XComGameState_Effect', CurrentEffect)
		{
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(CurrentEffect.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			if (AbilityState != none)
			{
				return "PerkStart" @ string(AbilityState.GetMyTemplateName());
			}
		}

	}
	else if (PersistentPerkEffect != none)
	{
		return "PerkEnd" @ PersistentPerkEffect.PersistentPerkName;
	}

	return "PerkEnd ???";
}

function NotifyTargetsAbilityApplied( )
{
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState VisualizeGameState;

	if ((StartingAbility != none) && (StartingAbility.InputContext.PrimaryTarget.ObjectID > 0 || StartingAbility.InputContext.MultiTargets.Length > 0))
	{
		`XEVENTMGR.TriggerEvent('Visualizer_AbilityHit', self, self);
	}
	else if (UpdatingAura != none)
	{
		`XEVENTMGR.TriggerEvent('Visualizer_AbilityHit', self, self);
	}

	VisualizeGameState = StateChangeContext.AssociatedState;
	foreach VisualizeGameState.IterateByClassType( class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent )
	{
		`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamageEvent, self);
	}
}

function NotifyPerkStart( AnimNotify_PerkStart Notify )
{
	local int x, t, e, EffectIndex;
	local XComUnitPawnNativeBase CasterPawn;
	local XComGameState_Unit TargetState;
	local array<XGUnit> Targets, SuccessTargets;
	local array<EffectResults> TargetEffectResults, SuccessTargetEffectResults;
	local array<XComPerkContent> Perks;
	local EffectResults EffectApplicationResults;
	local X2Effect_Persistent TargetEffect;
	local name EffectResult;
	local int CasterInTargetsIndex;
	local WorldInfo WInfo;
	local XComPerkContentInst PerkInstance;
	local PerkActivationData ActivationData;
	local XComGameStateHistory History;
	local XComPerkContent EffectPerk;
	local XComGameState_Effect CurrentEffect;
	local X2Effect EffectToVisualize;

	WInfo = class'WorldInfo'.static.GetWorldInfo();
	History = `XCOMHISTORY;

	if( Notify != none && NotifyTargetTracks )
	{
		NotifyTargetsAbilityApplied( );
	}

	if (PersistentPerkEffect != none)
	{
		Targets.AddItem( TrackUnit );
		TargetEffectResults.Length = TargetEffectResults.Length + 1;

		TargetEffectResults[0].Effects.AddItem( PersistentPerkEffect );
		TargetEffectResults[0].ApplyResults.AddItem( 'AA_Success' );

		CasterPawn = CasterUnit.GetPawn();

		EffectPerk = class'XComPerkContent'.static.GetPerkDefinition( name(PersistentPerkEffect.PersistentPerkName) );
		if (EffectPerk != none)
			Perks.AddItem( EffectPerk );
	}
	else if (StartingAbility != none)
	{
		TargetState = XComGameState_Unit( History.GetGameStateForObjectID( StartingAbility.InputContext.PrimaryTarget.ObjectID ) );
		if (TargetState != none)
		{
			Targets.AddItem( XGUnit( TargetState.GetVisualizer( ) ) );
			TargetEffectResults.AddItem( StartingAbility.ResultContext.TargetEffectResults );
		}
		for (x = 0; x < StartingAbility.InputContext.MultiTargets.Length; ++x)
		{
			TargetState = XComGameState_Unit( History.GetGameStateForObjectID( StartingAbility.InputContext.MultiTargets[ x ].ObjectID ) );
			if (TargetState != none)
			{
				Targets.AddItem( XGUnit( TargetState.GetVisualizer( ) ) );
				TargetEffectResults.AddItem( StartingAbility.ResultContext.MultiTargetEffectResults[x] );
			}
		}

		CasterUnit = XGUnit( History.GetVisualizer( StartingAbility.InputContext.SourceObject.ObjectID ) );
		CasterPawn = CasterUnit.GetPawn();

		class'XComPerkContent'.static.GetAssociatedPerkDefinitions( Perks, CasterPawn, StartingAbility.InputContext.AbilityTemplateName );
	}
	else if (UpdatingAura != none)
	{
		foreach UpdatingAura.AssociatedState.IterateByClassType(class'XComGameState_Effect', CurrentEffect)
		{
			EffectToVisualize = CurrentEffect.GetX2Effect();
			TargetState = XComGameState_Unit( History.GetGameStateForObjectID(CurrentEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID) );

			if (TargetState != none)
			{
				Targets.AddItem( XGUnit( TargetState.GetVisualizer( ) ) );

				TargetEffectResults.Add(1);
				TargetEffectResults[TargetEffectResults.Length - 1].Effects.AddItem( EffectToVisualize );
				TargetEffectResults[TargetEffectResults.Length - 1].ApplyResults.AddItem( 'AA_Success' ); // We know the apply result was success
			}
		}

		CasterPawn = CasterUnit.GetPawn();
		class'XComPerkContent'.static.GetAssociatedPerkDefinitions( Perks, CasterPawn, AbilityName );
	}
	else
	{
		`redscreen( "X2Action_AbilityPerkStart: Starting an action when no perk configuration information provided" );
	}

	CasterInTargetsIndex = Targets.Find(CasterUnit);

	ActivationData.GameStateHistoryIndex = StateChangeContext.AssociatedState.HistoryIndex;

	for (x = 0; x < Perks.Length; ++x)
	{
		// make sure that the way we're supposed to activate this perk (with a notify or not) matches with how we're actually being triggered
		// (with a notify or not)
		if (Perks[x].ActivatesWithAnimNotify != (Notify != none))
		{
			continue;
		}

		class'XComPerkContent'.static.ResetActivationData( ActivationData );

		SuccessTargets = Targets;
		SuccessTargetEffectResults = TargetEffectResults;

		if (StartingAbility != none)
			ActivationData.TargetLocations = StartingAbility.InputContext.TargetLocations;

		if (Perks[x].IgnoreCasterAsTarget && (CasterInTargetsIndex != INDEX_NONE))
		{
			// Remove the source if it is supposed to be ignored
			SuccessTargets.Remove(CasterInTargetsIndex, 1);
			SuccessTargetEffectResults.Remove(CasterInTargetsIndex, 1);
		}

		// if we part of an effect that is applied to the target(s), see if that effect was actually applied succesefully.
		if (Perks[x].AssociatedEffect != '')
		{
			if (StartingAbility != none)
			{
				TargetState = XComGameState_Unit( History.GetGameStateForObjectID( StartingAbility.InputContext.SourceObject.ObjectID, , ActivationData.GameStateHistoryIndex ) );
				if (TargetState == none)
				{
					TargetState = XComGameState_Unit( History.GetGameStateForObjectID( StartingAbility.InputContext.SourceObject.ObjectID ) );
				}

				for (EffectIndex = 0; EffectIndex < StartingAbility.ResultContext.ShooterEffectResults.Effects.Length; ++EffectIndex)
				{
					TargetEffect = X2Effect_Persistent(StartingAbility.ResultContext.ShooterEffectResults.Effects[EffectIndex]);

					if ((TargetEffect != none) &&
						(TargetEffect.EffectName == Perks[x].AssociatedEffect) &&
						(StartingAbility.ResultContext.ShooterEffectResults.ApplyResults[EffectIndex] == 'AA_Success'))
					{
						t = TargetState.AffectedByEffectNames.Find( TargetEffect.EffectName );
						if( t == INDEX_NONE )
						{
							`log("X2Action_AbilityPerkStart:NotifyPerkStart: Could not find valid index: " $ string(TargetEffect.EffectName));
							`assert(false);
						}

						ActivationData.ShooterEffect = TargetState.AffectedByEffects[ t ];
						break;
					}
				}
			}

			if (SuccessTargets.Length > 0)
			{
				for (t = 0; t < SuccessTargets.Length ; ++t)
				{
					TargetState = XComGameState_Unit( History.GetGameStateForObjectID( SuccessTargets[t].ObjectID, , ActivationData.GameStateHistoryIndex ) );
					if (TargetState == none)
					{
						TargetState = XComGameState_Unit( History.GetGameStateForObjectID( SuccessTargets[t].ObjectID ) );
					}

					EffectApplicationResults = SuccessTargetEffectResults[ t ];

					for (e = 0; e < EffectApplicationResults.Effects.Length; ++e)
					{
						TargetEffect = X2Effect_Persistent( EffectApplicationResults.Effects[ e ] );
						EffectResult = EffectApplicationResults.ApplyResults[ e ];

						if ((TargetEffect != none) && ((TargetEffect.EffectName == Perks[ x ].AssociatedEffect) || (PersistentPerkEffect != none)) && (EffectResult == 'AA_Success'))
						{
							ActivationData.TargetUnits.AddItem( SuccessTargets[ t ] );

							EffectIndex = TargetState.AffectedByEffectNames.Find( TargetEffect.EffectName );
							if (EffectIndex != INDEX_NONE)
								ActivationData.TargetEffects.AddItem( TargetState.AffectedByEffects[ EffectIndex ] );
							else
								ActivationData.TargetEffects.Length = ActivationData.TargetEffects.Length + 1;

							break;
						}
					}
				}
			}

			if ((ActivationData.ShooterEffect.ObjectID <= 0) && (SuccessTargets.Length > 0) && (ActivationData.TargetUnits.Length == 0))
			{
				// if there are no successful targets, then we shouldn't start this perk
				continue;
			}
		}
		else
		{
			ActivationData.TargetUnits = SuccessTargets;
		}

		PerkInstance = WInfo.Spawn( class'XComPerkContentInst' );
		PerkInstance.Init( Perks[x], CasterPawn, TrackUnit.GetPawn( ) );

		PerkInstance.OnPerkActivation( ActivationData );
	}
}

function XComWeapon GetPerkWeapon( )
{
	local XComUnitPawnNativeBase CasterPawn;
	local array<XComPerkContentInst> Perks;
	local int x;
	local XComWeapon Weapon;

	CasterPawn = CasterUnit.GetPawn( );

	class'XComPerkContent'.static.GetAssociatedPerkInstances( Perks, CasterPawn, AbilityName, StateChangeContext.AssociatedState.HistoryIndex );

	for (x = 0; x < Perks.Length; ++x)
	{
		// if the perk isn't in one of the active states, we probably didn't pass the targets filter in NotifyPerkStart
		if (Perks[x].IsInState( 'ActionActive' ))
		{
			Weapon = Perks[x].GetPerkWeapon( );
			if (Weapon != none)
			{
				return Weapon;
			}
		}
	}

	return none;
}

// Trigger the OnTargetDamage effects during the activation window of the ability for the specified pawn.
function TriggerActivationDamageEffects( XComUnitPawnNativeBase TargetPawn )
{
	local XComUnitPawnNativeBase CasterPawn;
	local array<XComPerkContentInst> Perks;
	local int x;

	CasterPawn = CasterUnit.GetPawn( );

	class'XComPerkContent'.static.GetAssociatedPerkInstances( Perks, CasterPawn, AbilityName, StateChangeContext.AssociatedState.HistoryIndex );

	for (x = 0; x < Perks.Length; ++x)
	{
		// if the perk isn't in one of the active states, we probably didn't pass the targets filter in NotifyPerkStart
		// also we only want to play the target damage effects for non-durational perks.  Durational perks expect these effects to be
		// played on subsequent damage and not during damage from the source ability.
		if (Perks[x].IsInState( 'ActionActive' ) && Perks[x].m_PerkData.AssociatedEffect == '')
		{
			Perks[x].OnDamage( TargetPawn );
		}
	}
}

function TriggerImpact( )
{
	local int x;
	local XComUnitPawnNativeBase CasterPawn;
	local array<XComPerkContentInst> Perks;

	CasterPawn = CasterUnit.GetPawn( );

	class'XComPerkContent'.static.GetAssociatedPerkInstances( Perks, CasterPawn, AbilityName, StateChangeContext.AssociatedState.HistoryIndex );
	for (x = 0; x < Perks.Length; ++x)
	{
		Perks[ x ].TriggerImpact( );
	}
	ImpactNotified = true;
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	simulated event BeginState(Name PreviousStateName)
	{
		local int x;
		local XComUnitPawnNativeBase CasterPawn;
		local array<XComPerkContent> Perks;

		CasterPawn = CasterUnit.GetPawn( );
		TrackUnit.CurrentPerkAction = self;
		class'XComPerkContent'.static.GetAssociatedPerkDefinitions( Perks, CasterPawn, AbilityName );
		for (x = 0; x < Perks.Length; ++x)
		{
			if (Perks[x].ManualFireNotify)
			{
				NeedsDelay = true;
				break;
			}
		}

		NotifyPerkStart( none );
	}

Begin:
	//Run at full speed if we are interrupting
	VisualizationMgr.SetInterruptionSloMoFactor(Unit, 1.0f);

	if (NeedsDelay && TrackHasNoFireAction)
	{
		while (!ImpactNotified && !IsTimedOut( ))
			Sleep( 0.0f );
	}

	CompleteAction();
}

DefaultProperties
{
}