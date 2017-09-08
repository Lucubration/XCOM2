class X2Effect_Beags_Escalation_TransientUtilityItem extends X2Effect_Persistent;

var name AbilityTemplateName;			// Ability template name for attaching the item
var name ItemTemplateName;				// Item template for the transient item
var int ClipSize;						// If set > 0, override the template clip size
var bool LookForItemUpgrades;			// If set, effect will look for upgrades to item template

var bool UseItemAsAmmo;					// Item is used as ammo source for ability, not weapon

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory											History;
	local X2TacticalGameRuleset											Rules;
	local bool															CreatedNewItem;
	local XComGameState_Unit											UnitState;
	local name															TransientItemTemplateName;
	local XComGameState_Item											TransientItemState;
	local X2WeaponTemplate												TransientItemTemplate;
	local XComGameState_Beags_Escalation_Effect_TransientUtilityItem	TransientItemEffectState;
	local XGInventoryItem												TransientItemVisualizer;
	local XComWeapon													TransientItemWeapon;
	local StateObjectReference											AbilityRef, SourceWeaponRef, SourceAmmoRef, ItemSetAbilityRef;
	local X2AbilityTemplate												AbilityTemplate;
	local XComGameState_Ability											ItemSetAbilityState, AbilityState;
	local X2EventManager												EventMgr;
	local Object														ListenerObj;

	History = `XCOMHISTORY;

	if (GetEffectComponent(NewEffectState) == none)
	{
		UnitState = XComGameState_Unit(kNewTargetState);
		if (UnitState != none)
		{
			TransientItemTemplateName = ItemTemplateName;
			if (LookForItemUpgrades)
				TransientItemTemplateName = FindUpgradeItemTemplateName(TransientItemTemplateName);

			TransientItemTemplate = X2WeaponTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(TransientItemTemplateName));
			if (TransientItemTemplate != none && TransientItemTemplate.InventorySlot == eInvSlot_Utility)
			{
				// Check for whether the unit has this item already
				TransientItemState = GetItemOfTemplateName(UnitState, TransientItemTemplateName);

				CreatedNewItem = false;
				if (TransientItemState == none)
				{
					// The unit doesn't have this item already (in which case we would add ammo), so we need to create it

					// Create an instance of the item
					TransientItemState = TransientItemTemplate.CreateInstanceFromTemplate(NewGameState);
					NewGameState.AddStateObject(TransientItemState);

					CreatedNewItem = true;

					`LOG("Beags Escalation: Transient Item " @ TransientItemState.GetMyTemplateName() @ " state created.");

					// Add the transient item to the GameState_Unit inventory, adding the new state object to the NewGameState container
					UnitState.AddItemToInventory(TransientItemState, eInvSlot_Utility, NewGameState);

					// At this point we've created the item and added it to the unit's inventory, but the ability still doesn't know about it.

					if (UseItemAsAmmo)
					{
						// If the item should be used as a weapon, set the source ammo reference
						SourceAmmoRef = TransientItemState.GetReference();
						
						// Look up the source weapon from the ability applying this effect
						AbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
						if (AbilityState == none)
							AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
						if (AbilityState != none)
							SourceWeaponRef = AbilityState.GetSourceWeapon().GetReference();
					}
					else
					{
						// If the item should be used as a weapon, just set the source weapon reference. Ammo will remain an empty reference
						SourceWeaponRef = TransientItemState.GetReference();
					}

					ItemSetAbilityRef = FindAbility(UnitState, AbilityTemplateName, SourceWeaponRef, SourceAmmoRef);
					ItemSetAbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ItemSetAbilityRef.ObjectID));
					if (ItemSetAbilityState == none)
						ItemSetAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ItemSetAbilityRef.ObjectID));
					if (ItemSetAbilityState != none)
					{
						// Update the existing ability to have the source weapon and ammo references (for charges in the UI)
						ItemSetAbilityState.SourceWeapon.ObjectID = SourceWeaponRef.ObjectID;
						ItemSetAbilityState.SourceAmmo.ObjectID = SourceAmmoRef.ObjectID;

						if (SourceAmmoRef.ObjectID > 0)
							`LOG("Beags Escalation: Transient Item " @ TransientItemState.GetMyTemplateName() @ " set as source ammo for unit " @ UnitState.GetFullName() @ " ability " @ AbilityTemplateName @ ".");
						else
							`LOG("Beags Escalation: Transient Item " @ TransientItemState.GetMyTemplateName() @ " set as source weapon for unit " @ UnitState.GetFullName() @ " ability " @ AbilityTemplateName @ ".");
					}
					else
					{
						// Create a new ability
						AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityTemplateName);
						if (AbilityTemplate != none)
						{
							Rules = `TACTICALRULES;
							AbilityRef = Rules.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState, SourceWeaponRef, SourceAmmoRef); // I LAUGH IN THE FACE OF DANGER.

							`LOG("Beags Escalation: Transient Item " @ TransientItemState.GetMyTemplateName() @ " ability state " @ AbilityTemplateName @ " created and added to unit " @ UnitState.GetFullName() @ ".");
						}
						else
						{
							`LOG("Beags Escalation: Transient Item " @ TransientItemState.GetMyTemplateName() @ " ability state " @ AbilityTemplateName @ " not created for unit " @ UnitState.GetFullName() @ " (ability template not found).");
						}
					}

					`LOG("Beags Escalation: Transient Item " @ TransientItemState.GetMyTemplateName() @ " added to unit " @ UnitState.GetFullName() @ " inventory.");
					
					//---------------------------------------------------------------------------------------------------
					// Begin Black Magic
					//---------------------------------------------------------------------------------------------------

					// Now create the item visualizer so that it appears in-game. The unit's visualizer (and pawn and entity and whatever?) are already
					// created, so we need to catch up here and get this item appearing in-game for consistency
					TransientItemVisualizer = XGInventoryItem(TransientItemState.GetVisualizer());	
					if (TransientItemVisualizer == none)
					{
						class'XGItem'.static.CreateVisualizer(TransientItemState);
						TransientItemVisualizer = XGInventoryItem(TransientItemState.GetVisualizer());
					}
					
					// Create the item... entity? Is that the mesh? I don't know
					if (TransientItemVisualizer != none && (TransientItemVisualizer.m_kOwner == none || TransientItemVisualizer.m_kEntity == none))
					{
						TransientItemVisualizer.m_kOwner = XGUnit(UnitState.GetVisualizer());
						TransientItemVisualizer.m_kEntity = TransientItemVisualizer.CreateEntity(TransientItemState);

						// Have no idea what this does, but it seems important
						TransientItemWeapon = XComWeapon(TransientItemVisualizer.m_kEntity);
						if (TransientItemWeapon != none)
						{
							TransientItemWeapon.m_kPawn = XGUnit(UnitState.GetVisualizer()).GetPawn();
						}
					}

					// Add it to the unit's visual inventory (I guess?)
					if (TransientItemVisualizer != none && TransientItemVisualizer.m_kEntity != none)
					{
						XGUnit(UnitState.GetVisualizer()).GetInventory().AddItem(TransientItemVisualizer, TransientItemState.ItemLocation, TransientItemState.ItemLocation == eSlot_RearBackPack);
					}
					
					//---------------------------------------------------------------------------------------------------
					// End Black Magic
					//---------------------------------------------------------------------------------------------------
				}
				else
				{
					// The unit has this item already, so we'll just add ammo to it
					if (TransientItemTemplate != none && TransientItemTemplate.bMergeAmmo)
					{
						if (ClipSize == 0)
							ClipSize = TransientItemTemplate.iClipSize;

						TransientItemState.Ammo += ClipSize;

						`LOG("Beags Escalation: Transient Item " @ TransientItemState.GetMyTemplateName() @ " merged " @ string(TransientItemTemplate.iClipSize) @ " ammo into unit " @ UnitState.GetFullName() @ " inventory.");
					}
					else
						`LOG("Beags Escalation: Transient Item " @ TransientItemState.GetMyTemplateName() @ " not added to unit " @ UnitState.GetFullName() @ " inventory (duplicate item).");
				}

				// Create effect component and attach it to GameState_Effect, adding the new state object to the NewGameState container
				TransientItemEffectState = XComGameState_Beags_Escalation_Effect_TransientUtilityItem(NewGameState.CreateStateObject(class'XComGameState_Beags_Escalation_Effect_TransientUtilityItem'));
				if (CreatedNewItem)
				{
					// Only set these values if we created an item. If we didn't create an item, we don't want to store these and delete the item
					// later because it's a real item and not a transient item
					TransientItemEffectState.UnitRef = UnitState.GetReference();
					TransientItemEffectState.ItemRef = TransientItemState.GetReference();
					if (AbilityRef.ObjectID > 0)
						TransientItemEffectState.AbilityRef = AbilityRef;
					if (ItemSetAbilityState != none)
						TransientItemEffectState.ItemSetAbilityRef = ItemSetAbilityState.GetReference();
				}
				NewEffectState.AddComponentObject(TransientItemEffectState);
				NewGameState.AddStateObject(TransientItemEffectState);

				EventMgr = `XEVENTMGR;
	
				// The gamestate component should handle the callback
				ListenerObj = TransientItemEffectState;

				// Some missions the effect will be removed (e.g. extraction), some missions the tactical gameplay just stops. We'll GC our gamestate
				// by having the gamestate itself handle this callback
				EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', TransientItemEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);

				`LOG("Beags Escalation: Transient Item passive effect registered for events.");
			}
			else
			{
				`LOG("Beags Escalation: Transient Item effect inventory item not added (utility weapon template not found).");
			}
		}
		else
		{
			`LOG("Beags Escalation: Transient Item effect inventory item not added (unit state not found).");
		}
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function name FindUpgradeItemTemplateName(name TemplateName)
{
	local XComGameStateHistory				History;
	local XComGameState_HeadquartersXCom	XComHQ;
	local X2ItemTemplateManager				ItemTemplateManager;
	local X2ItemTemplate					UpgradeTemplate;
	
	History = `XCOMHISTORY;
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	// Look for any item templates marked as upgrades for this one
	UpgradeTemplate = ItemTemplateManager.GetUpgradedItemTemplateFromBase(TemplateName);
	// Check if we have it in HQ
	if (XComHQ.GetNumItemInInventory(UpgradeTemplate.DataName) > 0)
	{
		// Prevent infinite recursion
		if (UpgradeTemplate.DataName != TemplateName)
		{
			// Check for upgrades of the upgrade
			return FindUpgradeItemTemplateName(UpgradeTemplate.DataName);
		}

		return UpgradeTemplate.DataName;
	}

	// No upgrade found
	return TemplateName;
}

static function StateObjectReference FindAbility(XComGameState_Unit UnitState, name TemplateName, StateObjectReference MatchSourceWeapon, StateObjectReference MatchSourceAmmo)
{
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local StateObjectReference ObjRef, EmptyRef;

	History = `XCOMHISTORY;

	foreach UnitState.Abilities(ObjRef)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ObjRef.ObjectID));
		if (AbilityState.GetMyTemplateName() == TemplateName)
		{
			// If MatchSourceWeapon is set, we find either an ability matching the source weapon reference or matching NO source weapon
			if (MatchSourceWeapon.ObjectID > 0 && AbilityState.SourceWeapon.ObjectID > 0 &&
				MatchSourceWeapon.ObjectID != AbilityState.SourceWeapon.ObjectID)
				continue;
			// If MatchSourceAmmo is set, we find either an ability matching the source ammo reference or matching NO source ammo
			if (MatchSourceAmmo.ObjectID > 0 && AbilityState.SourceAmmo.ObjectID > 0 &&
				MatchSourceAmmo.ObjectID != AbilityState.SourceAmmo.ObjectID)
				continue;

			return ObjRef;
		}
	}

	return EmptyRef;
}

static function XComGameState_Beags_Escalation_Effect_TransientUtilityItem GetEffectComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Beags_Escalation_Effect_TransientUtilityItem(Effect.FindComponentObject(class'XComGameState_Beags_Escalation_Effect_TransientUtilityItem'));
    return none;
}

static function XComGameState_Item GetItemOfTemplateName(XComGameState_Unit UnitState, name TemplateName)
{
	local array<XComGameState_Item> ItemStates;
	local XComGameState_Item ItemState;
	local int i;

	ItemStates = UnitState.GetAllInventoryItems();

	for (i = 0; i < ItemStates.Length; ++i)
	{
		ItemState = ItemStates[i];

		if (ItemState != none && ItemState.GetMyTemplateName() == TemplateName)
			return ItemState;
	}

	return none;
}

DefaultProperties
{
	LookForItemUpgrades=true
}