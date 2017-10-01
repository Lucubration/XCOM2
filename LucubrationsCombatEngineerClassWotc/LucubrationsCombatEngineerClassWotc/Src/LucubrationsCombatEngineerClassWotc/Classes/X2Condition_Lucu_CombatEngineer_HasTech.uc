class X2Condition_Lucu_CombatEngineer_HasTech extends X2Condition;

var array<name> TechNames;
var bool HasTech;

function name AbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
    local name TechName;
    
	History = `XCOMHISTORY;

	XComHQ = XComGameState_HeadquartersXCom( History.GetSingleGameStateObjectForClass( class'XComGameState_HeadquartersXCom' ) );

    foreach TechNames(TechName)
    {
        if (XComHQ.IsTechResearched(TechName))
        {
            if (!HasTech)
            {
                return 'AA_MissingRequiredEffect';
            }
        }
        else if (HasTech)
        {
            return 'AA_MissingRequiredEffect';
        }
    }

    return 'AA_Success';
}

DefaultProperties
{
    HasTech=true
}