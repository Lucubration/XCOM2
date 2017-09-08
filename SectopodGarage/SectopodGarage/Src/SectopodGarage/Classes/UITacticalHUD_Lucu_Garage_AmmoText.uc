class UITacticalHUD_Lucu_Garage_AmmoText extends UIText;

var localized string AmmoTitle;

var int LastActiveUnit, LastPlayerID;

// Pseudo-Ctor
simulated function UITacticalHUD_Lucu_Garage_AmmoText InitAmmo()
{
	InitText('');
	SetColor("0x00ffff");
	SetAnchor(class'UIUtilities'.const.ANCHOR_BOTTOM_RIGHT);
	SetPosition(-500, -230);
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
	local bool InfiniteAmmo;
	
	RuleSet = `TACTICALRULES;
	History = `XCOMHISTORY;

	CurrentPlayer = XGPlayer(History.GetVisualizer(RuleSet.GetCachedUnitActionPlayerRef().ObjectID));
	ActiveUnit = XComTacticalController(PC).GetActiveUnit();
	if (ActiveUnit != none && CurrentPlayer == ActiveUnit.GetPlayer())
	{
		ActiveUnitState = ActiveUnit.GetVisualizedGameState();
		Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(ActiveUnitState);
		InfiniteAmmo = ActiveUnitState.GetItemInSlot(eInvSlot_PrimaryWeapon).HasInfiniteAmmo();
		if (LastActiveUnit != ActiveUnitState.ObjectID || LastPlayerID != CurrentPlayer.ObjectID)
		{
			if (Xtopod == none || InfiniteAmmo)
			{
				Hide();

				`LOG("Xtopod Garage: Ammo screen hidden.");
			}
			else
			{
				Show();
				
				`LOG("Xtopod Garage: Ammo screen shown at " @ string(self.X) @ "," @ string(self.Y) @ ".");
			}

			LastActiveUnit = ActiveUnitState.ObjectID;
		}
		
		if (Xtopod != none && !InfiniteAmmo)
			SetAmmo(Xtopod);
	}
	else if (LastActiveUnit != 0)
	{
		LastActiveUnit = 0;

		Hide();
		
		`LOG("Xtopod Garage: Ammo screen hidden.");
	}

	LastPlayerID = CurrentPlayer.ObjectID;
}

simulated function SetAmmo(XComGameState_Lucu_Garage_XtopodUnitState Xtopod)
{
	local int AmmoCost;

	AmmoCost = GetPotentialAmmoCost();

	if (AmmoCost > 0)
		SetText(AmmoTitle $ ":" @ string(Xtopod.AmmoReserve) @ "(-" $ string(AmmoCost) $ ")");
	else
		SetText(AmmoTitle $ ":" @ string(Xtopod.AmmoReserve));

	Show();
}

simulated function float GetPotentialAmmoCost()
{
	local X2AbilityCost AbilityCost;
	local AvailableAction SelectedAction;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate; 
	local XComGameState_Item ItemState;

	SelectedAction = UITacticalHUD(screen).m_kAbilityHUD.GetSelectedAction();
	
	// -1 or 0 means an invalid ObjectID
	if (SelectedAction.AbilityObjectRef.ObjectID > 0)
	{
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SelectedAction.AbilityObjectRef.ObjectID));
		ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));
	
		AbilityTemplate = AbilityState.GetMyTemplate();
		foreach AbilityTemplate.AbilityCosts(AbilityCost)
		{
			if (AbilityCost.IsA('X2AbilityCost_Lucu_Garage_ReloadAmmo'))
			{
				return X2AbilityCost_Lucu_Garage_ReloadAmmo(AbilityCost).CalculateCost(AbilityState, ItemState);
			}
		}
	}
	return -1;
}
