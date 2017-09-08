//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor.
//-----------------------------------------------------------
class X2Action_AbilityPerkEnd extends X2Action;

var private XComGameStateContext_Ability EndingAbility;
var private XComGameStateContext_AuraUpdate UpdatingAura;
var private XGUnit TrackUnit;

var X2Effect_Persistent PersistentPerkEffect;

event bool BlocksAbilityActivation()
{
	return false;
}

function Init()
{
	super.Init();

	EndingAbility = XComGameStateContext_Ability(StateChangeContext);
	UpdatingAura = XComGameStateContext_AuraUpdate(StateChangeContext);
	TrackUnit = XGUnit(Metadata.VisualizeActor);
}

function string SummaryString()
{
	local XComGameState_Effect CurrentEffect;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;

	if (XComGameStateContext_Ability(StateChangeContext) != none)
	{
		return "PerkEnd" @ string(XComGameStateContext_Ability(StateChangeContext).InputContext.AbilityTemplateName);
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

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	simulated event BeginState(Name PreviousStateName)
	{
		local int x;
		local XComUnitPawnNativeBase CasterPawn;
		local array<XComPerkContentInst> Perks;
		local XComPerkContent EffectPerk;
		local XComGameState_Effect CurrentEffect;
		local XComGameState_Ability AbilityState;
		local XComGameStateHistory History;
		local name AbilityName;

		if (PersistentPerkEffect != none)
		{
			CasterPawn = TrackUnit.GetPawn( );

			EffectPerk = class'XComPerkContent'.static.GetPerkDefinition( name(PersistentPerkEffect.PersistentPerkName) );
			if (EffectPerk != none)
			{
				Perks.AddItem( class'XComPerkContent'.static.GetMatchingInstanceForPerk( CasterPawn, EffectPerk, StateChangeContext.AssociatedState.HistoryIndex ) );
			}
		}
		else if (EndingAbility != none)
		{
			CasterPawn = XGUnit( `XCOMHISTORY.GetVisualizer( EndingAbility.InputContext.SourceObject.ObjectID ) ).GetPawn( );

			// deactivate all the perks started by this instance of the ability
			// so we start out with all the perk instances for this ability type
			// and skip all the ones that don't match the history index for this ability activation
			class'XComPerkContent'.static.GetAssociatedPerkInstances( Perks, CasterPawn, EndingAbility.InputContext.AbilityTemplateName, EndingAbility.AssociatedState.HistoryIndex );
		}
		else if (UpdatingAura != none)
		{
			History = `XCOMHISTORY;

			CasterPawn = TrackUnit.GetPawn( );

			// Grab the name of the first one.  AbilityPerkStart already verified that they're all the same
			foreach UpdatingAura.AssociatedState.IterateByClassType(class'XComGameState_Effect', CurrentEffect)
			{
				AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(CurrentEffect.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
				if (AbilityState != none)
				{
					AbilityName = AbilityState.GetMyTemplateName();
					break;
				}
			}

			// deactivate all the perks started by this instance of the ability
			// so we start out with all the perk instances for this ability type
			// and skip all the ones that don't match the history index for this ability activation
			class'XComPerkContent'.static.GetAssociatedPerkInstances( Perks, CasterPawn, AbilityName, UpdatingAura.AssociatedState.HistoryIndex );
		}
		else
		{
			// nothing to actually do here.  AbilityPerkStart already generated a redscreen for this unexpected case
		}

		for (x = 0; x < Perks.Length; ++x)
		{
			Perks[x].OnPerkDeactivation( );
		}

		TrackUnit.CurrentPerkAction = none;
	}

Begin:

	CompleteAction();
}

