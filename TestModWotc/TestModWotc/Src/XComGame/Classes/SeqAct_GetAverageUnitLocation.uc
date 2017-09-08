//-----------------------------------------------------------
//Gets the location of an xcom unit
//-----------------------------------------------------------
class SeqAct_GetAverageUnitLocation extends SequenceAction;

var Vector Location;
var protected SeqVar_GameStateList UnitsToCheck; 

event Activated()
{
	local TTile Tile;
	local StateObjectReference GameState;
	local XComGameState_BaseObject BaseObject;
	local XComGameState_Unit Unit;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// Bind the internal list to the SeqVar plugged into the node
	foreach LinkedVariables(class'SeqVar_GameStateList', UnitsToCheck, "Game State List")
	{
		break;
	}

	foreach UnitsToCheck.GameStates(GameState)
	{
		BaseObject = History.GetGameStateForObjectID(GameState.ObjectID);
		Unit = XComGameState_Unit(BaseObject);

		if (Unit != none)
		{
			Tile =  Unit.TileLocation;
			Location += class'XComWorldData'.static.GetWorldData().GetPositionFromTileCoordinates(Tile);
		}
	}

	Location /= UnitsToCheck.GameStates.Length;
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Get Average Location of Units"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Game State List", MinVars=1, MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Location",PropertyName=Location,bWriteable=TRUE)

}
