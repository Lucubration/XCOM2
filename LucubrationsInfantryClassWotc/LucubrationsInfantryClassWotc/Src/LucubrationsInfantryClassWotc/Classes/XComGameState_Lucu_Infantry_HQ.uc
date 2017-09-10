class XComGameState_Lucu_Infantry_HQ extends XComGameState_BaseObject;

var array<StateObjectReference> ShakeItOffSoldiers;

function bool HasShakeItOffWillBonus(StateObjectReference SoldierRef)
{
    return ShakeItOffSoldiers.Find('ObjectID', SoldierRef.ObjectID) != INDEX_NONE;
}

function AddHasShakeItOffWillBonus(StateObjectReference SoldierRef)
{
    if (ShakeItOffSoldiers.Find('ObjectID', SoldierRef.ObjectID) == INDEX_NONE)
    {
        ShakeItOffSoldiers.AddItem(SoldierRef);
    }
}

function RemoveHasShakeItOffWillBonus(StateObjectReference SoldierRef)
{
    local int iFound;

    iFound = ShakeItOffSoldiers.Find('ObjectID', SoldierRef.ObjectID);
    if (iFound != INDEX_NONE)
    {
        ShakeItOffSoldiers.Remove(iFound, 1);
    }
}
