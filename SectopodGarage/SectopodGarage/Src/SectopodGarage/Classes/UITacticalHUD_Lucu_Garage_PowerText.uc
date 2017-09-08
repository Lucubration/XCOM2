class UITacticalHUD_Lucu_Garage_PowerText extends UIText;

var localized string PowerTitle;

var int LastActiveUnit, LastPlayerID;

// Pseudo-Ctor
simulated function UITacticalHUD_Lucu_Garage_PowerText InitPower()
{
	InitText('');
	SetColor("0x00ff00");
	SetAnchor(class'UIUtilities'.const.ANCHOR_BOTTOM_RIGHT);
	SetPosition(-500, -200);
	Hide();

	return self;
}

simulated function OnInit()
{
	super.OnInit();
}

simulated event Tick(float TimeDelta)
{
	local XComGameStateHistory History;
	local X2TacticalGameRuleset RuleSet;
	local XGPlayer CurrentPlayer;
	local XGUnit ActiveUnit;
	local XComGameState_Unit ActiveUnitState;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	
	RuleSet = `TACTICALRULES;
	History = `XCOMHISTORY;

	CurrentPlayer = XGPlayer(History.GetVisualizer(RuleSet.GetCachedUnitActionPlayerRef().ObjectID));
	ActiveUnit = XComTacticalController(PC).GetActiveUnit();
	if (ActiveUnit != none && CurrentPlayer == ActiveUnit.GetPlayer())
	{
		ActiveUnitState = ActiveUnit.GetVisualizedGameState();
		Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(ActiveUnitState);
		if (LastActiveUnit != ActiveUnitState.ObjectID || LastPlayerID != CurrentPlayer.ObjectID)
		{
			if (Xtopod == none)
			{
				Hide();

				`LOG("Xtopod Garage: Power screen hidden.");
			}
			else
			{
				Show();
				
				`LOG("Xtopod Garage: Power screen shown at " @ string(self.X) @ "," @ string(self.Y) @ ".");
			}

			LastActiveUnit = ActiveUnitState.ObjectID;
		}
		
		if (Xtopod != none)
			SetPower(Xtopod);
	}
	else if (LastActiveUnit != 0)
	{
		LastActiveUnit = 0;

		Hide();
		
		`LOG("Xtopod Garage: Power screen hidden.");
	}

	LastPlayerID = CurrentPlayer.ObjectID;
}

simulated function SetPower(XComGameState_Lucu_Garage_XtopodUnitState Xtopod)
{
	local int PowerCost;

	PowerCost = GetPotentialPowerCost();

	if (PowerCost > 0)
		SetText(PowerTitle $ ":" @ string(Xtopod.PowerCurrent) @ "(-" $ string(PowerCost) $ ")/" @ string(Xtopod.PowerMax));
	else
		SetText(PowerTitle $ ":" @ string(Xtopod.PowerCurrent) @ "/" @ string(Xtopod.PowerMax));

	Show();
}

simulated function float GetPotentialPowerCost()
{
	local X2AbilityCost AbilityCost;
	local AvailableAction SelectedAction;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate; 

	SelectedAction = UITacticalHUD(screen).m_kAbilityHUD.GetSelectedAction();
	
	// -1 or 0 means an invalid ObjectID
	if (SelectedAction.AbilityObjectRef.ObjectID > 0)
	{
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SelectedAction.AbilityObjectRef.ObjectID));
	
		AbilityTemplate = AbilityState.GetMyTemplate();
		foreach AbilityTemplate.AbilityCosts(AbilityCost)
		{
			if (AbilityCost.IsA('X2AbilityCost_Lucu_Garage_Power'))
			{
				return X2AbilityCost_Lucu_Garage_Power(AbilityCost).Amount;
			}
		}
	}
	return -1;
}
