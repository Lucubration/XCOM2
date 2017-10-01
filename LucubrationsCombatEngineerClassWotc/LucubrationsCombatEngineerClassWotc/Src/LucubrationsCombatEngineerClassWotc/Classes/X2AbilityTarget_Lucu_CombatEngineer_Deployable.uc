class X2AbilityTarget_Lucu_CombatEngineer_Deployable extends X2AbilityTarget_Cursor
	config(Lucu_CombatEngineer_Ability);

var config float RapidDeploymentBonusRange;

simulated function float GetCursorRangeMeters(XComGameState_Ability AbilityState)
{
	local XComGameStateHistory History;
	local XComGameState_Item SourceWeapon;
    local XComGameState_Unit Shooter;
    local X2DeployableTemplate_Lucu_CombatEngineer WeaponTemplate;
    local float TargetRange;
    
	History = `XCOMHISTORY;

	SourceWeapon = AbilityState.GetSourceWeapon();
    WeaponTemplate = X2DeployableTemplate_Lucu_CombatEngineer(SourceWeapon.GetMyTemplate());
    TargetRange = WeaponTemplate.fRange;
	Shooter = XComGameState_Unit(History.GetGameStateForObjectID(SourceWeapon.OwnerStateObject.ObjectID));

    if (Shooter.FindAbility(class'X2Ability_Lucu_CombatEngineer_CombatEngineerAbilitySet'.default.RapidDeploymentTemplateName).ObjectID > 0)
    {
        TargetRange += default.RapidDeploymentBonusRange;
    }

    return `UNITSTOMETERS(TargetRange);
}
