class X2FocusLootItemTemplate extends X2ItemTemplate;

var() int FocusAmount;

function bool CanBeLootedByUnit(XComGameState_Item LootItem, XComGameState_Unit Looter, Lootable LootableObject)
{
	local XComGameState_Effect_TemplarFocus FocusState;

	if ( Looter.HasSoldierAbility('Channel') )
	{
		//	Prevent looting if the templar already has max focus, since it would be a waste
		FocusState = Looter.GetTemplarFocusEffectState();
		if (FocusState != none && FocusState.FocusLevel < FocusState.GetMaxFocus(Looter))
		{
			return true;
		}
	}
	return false;
}

DefaultProperties
{
	iItemSize = 0
	FocusAmount = 1
	ItemCat = "utility"
}