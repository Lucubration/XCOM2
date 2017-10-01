class X2Condition_Lucu_CombatEngineer_TargetHasAbility extends X2Condition;

var array<name> AbilityNames;
var bool TargetHasAbility;

function name AbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit Target;
    local name AbilityName;

    Target = XComGameState_Unit(kTarget);

    foreach AbilityNames(AbilityName)
    {
        if (Target.FindAbility(AbilityName).ObjectID > 0)
        {
            if (!TargetHasAbility)
            {
                return 'AA_MissingRequiredEffect';
            }
        }
        else if (TargetHasAbility)
        {
            return 'AA_MissingRequiredEffect';
        }
    }

    return 'AA_Success';
}

DefaultProperties
{
    TargetHasAbility=true
}