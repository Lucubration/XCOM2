class X2Effect_Possessed extends X2Effect_Persistent 
	config(GameCore);

var localized string FlyoverText;

//var config array<name> AddPossessedAbilityNames;
var name WeaponTemplateName;

// Update HP and give the Psi Soldier Amp
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;
	local XComGameState_Item NewItem;
	local XComGameState_Unit Unit;
	local X2TacticalGameRuleset TacticalRules;
	local bool bItemAdded;
	local EInventorySlot InventorySlot;
	local int Index;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(WeaponTemplateName));

	NewItem = EquipmentTemplate.CreateInstanceFromTemplate(NewGameState);
	Unit = XComGameState_Unit(kNewTargetState);

	if( Unit != none &&
		NewItem != none )
	{
		bItemAdded = Unit.AddItemToInventory(NewItem, EquipmentTemplate.InventorySlot, NewGameState);

		for( Index = eInvSlot_TertiaryWeapon; !bItemAdded && (Index <= eInvSlot_SeptenaryWeapon); ++Index )
		{
			InventorySlot = EInventorySlot(Index);
			bItemAdded = Unit.AddItemToInventory(NewItem, InventorySlot, NewGameState);
		}
		
		if( !bItemAdded )
		{
			`Redscreen("X2Effect_Possessed: NewItem can't be added to inventory. @gameplay @dslonneger");
		}

		// Reset the abilities
		TacticalRules = `TACTICALRULES;

		Unit.Abilities.Length = 0;
		TacticalRules.InitializeUnitAbilities(NewGameState, Unit);

		Unit.SetBaseMaxStat(eStat_HP, Unit.GetMaxStat(eStat_HP) * 2);	// TODO: when design decides how to modify the HP DO IT
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_PlayAnimation AnimationAction;
	local XComGameState_Unit UnitState;

	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if( UnitState != None && EffectApplyResult == 'AA_Success' )
	{
		AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		AnimationAction.Params.AnimName = 'HL_Psi_MindControlled';

		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.FlyoverText, '', eColor_Good);
	}
}

defaultproperties
{
	EffectName="Possessed"
	WeaponTemplateName ="PsionicSoldier_PsiAmp"
}