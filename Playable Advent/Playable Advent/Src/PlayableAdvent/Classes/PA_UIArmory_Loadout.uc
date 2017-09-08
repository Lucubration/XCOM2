class PA_UIArmory_Loadout extends UIArmory_Loadout;

// This would not be necessary if proper support for class specific armor existed.
simulated function string GetDisabledReason(XComGameState_Item Item, EInventorySlot SelectedSlot)
{
	local name UnitName, ItemName;
	ItemName = Item.GetMyTemplateName();
	UnitName = GetUnit().GetMyTemplateName();
	if (SelectedSlot == eInvSlot_Armor)
	{
		if (ItemName == 'PA_BerserkerArmor')
			return (UnitName == 'PA_Berserker') ? "" : "ONLY AVAILABLE TO BERSERKER";
		if (ItemName == 'PA_ChrysArmor')
			return (UnitName == 'PA_Chrys') ? "" : "ONLY AVAILABLE TO CHRYSSALID";
		if (ItemName == 'PA_MecArmor')
			return (UnitName == 'PA_Mec') ? "" : "ONLY AVAILABLE TO MEC";
		if (ItemName == 'PA_MecHeavyArmor')
			return (UnitName == 'PA_Mec') ? "" : "ONLY AVAILABLE TO MEC";
		if (ItemName == 'PA_MutonArmor')
			return (UnitName == 'PA_Muton') ? "" : "ONLY AVAILABLE TO MUTON";
		if (ItemName == 'PA_ViperArmor')
			return (UnitName == 'PA_Viper') ? "" : "ONLY AVAILABLE TO VIPER";
		if (UnitName == 'PA_Berserker') return "NOT AVAILABLE TO BERSERKER";
		if (UnitName == 'PA_Chrys') return "NOT AVAILABLE TO CHRYSSALID";
		if (UnitName == 'PA_Mec') return "NOT AVAILABLE TO MEC";
		if (UnitName == 'PA_Muton') return "NOT AVAILABLE TO MUTON";
		if (UnitName == 'PA_Viper') return "NOT AVAILABLE TO VIPER";
	}
	return super.GetDisabledReason(Item, SelectedSlot);
}
