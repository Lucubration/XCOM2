class X2ItemTemplate_Lucu_Garage extends X2WeaponUpgradeTemplate;

struct UIStatMarkup_Lucu_Garage
{
	var() localized string StatLabel;		// The user-friendly label associated with this modifier
	var() int StatModifier;
	var() ECharStatType StatType;			// The stat type of this markup (if applicable)
	var() bool ScaleWithChassis;			// The stat markup scales with the chassis upgrade tier
};

var(X2EquipmentTemplate) array<UIStatMarkup_Lucu_Garage>	UIStatMarkups;			//  Values to display in the UI (so we don't have to dig through abilities and effects)

function SetUIStatMarkup(String InLabel,
	optional ECharStatType InStatType,
	optional int Amount,
	optional bool ScaleWithChassis)
{
	local UIStatMarkup_Lucu_Garage StatMarkup;

	StatMarkup.StatLabel = InLabel;
	StatMarkup.StatModifier = Amount;
	StatMarkup.StatType = InStatType;
	StatMarkup.ScaleWithChassis = ScaleWithChassis;
			
	UIStatMarkups.AddItem(StatMarkup);
}

function int GetUIStatMarkup(ECharStatType Stat, optional XComGameState_Item Item)
{
	local XComGameStateHistory History;
	local XComGameState_Unit Owner;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Lucu_Garage_Facility Facility;
	local XComGameState_Lucu_Garage_XtopodUnitState Xtopod;
	local XComGameState_Item ChassisUpgrade;
	local UIStatMarkup_Lucu_Garage StatMarkup;
	local int i;

	History = `XCOMHISTORY;

	Owner = XComGameState_Unit(History.GetGameStateForObjectID(Item.OwnerStateObject.ObjectID));
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Facility = class'Lucu_Garage_Utilities'.static.GetFacilityComponent(XComHQ);
	Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(Owner, Facility);

	for (i = 0; i < UIStatMarkups.Length; i++)
	{
		StatMarkup = UIStatMarkups[i];
		if (StatMarkup.StatType == Stat)
		{
			if (StatMarkup.ScaleWithChassis)
			{
				ChassisUpgrade = Xtopod.GetItemInCategory('lucu_garage_chassis');
				if (ChassisUpgrade != none)
					return ChassisUpgrade.GetMyTemplate().Tier * StatMarkup.StatModifier * Item.Quantity;
			}

			return StatMarkup.StatModifier * Item.Quantity;
		}
	}

	return 0;
}
