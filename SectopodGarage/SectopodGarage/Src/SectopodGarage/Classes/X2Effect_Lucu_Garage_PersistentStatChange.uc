class X2Effect_Lucu_Garage_PersistentStatChange extends X2Effect_ModifyStats;

struct native XtopodStatChange
{
	var ECharStatType   StatType;
	var float           StatAmount;
	var bool			ScaleWithChassis;
	var EStatModOp		ModOp;
	var ECharStatModApplicationRule ApplicationRule;

	structdefaultproperties
	{
		ApplicationRule=ECSMAR_Additive
	}
};

var array<XtopodStatChange>	m_aStatChanges;

simulated function AddPersistentStatChange(ECharStatType StatType, float StatAmount, bool ScaleWithChassis, optional EStatModOp InModOp=MODOP_Addition)
{
	local XtopodStatChange NewChange;
	
	NewChange.StatType = StatType;
	NewChange.StatAmount = StatAmount;
	NewChange.ScaleWithChassis = ScaleWithChassis;
	NewChange.ModOp = InModOp;

	m_aStatChanges.AddItem(NewChange);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit Source;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local XComGameState_Item ChassisUpgrade;
	local int ChassisTier, i;
	local XtopodStatChange Change;
	local array<StatChange> Changes;
	local StatChange NewChange;
	local bool Added;

	History = `XCOMHISTORY;

	ChassisTier = 0;

	Source = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityInputContext.SourceObject.ObjectID));
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
	Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(Source, Facility);
	ChassisUpgrade = Xtopod.GetItemInCategory('lucu_garage_chassis');
	if (ChassisUpgrade != none)
		ChassisTier = ChassisUpgrade.GetMyTemplate().Tier;

	Changes.Length = 0;
	foreach m_aStatChanges(Change)
	{
		Added = false;
		for (i = 0; i < Changes.Length; i++)
		{
			if (Changes[i].StatType == Change.StatType && Changes[i].ModOp == Change.ModOp)
			{
				Changes[i].StatAmount += Change.ScaleWithChassis ? Change.StatAmount * ChassisTier : Change.StatAmount;
				Added = true;
				break;
			}
		}

		if (!Added)
		{
			NewChange.StatType = Change.StatType;
			NewChange.StatAmount = Change.ScaleWithChassis ? Change.StatAmount * ChassisTier : Change.StatAmount;
			NewChange.ModOp = Change.ModOp;
			Changes.AddItem(NewChange);
		}
	}

	NewEffectState.StatChanges = Changes;
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}