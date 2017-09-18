class X2TargetingMethod_Lucu_CombatEngineer_DetPack extends X2TargetingMethod_Grenade;

protected function GetTargetedActors(const vector Location, out array<Actor> TargetActors, optional out array<TTile> TargetTiles)
{
	local XComGameStateHistory History;
	local X2AbilityTemplate AbilityTemplate;
    local X2AbilityMultiTarget_Radius AbilityMultiTarget;
    local AvailableTarget MultiTargets;
    local StateObjectReference MultiTargetRef;
    local Actor MultiTarget;
    
	History = `XCOMHISTORY;

	AbilityTemplate = Ability.GetMyTemplate();
    AbilityMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);

    // Get tiles in the blast radius
    AbilityMultiTarget.GetValidTilesForLocation(Ability, Location, TargetTiles);

    // Gather multi-targets for tiles in the blast radius?
    AbilityMultiTarget.GetMultiTargetsForLocation(Ability, Location, MultiTargets);
    foreach MultiTargets.AdditionalTargets(MultiTargetRef)
    {
        MultiTarget = History.GetVisualizer(MultiTargetRef.ObjectID);
        TargetActors.AddItem(MultiTarget);
    }
}
