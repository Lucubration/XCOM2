class X2Effect_Lucu_CombatEngineer_SpawnDeployable extends X2Effect_SpawnDestructible;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
    local XComGameState_Item SourceItem;
    local X2DeployableTemplate_Lucu_CombatEngineer SourceItemTemplate;
    
	History = `XCOMHISTORY;

    // Find and set the destructible archetype just before the effect spawns it
    SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityInputContext.ItemObject.ObjectID));
    if (SourceItem == none)
    {
        SourceItem = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityInputContext.ItemObject.ObjectID));
    }
    `assert(SourceItem != none);

    SourceItemTemplate = X2DeployableTemplate_Lucu_CombatEngineer(SourceItem.GetMyTemplate());
    `assert(SourceItemTemplate != none);

    DestructibleArchetype = SourceItemTemplate.SpawnedDestructibleArchetype;

    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}