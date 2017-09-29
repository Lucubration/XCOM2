class X2AbilityTarget_Lucu_CombatEngineer_DeployableCover extends X2AbilityTarget_Cursor;

var float AbilityRangeInUnits;

simulated function float GetCursorRangeMeters(XComGameState_Ability AbilityState)
{
    return default.AbilityRangeInUnits;
}

DefaultProperties
{
    AbilityRangeInUnits=96
}