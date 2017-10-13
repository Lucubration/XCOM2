class X2Effect_Lucu_CombatEngineer_Skirmisher extends X2Effect_Persistent;

var name SkirmisherGrantsStateName;
var int MaxSkirmisherGrants;
	
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'Lucu_CombatEngineer_SkirmisherTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

// Triggered on the unit after they pay for an ability. If it's an attack against a flanked or uncovered enemy, check the unit state and update action points if necessary
function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory History;
    local X2AbilityTemplate AbilityTemplate;
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;
    local XComGameState_Item SourceItem;
	local UnitValue UnitValue;
	local int SkirmisherGrants;
    local bool IsLaunchSIMONAbility, HasRapidDeploymentActive;
	
	History = `XCOMHISTORY;

    AbilityTemplate = kAbility.GetMyTemplate();
    SourceItem = XComGameState_Item(History.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));

    IsLaunchSIMONAbility = AbilityTemplate.DataName == class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.LaunchSIMONAbilityTemplateName;
    HasRapidDeploymentActive = SourceUnit.AffectedByEffectNames.Find(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.RapidDeploymentEffectName) != INDEX_NONE;
	
    // This only applies to attacks made with the primary or secondary weapon. We specifically discount 'Launch SIMON' if 'Rapid Deployment' is active, which is basically
    // a 'grenade launcher'-style attack using the primary weapon, to prevent unexpected behavior
	if (SourceItem != none && (SourceItem.InventorySlot == eInvSlot_PrimaryWeapon || SourceItem.InventorySlot == eInvSlot_SecondaryWeapon) &&
        (!IsLaunchSIMONAbility || !HasRapidDeploymentActive) &&
        AbilityTemplate.Hostility == eHostility_Offensive)
	{
		//`LOG("Lucubration Combat Engineer Class: Skirmisher 'PostAbilityCostPaid' override called for ability [" @ AbilityTemplate.DataName @ "].");

		// Check if action points were spent
		if (SourceUnit.ActionPoints.Length != PreCostActionPoints.Length)
		{
			// Check if we have already been granted a move by Skirmisher this turn
            SkirmisherGrants = 0;
			if (SourceUnit.GetUnitValue(default.SkirmisherGrantsStateName, UnitValue))
			{
                SkirmisherGrants = UnitValue.fValue;
            }

			if (SkirmisherGrants < default.MaxSkirmisherGrants)
			{
				AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
				if (AbilityState != none)
				{
					// Insert a move action point at the start of the ability points array
					SourceUnit.ActionPoints.Insert(0, 1);
                    SourceUnit.ActionPoints[0] = class'X2CharacterTemplateManager'.default.MoveActionPoint;
				
					SkirmisherGrants++;

					// Set unit value with updated grants
					SourceUnit.SetUnitFloatValue(default.SkirmisherGrantsStateName, SkirmisherGrants, eCleanup_BeginTurn);

					EventMgr = `XEVENTMGR;
					EventMgr.TriggerEvent('Lucu_CombatEngineer_SkirmisherTriggered', AbilityState, SourceUnit, NewGameState);

					`LOG("Lucubration Combat Engineer Class: Skirmisher granted move action point.");

					return true;
				}
				else
				{
					//`LOG("Lucubration Combat Engineer Class: Skirmisher move action point not refunded (unit Skirmisher ability state not found).");
				}
			}
			else
			{
				//`LOG("Lucubration Combat Engineer Class: Skirmisher move action point not refunded (unit exceeded max Skirmisher grants).");
			}
		}
		else
		{
			//`LOG("Lucubration Combat Engineer Class: Skirmisher move action point not refunded (unit spent no action points).");
		}
	}
	else
	{
		//`LOG("Lucubration Combat Engineer Class: Skirmisher move action point not refunded (not an offensive attack ability).");
	}
	return false;
}

DefaultProperties
{
    MaxSkirmisherGrants=1
    SkirmisherGrantsStateName="Lucu_CombatEngineer_SkirmisherGrants"
}