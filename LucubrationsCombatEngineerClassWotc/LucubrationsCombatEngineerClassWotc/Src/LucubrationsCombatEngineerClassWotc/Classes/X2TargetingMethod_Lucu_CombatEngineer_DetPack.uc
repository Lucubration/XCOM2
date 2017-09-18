class X2TargetingMethod_Lucu_CombatEngineer_DetPack extends X2TargetingMethod_Grenade;

protected function GetTargetedActors(const vector Location, out array<Actor> TargetActors, optional out array<TTile> TargetTiles)
{
	local X2AbilityTemplate AbilityTemplate;
    local X2AbilityMultiTarget_Radius AbilityMultiTarget;
    
	AbilityTemplate = Ability.GetMyTemplate();
    AbilityMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);

    // Get tiles in the blast radius using ability targeting logic
    AbilityMultiTarget.GetValidTilesForLocation(Ability, Location, TargetTiles);

    // Gather multi-targets for tiles in the blast radius using native logic?
    // TODO: Figure out why we don't get destructibles in our final actors list
    GetTargetedActorsInTiles(TargetTiles, TargetActors, false);
}
