class Lucu_CombatEngineer_Utilities extends Object;

static function bool IsDetPackArchetype(string ArchetypeName)
{
    return ArchetypeName == class'X2Item_Lucu_CombatEngineer_Weapons'.default.DetPackDestructibleArchetype ||
           ArchetypeName == class'X2Item_Lucu_CombatEngineer_Weapons'.default.PlasmaPackDestructibleArchetype;
}
