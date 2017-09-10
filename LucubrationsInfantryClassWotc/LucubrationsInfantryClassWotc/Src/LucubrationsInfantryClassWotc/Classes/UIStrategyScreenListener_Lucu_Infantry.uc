class UIStrategyScreenListener_Lucu_Infantry extends UIStrategyScreenListener;

event OnInit(UIScreen Screen)
{
    if (IsInStrategy())
    {
		// Try to add the Infantry's GTS perk
		//AddSoldierUnlockTemplate('OfficerTrainingSchool', 'Lucu_Infantry_SteadfastUnlock');
		AddSoldierUnlockTemplate('OfficerTrainingSchool', 'Lucu_Infantry_ExtraConditioningUnlock');

		if (Screen.IsA('UIAfterAction'))
		{
			// When the after action screen gets shown, check for units with Deep Reserves that have wound timers
			ApplyDeepReservesToSquadWoundTimers();
		}

        if (Screen.IsA('UIArmory'))
        {
            // This is not how I wanted to do this, but I need to ensure that retraining, etc, work property with
            // the "Shake it Off!" will bonus

            // I'll store the list of soldiers that currently have the will bonus on an auxiliary HQ state object,
            // then compare soldier abilities against that list and make adjustments during armory screens
            ApplyShakeItOffWillBonus();
        }
	}
}

static function AddSoldierUnlockTemplate(name facilityName, name unlockName)
{
	local X2FacilityTemplate FacilityTemplate;

	// Find the GTS facility template
	FacilityTemplate = X2FacilityTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(facilityName));
	if (FacilityTemplate == none)
	{
		//`LOG("Lucubration Infantry Class: Failed to update " @ facilityName @ " facility template with " @ unlockName @ " (facility template not found).");
		return;
	}

	if (FacilityTemplate.SoldierUnlockTemplates.Find(unlockName) != INDEX_NONE)
	{
		//`LOG("Lucubration Infantry Class: Did not update GTS template with " @ unlockName @ " (already added).");
	}
	else
	{
		// Update the GTS template with the specified soldier unlock
		FacilityTemplate.SoldierUnlockTemplates.AddItem(unlockName);

		`LOG("Lucubration Infantry Class: Updated " @ facilityName @ " template with " @ unlockName @ ".");
	}
}

static function ApplyDeepReservesToSquadWoundTimers()
{
	local XComGameStateHistory							History;
	local XComGameState_HeadquartersXCom				XComHQ;
	local XComGameState_Unit							UnitState;
	local XComGameState_HeadquartersProjectHealSoldier	HealProject;
	local int											i, OldPointsRemaining, NewPointsRemaining;
	local XComGameState									NewGameState;

	`LOG("Lucubration Infantry Class: Performing Deep Reserves after action check.");
	
	History = `XCOMHISTORY;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	for (i = 0; i < XComHQ.Squad.Length; ++i)
	{
		if (XComHQ.Squad[i].ObjectID > 0)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[i].ObjectID));
			// If the unit has Deep Reserves
			if (UnitState.HasSoldierAbility(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.DeepReservesAbilityName))
			{
				foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectHealSoldier', HealProject)
				{
					// If the unit is being healed
					if (HealProject.ProjectFocus == UnitState.GetReference())
					{
						OldPointsRemaining = HealProject.ProjectPointsRemaining;

						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Deep Reserves Wound Timer");
						HealProject = XComGameState_HeadquartersProjectHealSoldier(NewGameState.CreateStateObject(class' XComGameState_HeadquartersProjectHealSoldier', HealProject.ObjectID));
						NewGameState.AddStateObject(HealProject);

						// Halve the total wounded time (maybe we can use the built-in cheat stuff?)
						HealProject.ModifyProjectPointsRemaining(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.DeepReservesWoundPercentToHeal);

						// This seems important
						if (HealProject.MakingProgress())
						{
							HealProject.SetProjectedCompletionDateTime(HealProject.StartDateTime);
						}
						else
						{
							// Set completion time to unreachable future
							HealProject.CompletionDateTime.m_iYear = 9999;
							HealProject.BlockCompletionDateTime.m_iYear = 9999;
						}

						NewPointsRemaining = HealProject.ProjectPointsRemaining;

						`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

						`LOG("Lucubration Infantry Class: Applied Deep Reserves wound time reduction to unit " @ UnitState.GetFullName() @ " (from " @ OldPointsRemaining @ " to " @ NewPointsRemaining @ ").");
					}
					else
					{
						//`LOG("Lucubration Infantry Class: Deep Reserves after action not applied to unit " @ UnitState.GetFullName() @ " (unit not wounded).");
					}
				}
			}
			else
			{
				//`LOG("Lucubration Infantry Class: Deep Reserves after action not applied to unit " @ UnitState.GetFullName() @ " (not a Deep Reserves unit).");
			}
		}
		else
		{
			//`LOG("Lucubration Infantry Class: Deep Reserves after action not applied to unit at " @ string(i) @ " (empty spot).");
		}
	}
}

static function XComGameState_Lucu_Infantry_HQ GetAuxiliaryHQ(XComGameState_HeadquartersXCom XComHQ)
{
    local XComGameState_Lucu_Infantry_HQ                AuxHQ;
	local XComGameState									NewGameState;

	`LOG("Lucubration Infantry Class: Performing auxiliary HQ check.");

    // To begin with, check for the auxiliary HQ state object
    AuxHQ = XComGameState_Lucu_Infantry_HQ(XComHQ.FindComponentObject(class'XComGameState_Lucu_Infantry_HQ'));
    if (AuxHQ == none)
    {
        `LOG("Lucubration Infantry Class: Creating Shake it Off auxiliary HQ object.");

        // Create the auxiliary HQ state object
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Auxiliary HQ");
		AuxHQ = XComGameState_Lucu_Infantry_HQ(NewGameState.CreateStateObject(class' XComGameState_Lucu_Infantry_HQ'));
		XComHQ.AddComponentObject(AuxHQ);
		NewGameState.AddStateObject(AuxHQ);

		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
    }

    return AuxHQ;
}

static function ApplyShakeItOffWillBonus()
{
	local XComGameStateHistory							History;
	local XComGameState_HeadquartersXCom				XComHQ;
    local XComGameState_Lucu_Infantry_HQ                AuxHQ;
	local XComGameState_Unit							UnitState;
    local StateObjectReference                          UnitRef;
	local XComGameState									NewGameState;
	local int											i, OldMax, OldCurr, NewMax, NewCurr;

	`LOG("Lucubration Infantry Class: Performing Shake it Off will bonus check.");
	
	History = `XCOMHISTORY;
    
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
    AuxHQ = GetAuxiliaryHQ(XComHQ);
    
    for (i = 0; i < XComHQ.Squad.Length; ++i)
    {
        if (XComHQ.Squad[i].ObjectID > 0)
        {
            UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[i].ObjectID));
            UnitRef = UnitState.GetReference();

            if (UnitState.HasSoldierAbility(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ShakeItOffAbilityName))
            {
                if (!AuxHQ.HasShakeItOffWillBonus(UnitRef))
                {
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Shake it Off Will Bonus");
					UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
                    OldMax = UnitState.GetBaseStat(eStat_Will);
                    OldCurr = UnitState.GetCurrentStat(eStat_Will);
                    NewMax = OldMax + class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ShakeItOffWillBonus;
                    NewCurr = OldCurr + class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ShakeItOffWillBonus;
                    UnitState.SetBaseMaxStat(eStat_Will, NewMax);
                    UnitState.SetCurrentStat(eStat_Will, NewCurr);
					NewGameState.AddStateObject(UnitState);

                    AuxHQ = XComGameState_Lucu_Infantry_HQ(NewGameState.CreateStateObject(class'XComGameState_Lucu_Infantry_HQ', AuxHQ.ObjectID));
                    AuxHQ.AddHasShakeItOffWillBonus(UnitRef);
					NewGameState.AddStateObject(AuxHQ);

					`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

					`LOG("Lucubration Infantry Class: Added Shake it Off will bonus to unit " @ UnitState.GetFullName() @ " (from " @ OldCurr @ "/" @ OldMax @ " to " @ NewCurr @ "/" @ NewMax @ ").");
                }
            }
            else
            {
                if (AuxHQ.HasShakeItOffWillBonus(UnitRef))
                {
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Shake it Off Will Bonus");
					UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
                    OldMax = UnitState.GetBaseStat(eStat_Will);
                    OldCurr = UnitState.GetCurrentStat(eStat_Will);
                    NewMax = OldMax - class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ShakeItOffWillBonus;
                    NewCurr = OldCurr - class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ShakeItOffWillBonus;
                    UnitState.SetBaseMaxStat(eStat_Will, NewMax);
                    UnitState.SetCurrentStat(eStat_Will, NewCurr);
					NewGameState.AddStateObject(UnitState);

                    AuxHQ = XComGameState_Lucu_Infantry_HQ(NewGameState.CreateStateObject(class'XComGameState_Lucu_Infantry_HQ', AuxHQ.ObjectID));
                    AuxHQ.RemoveHasShakeItOffWillBonus(UnitRef);
					NewGameState.AddStateObject(AuxHQ);

					`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

					`LOG("Lucubration Infantry Class: Removed Shake it Off will bonus from unit " @ UnitState.GetFullName() @ " (from " @ OldCurr @ "/" @ OldMax @ " to " @ NewCurr @ "/" @ NewMax @ ").");
                }
            }
        }
    }
}
